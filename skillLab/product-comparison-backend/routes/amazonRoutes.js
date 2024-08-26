const express = require('express');
const { getAmazonProducts } = require('../controllers/amazonController');
const router = express.Router();

router.get('/products', async (req, res) => {
    const { query } = req.query;
    try {
        const products = await getAmazonProducts(query);
        res.json(products);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching Amazon products' });
    }
});

module.exports = router;
