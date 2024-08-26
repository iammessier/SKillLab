const express = require('express');
const { getChromaProducts } = require('../controllers/chromaController');
const router = express.Router();

router.get('/products', async (req, res) => {
    const { query } = req.query;
    try {
        const products = await getChromaProducts(query);
        res.json(products);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching Chroma products' });
    }
});

module.exports = router;
