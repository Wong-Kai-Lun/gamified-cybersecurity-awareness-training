const express = require('express');
const Player = require('./models/Player');

const app = express();
app.use(express.json());

app.get('/', (req, res) => {
    res.send('This Express app will provide the API endpoints for collecting player data.');
});

app.get('/leaderboard', async (req, res) => {
    try {
        const topPlayers = await Player.find()
            .sort({ score : -1 })
            .limit(8);

        res.json(topPlayers);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

app.post('/submitPlayerInfo', async (req, res) => {
    const { player_name, score } = req.body

    try {
        const createdPlayer = await Player.create({
            player_name: player_name,
            score: score
        })

        res.status(201).json(createdPlayer);

    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = app;