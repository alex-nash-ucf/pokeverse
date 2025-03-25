const http = require('http');

const hostname = 'localhost'; // Localhost

const express = require('express');
const axios = require('axios');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors'); // Enable Cross-Origin Resource Sharing

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
    hpEV: { type: Number, default: 0 }, // Effort Value in HP
    attackEV: { type: Number, default: 0 }, // Effort Value in Attack
    defenseEV: { type: Number, default: 0 }, // Effort Value in Defense
    specialAttackEV: { type: Number, default: 0 }, // Effort Value in Special Attack
    specialDefenseEV: { type: Number, default: 0 }, // Effort Value in Special Defense
    speedEV: { type: Number, default: 0 },
    hpIV: { type: Number, default: 0 }, // Individual Value in HP
    attackIV: { type: Number, default: 0 }, // Individual Value in Attack
    defenseIV: { type: Number, default: 0 }, // Individual Value in Defense
    specialAttackIV: { type: Number, default: 0 }, // Individual Value in Special Attack
    specialDefenseIV: { type: Number, default: 0 }, // Individual Value in Special Defense
    speedIV: { type: Number, default: 0 },
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

    var ret = { id: user._id, user: user.username, email: user.email };
    res.status(200).json(ret);

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

async function getPokemonColor(speciesUrl) {
  try {
    const speciesResponse = await axios.get(speciesUrl);
    return speciesResponse.data.color.name;
  } catch (error) {
    console.error('Error fetching Pokemon species:', error);
    return null;
  }
}

app.get('/pokemon/search/:query', async (req, res) => {
  const query = req.params.query.toLowerCase();

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
    res.json(simplifiedPokemon);
    return;

  } catch (nameError) {
    try {
      const speciesResponse = await axios.get(`https://pokeapi.co/api/v2/pokemon-species/?limit=50`);
      const results = speciesResponse.data.results;
      const matchingPokemon = results.filter(pokemon => pokemon.name.includes(query));

      if (matchingPokemon.length > 0) {
        const simplifiedPokemonList = await Promise.all(
          matchingPokemon.map(async (pokemon) => {
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
              return null; // Or handle the error as needed
            }
          })
        );
        res.json(simplifiedPokemonList.filter(p => p !== null)); // Filter out any errors
      } else {
        res.status(404).json({ message: 'Pokemon not found' });
      }
    } catch (speciesError) {
      console.error('Error during species search:', speciesError);
      res.status(500).json({ message: 'Internal server error' });
    }
  }
});

// Auxiliar functions

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

