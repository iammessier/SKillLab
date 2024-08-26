const express = require('express');
const dotenv = require('dotenv');
const amazonRoutes = require('./routes/amazonRoutes');
const flipkartRoutes = require('./routes/flipkartRoutes');
const chromaRoutes = require('./routes/chromaRoutes');

dotenv.config();
const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(express.json());

// Routes
app.use('/api/amazon', amazonRoutes);
app.use('/api/flipkart', flipkartRoutes);
app.use('/api/chroma', chromaRoutes);

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
