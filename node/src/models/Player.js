const mongoose = require('mongoose');

const playerSchema = new mongoose.Schema({
    player_name: {
        type: String,
        required: true,
        trim: true
    },
    score: {
        type: Number,
        required: true
    }
})

const Player = mongoose.model('Player', playerSchema, 'player_info');
module.exports = Player;