require('dotenv').config();
const { connectDB } = require('./src/config/db');
const app = require('./src/app');

const port = process.env.PORT || 3000;

(async () => {

    await connectDB();

    app.listen(port, '0.0.0.0', () => {
        console.log(`Express app listening at http://localhost:${port}`);
    });
})();
