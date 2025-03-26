const http = require('http');

const hostname = 'localhost'; // Localhost

const express = require('express');
const axios = require('axios');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors'); // Enable Cross-Origin Resource Sharing
const jwt =require('jsonwebtoken');
const app = express();
const PORT = 5001; // Choose a port

require('dotenv').config();
const MONGODB_URI = process.env.MONGODB_URI;

mongoose.connect(MONGODB_URI, {
}).then(() =>
  {console.log('MongoDB Connected');})
.catch(err => console.error('MongoDB Connection Error:', err));

app.use(cors()); // Enable CORS for all routes
app.use(bodyParser.json()); // to parse JSON data

const temporaryAccountSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
});

const temporaryAccount = mongoose.model('temporaryAccount', temporaryAccountSchema);


const accountSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  teams: [{ // Array of teams
    name: { type: String, required: true }, // Name of the team (e.g., "Main Team", "Battle Team")
    pokemon: [{ type: mongoose.Schema.Types.ObjectId, ref: 'pokemonSchema' }] // Array of Pokemon references
  }],

});

accountSchema.pre('save', function (next) {
  for (const team of this.teams) {
    if (team.pokemon.length > 6) {
      return next(new Error(`Team "${team.name}" exceeds the maximum of 6 Pokemon.`));
    }
  }
  next();
});

const Account = mongoose.model('Account', accountSchema);

const pokemonSchema = new mongoose.Schema({
    name: { type: String, required: true }, // Pokemon name
    nickname: { type: String },
    ability: { type: String, required: true },
    moves: {
      type: [String],
      default: [null, null, null, null],
      validate: {
        validator: function (v) {
          return v.length === 4;
        },
        message: props => `${props.value} must have exactly 4 elements.`
      },
    },
    
});

const Pokemon = mongoose.model('Pokemon', pokemonSchema);

// API Endpoints:

