const axios = require('axios');

const getFlipkartProducts = async (query) => {
    try {
        const response = await axios.get(`https://api.flipkart.com/products?query=${query}`, {
            headers: { 'Authorization': `Bearer ${process.env.FLIPKART_API_KEY}` }
        });
        return response.data;
    } catch (error) {
        console.error('Error fetching Flipkart products:', error);
        throw error;
    }
};

module.exports = { getFlipkartProducts };
