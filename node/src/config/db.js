const mongoose = require('mongoose');

const mongoAtlasUri = process.env.MONGO_ATLAS_URI

async function connectDB() {
    try {

        await mongoose.connect(mongoAtlasUri);

        console.log('Successfully connected to MongoDB.');

    } catch (error) {

        console.error("MongoDB Connection Failed:", error);
        process.exit(1);

    }
}

module.exports = { connectDB };