// Login In
app.post("/userlogin", async (req, res) =>{
  try
  {
    const { login, password } = req.body;
    const user = await Account.findOne({ username: login, password: password })

    if (!user) 
    {
      return res.status(401).json({ error: "Invalid username or password" });
    }

    const token = jwt.sign(
      { id: user._id , username: user.username},
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    res.status(200).json({ token });

  }

  catch(error)
  {
    console.error = ('Invalid user name/password', error);
    res.status(500).json({error: 'Failed to login'});
  }

});

// Example: Get all users (Mostly for testing you can probably remove it)
app.get('/users', async (req, res) => {
    try {
      const users = await Account.find();
      res.json(users);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch users' });
    }
  });

// Example: Create a new user (You should probably change the name to register, this is just for database testing)
app.post('/addUser', async (req, res) => {
  
    try {
      res.status(201).json(newAccount); // 201 Created status code
    } catch (error) {
      res.status(500).json({ error: 'Failed to create user' });
    }
  });

app.delete('/users/:id', async (req, res) => { // Delete user (We probably won't need this but it's here nonetheless)
  try {
      const userId = req.params.id;
      await User.findByIdAndDelete(userId);
      res.status(200).json({ message: 'User deleted successfully' });
  } catch (error) {
      console.error('Error deleting user:', error);
      res.status(500).json({ error: 'Failed to delete user' });
  }
});

app.get('/verify', async (req, res) => {
  const token = req.headers.authorization?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    res.send("Success");
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
});

async function getPokemonColor(speciesUrl) {
  try {
    const speciesResponse = await axios.get(speciesUrl);
    return speciesResponse.data.color.name;
  } catch (error) {
    console.error('Error fetching Pokemon species:', error);
    return null;
  }
}

const DEFAULT_LIMIT = 20;

app.get('/pokemon/search/:query', async (req, res) => {
  const query = req.params.query.toLowerCase();
  const limit = parseInt(req.query.limit) || DEFAULT_LIMIT;
  const offset = parseInt(req.query.offset) || 0;

  try {
      const pokemonResponse = await axios.get(`https://pokeapi.co/api/v2/pokemon/${query}`);
      const speciesUrl = pokemonResponse.data.species.url;
      const color = await getPokemonColor(speciesUrl);

      const simplifiedPokemon = {
          name: pokemonResponse.data.name,
          types: pokemonResponse.data.types.map(type => type.type.name),
          pokedexNumber: pokemonResponse.data.id,
          color: color,
      };
      res.json([simplifiedPokemon]); // For direct match, count is 1
      return;

  } catch (nameError) {
      try {
          const speciesResponse = await axios.get(`https://pokeapi.co/api/v2/pokemon-species/?limit=10000`); // Get all for counting
          const allMatchingPokemon = query !== ''
          ? speciesResponse.data.results.filter(pokemon => pokemon.name.includes(query))
          : speciesResponse.data.results;
          const paginatedMatchingPokemon = allMatchingPokemon.slice(offset, offset + limit);

          if (paginatedMatchingPokemon.length > 0) {
              const simplifiedPokemonList = await Promise.all(
                  paginatedMatchingPokemon.map(async (pokemon) => {
                      try {
                          const pokemonDataResponse = await axios.get(pokemon.url.replace("-species", ""));
                          const speciesUrl = pokemonDataResponse.data.species.url;
                          const color = await getPokemonColor(speciesUrl);
                          return {
                              name: pokemonDataResponse.data.name,
                              types: pokemonDataResponse.data.types.map(type => type.type.name),
                              pokedexNumber: pokemonDataResponse.data.id,
                              color: color,
                          };
                      } catch (error) {
                          console.error('Error fetching detailed Pokemon data:', error);
                          return null;
                      }
                  })
              );
              res.json(simplifiedPokemonList.filter(p => p !== null));
          } else {
              res.status(404).json({ message: 'Pokemon not found' });
          }
      } catch (speciesError) {
          console.error('Error during species search:', speciesError);
          res.status(500).json({ message: 'Internal server error' });
      }
  }
});

app.get('/pokemon/search/', async (req, res) => {
  const limit = parseInt(req.query.limit) || DEFAULT_LIMIT;
  const offset = parseInt(req.query.offset) || 0;
  try{
          const speciesResponse = await axios.get(`https://pokeapi.co/api/v2/pokemon-species/?limit=10000`); // Get all for counting
          const allMatchingPokemon = speciesResponse.data.results;
          const paginatedMatchingPokemon = allMatchingPokemon.slice(offset, offset + limit);

          if (paginatedMatchingPokemon.length > 0) {
              const simplifiedPokemonList = await Promise.all(
                  paginatedMatchingPokemon.map(async (pokemon) => {
                      try {
                          const pokemonDataResponse = await axios.get(pokemon.url.replace("-species", ""));
                          const speciesUrl = pokemonDataResponse.data.species.url;
                          const color = await getPokemonColor(speciesUrl);
                          return {
                              name: pokemonDataResponse.data.name,
                              types: pokemonDataResponse.data.types.map(type => type.type.name),
                              pokedexNumber: pokemonDataResponse.data.id,
                              color: color,
                          };
                      } catch (error) {
                          console.error('Error fetching detailed Pokemon data:', error);
                          return null;
                      }
                  })
              );
              res.json(simplifiedPokemonList.filter(p => p !== null));
          } else {
              res.status(404).json({ message: 'Pokemon not found' });
          }
      } catch (speciesError) {
          console.error('Error during species search:', speciesError);
          res.status(500).json({ message: 'Internal server error' });
      }
  }
);

app.get('/pokemon-abilities/:query', async (req, res) => {
  const query = req.params.query.toLowerCase();

  try {
    // 1. Fetch Pokemon Species data by name
    const speciesResponse = await axios.get(`https://pokeapi.co/api/v2/pokemon-species/${query}`);

    // 2. Extract the URL of the default Pokemon variant
    const defaultPokemonUrl = speciesResponse.data.varieties.find(variety => variety.is_default)?.pokemon.url;

    if (!defaultPokemonUrl) {
      return res.status(404).json({ message: `No default Pokemon found for species: ${query}` });
    }

    // 3. Fetch the default Pokemon data to get abilities
    const pokemonResponse = await axios.get(defaultPokemonUrl);
    const abilities = pokemonResponse.data.abilities.map(abilityEntry => ({
      name: abilityEntry.ability.name,
      url: abilityEntry.ability.url,
      is_hidden: abilityEntry.is_hidden,
      slot: abilityEntry.slot,
    }));

    res.json(
      abilities
    );

  } catch (error) {
    if (error.response && error.response.status === 404) {
      return res.status(404).json({ message: `Pokemon species not found: ${query}` });
    }
    console.error('Error fetching Pokemon abilities:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Auxiliar functions

/* Example of accountData
const accountData = { 
  username: "ash123",
  password: "hashed_password",
  email: "ash@example.com",
};
*/

async function createTemporaryAccount(accountData) {
  try {
    
    const newAccount = new temporaryAccountAccount(accountData);
    const savedAccount = await newAccount.save();
    console.log('Temporary Account created:', savedAccount);
    return savedAccount;
  } catch (error) {
    console.error('Error creating account:', error);
    throw error;
  }
}

async function createAccount(accountData) {
  try {
    const newAccount = new Account(accountData);

    // Create the initial empty team
    newAccount.teams = [{ name: "My Team", pokemon: [] }];

    const savedAccount = await newAccount.save();
    console.log('Account created:', savedAccount);
    return savedAccount;
  } catch (error) {
    console.error('Error creating account:', error);
    throw error;
  }
}


app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

