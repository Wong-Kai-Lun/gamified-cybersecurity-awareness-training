require('dotenv').config();
const { connectDB } = require('./src/config/db');
const app = require('./src/app');

const PORT = process.env.PORT || 3000;

console.log(PORT);
console.log(process.env.MONGO_ATLAS_URI);

(async () => {

    await connectDB();

    app.listen(PORT, () => {
        console.log(`Express app listening at http://localhost:${PORT}`);
    });
})();
