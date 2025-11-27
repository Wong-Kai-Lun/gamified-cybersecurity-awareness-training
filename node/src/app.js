const express = require('express');

const app = express();


app.get('/', (req, res) => {
    res.send('This Express app will provide the API endpoints for collecting player data.');
});


module.exports = app;