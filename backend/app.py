from flask import Flask, jsonify, request
from serpapi import GoogleSearch
import os
from dotenv import load_dotenv

app = Flask(__name__)
load_dotenv()
api_key = os.getenv('SERPAPI_KEY')

@app.route('/')
def home():
    return "Welcome to the Google Shopping API"

@app.route('/search/<string:query>', methods=['GET'])
def search_products(query):
    search = GoogleSearch({
        'q': query,                  
        'engine': 'google_shopping', 
        'api_key': api_key,          
        'gl': 'in',                  
        'hl': 'en',                  
        'location': 'India'
    })
    results = search.get_dict()
    products = results.get('shopping_results', [])
    accepted_sources = [
        'Amazon.in', 'Flipkart', 'shopify.com', 'JioMart - Electronics',
        'Croma', 'Reliance Digital', 'Noise', 'blinkit', 'boAt',
        'TATA CLiQ LUXURY', 'Zebronics', 'Myntra', 'AJIO.com', 'Swiggy Instamart', 'Apple'
    ]
    filtered_products = [
        product for product in products if any(source in product.get('source', '') for source in accepted_sources)
    ]
    return jsonify(filtered_products) 

@app.route('/compare', methods=['POST'])
def compare_products():
    product_links = request.json.get('links')
    comparison_data = []

    for link in product_links:
        search = GoogleSearch({
            'q': link, 
            'engine': 'google_shopping',
            'api_key': api_key,
            'gl': 'in',
            'hl': 'en',
            'location': 'India'
        })

        results = search.get_dict()
        products = results.get('shopping_results', [])
        comparison_data.extend(products)

    return jsonify(comparison_data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
