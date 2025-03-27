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
    nickname: { type: String, default: null },
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

// Auxiliar functions

const verifyToken = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'No token provided or invalid format.' });
  }

  const token = authHeader.split(' ')[1]; // Extract the token after "Bearer "

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      return res.status(403).json({ message: 'Failed to authenticate token.' });
    }
    req.id = decoded.id;
    req.username = decoded.username;
    next();
  });

}
/* Example of accountData
const accountData = { 
  username: "ash123",
  password: "hashed_password",
  email: "ash@example.com",
};
*/
// Helper function to fetch moves for a Pokemon species from your /pokemon-moves endpoint
const fetchAbilities = async (speciesName) => {
  try {
    const response = await axios.get(`https://pokeapi.co/api/v2/pokemon/${speciesName.toLowerCase()}`);
    return response.data.abilities.map(ab => ab.ability.name);
  } catch (error) {
    console.error('Error fetching abilities:', error);
    return [];
  }
};

// Helper function to fetch moves for a Pokemon species from your /pokemon-moves endpoint
const fetchDefaultMoves = async (speciesName) => {
  try {
    const response = await axios.get(`http://localhost:5001/pokemon-moves/${speciesName}`); // Adjust path if needed
    return response.data.slice(0, 4).map(move => move.name);
  } catch (error) {
    console.error('Error fetching default moves:', error);
    return [null, null, null, null];
  }
};


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

/*
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
*/

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

app.get('/getTeams', verifyToken, async (req, res) => {
  const userId = req.id;

  try {
    // Find the account by user ID and select only the teams array
    const account = await Account.findById(userId).select('teams');

    if (!account) {
      return res.status(404).json({ message: 'Account not found for this user.' });
    }

    res.json(account.teams);

  } catch (error) {
    console.error('Error fetching teams:', error);
    res.status(500).json({ message: 'Internal server error while fetching teams.' });
  }
});

app.post('/addTeam', verifyToken, async (req, res) => {
  const userId = req.id;
  const { teamName } = req.body;

  if (!teamName) {
    return res.status(400).json({ error: 'Team name is required.' });
  }

  try {
    const account = await Account.findById(userId);
    if (!account) {
      return res.status(404).json({ error: 'Account not found for this user.' });
    }

    const newTeam = { name: teamName, pokemon: [] };
    account.teams.push(newTeam);
    await account.save();

    res.status(201).json({ message: 'New empty team added successfully.', team: newTeam });
  } catch (error) {
    console.error('Error adding team:', error);
    res.status(500).json({ error: 'Internal server error.' });
  }
});

app.delete('/deleteTeam/:teamId', verifyToken, async (req, res) => {
  const userId = req.id;
  const teamId = req.params.teamId;

  try {
    const account = await Account.findById(userId);
    if (!account) {
      return res.status(404).json({ error: 'Account not found for this user.' });
    }

    const initialTeamsLength = account.teams.length;
    account.teams = account.teams.filter(team => team._id.toString() !== teamId);

    if (account.teams.length === initialTeamsLength) {
      return res.status(404).json({ error: 'Team not found on this account.' });
    }

    await account.save();
    res.json({ message: 'Team deleted successfully.' });
  } catch (error) {
    console.error('Error deleting team:', error);
    res.status(500).json({ error: 'Internal server error.' });
  }
});

app.put('/updateTeam/:teamId', verifyToken, async (req, res) => {
  const userId = req.id;
  const teamId = req.params.teamId;
  const { newTeamName } = req.body;

  if (!newTeamName) {
    return res.status(400).json({ error: 'New team name is required.' });
  }

  try {
    const account = await Account.findById(userId);
    if (!account) {
      return res.status(404).json({ error: 'Account not found for this user.' });
    }

    const teamToUpdate = account.teams.find(team => team._id.toString() === teamId);

    if (!teamToUpdate) {
      return res.status(404).json({ error: 'Team not found on this account.' });
    }

    teamToUpdate.name = newTeamName;
    await account.save();

    res.json({ message: 'Team name updated successfully.', team: teamToUpdate });
  } catch (error) {
    console.error('Error updating team name:', error);
    res.status(500).json({ error: 'Internal server error.' });
  }
});

