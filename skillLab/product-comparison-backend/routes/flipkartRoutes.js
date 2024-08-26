const express = require('express');
const { getFlipkartProducts } = require('../controllers/flipkartController');
const router = express.Router();

router.get('/products', async (req, res) => {
    const { query } = req.query;
    try {
        const products = await getFlipkartProducts(query);
        res.json(products);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching Flipkart products' });
    }
});

module.exports = router;
