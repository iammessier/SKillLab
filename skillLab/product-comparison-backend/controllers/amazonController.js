const axios = require('axios');

const getAmazonProducts = async (query) => {
    try {
        const response = await axios.get(`https://api.amazon.com/products?query=${query}`, {
            headers: { 'Authorization': `Bearer ${process.env.AMAZON_API_KEY}` }
        });
        return response.data;
    } catch (error) {
        console.error('Error fetching Amazon products:', error);
        throw error;
    }
};

module.exports = { getAmazonProducts };