app.get('/pokemon-moves/:speciesName', async (req, res) => {
  const speciesName = req.params.speciesName.toLowerCase();

  try {
    // 1. Fetch Pokemon Species data by name
    const speciesResponse = await axios.get(`https://pokeapi.co/api/v2/pokemon-species/${speciesName}`);

    // 2. Extract the URL of the default Pokemon variant
    const defaultPokemonUrl = speciesResponse.data.varieties.find(variety => variety.is_default)?.pokemon.url;

    if (!defaultPokemonUrl) {
      return res.status(404).json({ message: `No default Pokemon found for species: ${speciesName}` });
    }

    // 3. Fetch the default Pokemon data to get its moves
    const pokemonResponse = await axios.get(defaultPokemonUrl);
    const moves = pokemonResponse.data.moves.map(moveEntry => ({
      name: moveEntry.move.name,
      url: moveEntry.move.url,
      version_group_details: moveEntry.version_group_details.map(vgDetail => ({
        level_learned_at: vgDetail.level_learned_at,
        move_learn_method: vgDetail.move_learn_method.name,
        version_group: vgDetail.version_group.name,
      })),
    }));

    res.json(moves);

  } catch (error) {
    if (error.response && error.response.status === 404) {
      return res.status(404).json({ message: `Pokemon species not found: ${speciesName}` });
    }
    console.error('Error fetching Pokemon moves:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

app.get('/getTeams', verifyToken, async (req, res) => {
  const userId = req.id;
  const { teamId } = req.params;
  try {
    const account = await Account.findById(userId).populate({
      path: 'teams',
      match: { _id: teamId },
      populate: { path: 'pokemon', model: 'Pokemon' },
    });

    if (!account) {
      return res.status(404).json({ message: 'Account not found for this user.' });
    }

    const team = account.teams.find(t => t._id.toString() === teamId);
    if (!team) {
      return res.status(404).json({ message: 'Team not found for this user.' });
    }

    res.json(team.pokemon);
  } catch (error) {
    console.error('Error getting team Pokemon:', error);
    res.status(500).json({ message: 'Internal server error.' });
  }
});

app.post('/addPokemon', verifyToken, async (req, res) => {
  const userId = req.id;
  const { speciesName, teamId } = req.body;

  if (!speciesName) {
    return res.status(400).json({ message: 'Species name is required to add a Pokemon.' });
  }

  if (!teamId || !mongoose.isValidObjectId(teamId)) {
    return res.status(400).json({ message: 'Invalid team ID provided.' });
  }

  try {
    const abilities = ["test"];
    //await fetchAbilities(speciesName);
    const defaultMoves = [null, null, null, null];
    // await fetchDefaultMoves(speciesName);

    if (abilities.length === 0) {
      return res.status(404).json({ message: `Abilities not found for species: ${speciesName}` });
    }

    const newPokemon = new Pokemon({
      name: speciesName,
      ability: abilities[0], // Assign the first ability
      moves: defaultMoves,
    });

    const savedPokemon = await newPokemon.save();

    const account = await Account.findByIdAndUpdate(
      userId,
      { $push: { 'teams.$[team].pokemon': savedPokemon._id } },
      { new: true, arrayFilters: [{ 'team._id': teamId }, { 'team.pokemon': { $size: { $lt: 6 } } }] }
    );

    if (!account) {
      await Pokemon.findByIdAndDelete(savedPokemon._id); // Remove the created Pokemon if team not found or full
      return res.status(404).json({ message: 'Account or team not found, or team is full for this user.' });
    }

    res.status(201).json({ message: 'Pokemon added to team successfully.', pokemon: savedPokemon });
  } catch (error) {
    console.error('Error adding Pokemon to team:', error);
    res.status(500).json({ message: 'Internal server error.' });
  }
});

app.delete('deletePokemon/:teamId/:pokemonId', verifyToken, async (req, res) => {
  const userId = req.id;
  const { teamId, pokemonId } = req.params;

  try {
    const account = await Account.findByIdAndUpdate(
      userId,
      { $pull: { 'teams.$[team].pokemon': pokemonId } },
      { new: true, arrayFilters: [{ 'team._id': teamId }] }
    );

    if (!account) {
      return res.status(404).json({ message: 'Account or team not found for this user.' });
    }

    const pokemon = await Pokemon.findByIdAndDelete(pokemonId);
    if (pokemon) {
       console.log(`Pokemon ${pokemon.name} (ID: ${pokemonId}) deleted.`);
    }

    res.json({ message: 'Pokemon removed from team successfully.' });
  } catch (error) {
    console.error('Error deleting Pokemon from team:', error);
    res.status(500).json({ message: 'Internal server error.' });
  }
});

app.put('/updatePokemon/:teamId/:pokemonId', verifyToken, async (req, res) => {
  const userId = req.id;
  const { teamId, pokemonId } = req.params;
  const { nickname, ability, moves } = req.body;

  try {
    const account = await Account.findOne({ _id: userId, 'teams._id': teamId, 'teams.pokemon': pokemonId });
    if (!account) {
      return res.status(404).json({ message: 'Account, team, or Pokemon not found for this user.' });
    }

    const updateFields = {};
    if (nickname !== undefined) {
      updateFields.nickname = nickname;
    }
    if (ability !== undefined) {
      updateFields.ability = ability;
    }
    if (Array.isArray(moves) && moves.length === 4) {
      updateFields.moves = moves;
    } else if (moves !== undefined) {
      return res.status(400).json({ message: 'Moves must be an array of 4 elements.' });
    }

    const updatedPokemon = await Pokemon.findByIdAndUpdate(pokemonId, updateFields, { new: true });

    if (!updatedPokemon) {
      return res.status(404).json({ message: 'Pokemon not found (after account verification).' });
    }

    res.json({ message: 'Pokemon updated successfully.', pokemon: updatedPokemon });
  } catch (error) {
    console.error('Error updating Pokemon:', error);
    res.status(500).json({ message: 'Internal server error.' });
  }
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

