const express = require('express');
const Player = require('./models/Player');

const app = express();
app.use(express.json());

app.get('/', (req, res) => {
    res.send('This Express app will provide the API endpoints for collecting player data.');
});

app.get('/leaderboard', async (req, res) => {
    try {
        const allPlayers = await Player.find();
        res.json(allPlayers);
        
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// app.post('/post')

module.exports = app;