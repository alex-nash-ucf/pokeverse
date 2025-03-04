const http = require('http');

const hostname = 'localhost'; // Localhost

const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors'); // Enable Cross-Origin Resource Sharing

const app = express();
const PORT = 5000; // Choose a port

require('dotenv').config();
const url = process.env.MONGODB_URI;

mongoose.connect(MONGODB_URI, {
}).then(() =>
  {console.log('MongoDB Connected'); populateAccounts();})
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

// Example: Get all users (Mostly for testing you can probably remove it)
app.get('/users', async (req, res) => {
    try {
      const users = await User.find();
      res.json(users);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch users' });
    }
  });

// Example: Create a new user (You should probably change the name to register, this is just for database testing)
app.post('/addUser', async (req, res) => {
  
    try {
      res.status(201).json(createAccount(req.body)); // 201 Created status code
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

