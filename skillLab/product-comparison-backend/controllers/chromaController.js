const axios = require('axios');

const getChromaProducts = async (query) => {
    try {
        const response = await axios.get(`https://api.chroma.com/products?query=${query}`, {
            headers: { 'Authorization': `Bearer ${process.env.CHROMA_API_KEY}` }
        });
        return response.data;
    } catch (error) {
        console.error('Error fetching Chroma products:', error);
        throw error;
    }
};

module.exports = { getChromaProducts };
