import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_tile.dart';
import 'product_comparison_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart'; // For Lottie animations
import 'package:google_fonts/google_fonts.dart'; // For custom fonts

class ProductSearchScreen extends StatefulWidget {
  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final ApiService apiService = ApiService();
  List<Product> products = [];
  List<Product> selectedProducts = [];
  bool isLoading = false;

  // Sorting and filtering variables
  String? sortBy = 'Relevance';
  double _minPrice = 0.0;
  double _maxPrice = 100000.0;
  List<String> selectedStores = [];
  final List<String> availableStores = ['Amazon', 'Flipkart', 'Croma'];

  @override
  void initState() {
    super.initState();
    fetchProducts(''); // Initial search query
  }

  Future<void> fetchProducts(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await apiService.fetchProducts(query);
      setState(() {
        products = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e', style: TextStyle(color: Colors.red))));
    }
  }

void sortProducts(String criteria) {
  setState(() {
    if (criteria == 'Price: Low to High') {
      products.sort((a, b) => double.parse(a.price.replaceAll(RegExp(r'[^0-9.]'), '')).compareTo(
          double.parse(b.price.replaceAll(RegExp(r'[^0-9.]'), ''))));
    } else if (criteria == 'Price: High to Low') {
      products.sort((a, b) => double.parse(b.price.replaceAll(RegExp(r'[^0-9.]'), '')).compareTo(
          double.parse(a.price.replaceAll(RegExp(r'[^0-9.]'), ''))));
    } else if (criteria == 'Rating: High to Low') {
      products.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    } else {
      fetchProducts('iphone 13'); // Reset to initial query
    }
    sortBy = criteria;
  });
}


  void filterProducts() {
    setState(() {
      products = products.where((product) {
        final productPrice = double.parse(product.price.replaceAll(RegExp(r'[^0-9.]'), ''));
        final priceInRange = productPrice >= _minPrice && productPrice <= _maxPrice;
        final storeSelected = selectedStores.isEmpty || selectedStores.contains(product.source);
        return priceInRange && storeSelected;
      }).toList();
    });
  }

  Future<void> compareSelectedProducts() async {
    if (selectedProducts.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductComparisonScreen(products: selectedProducts),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No products selected for comparison.', style: TextStyle(color: Colors.red))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pricee',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(fetchProducts: fetchProducts),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(Icons.compare),
              onPressed: compareSelectedProducts,
              tooltip: "Compare Products",
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Lottie.asset(
                'assets/animations/loading.json', // Add your Lottie file here
                width: 200,
                height: 200,
              ),
            )
          : Column(
              children: [
                // Sorting and filtering options
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Sort by dropdown
                      DropdownButton<String>(
                        value: sortBy,
                        items: [
                          'Relevance',
                          'Price: Low to High',
                          'Price: High to Low',
                          'Rating: High to Low',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          sortProducts(newValue!);
                        },
                      ),
                      // Filter button
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Price Range", style: TextStyle(fontSize: 18)),
                                        RangeSlider(
                                          values: RangeValues(_minPrice, _maxPrice),
                                          min: 0,
                                          max: 100000,
                                          divisions: 100,
                                          labels: RangeLabels('₹${_minPrice.toStringAsFixed(0)}', '₹${_maxPrice.toStringAsFixed(0)}'),
                                          onChanged: (RangeValues values) {
                                            setState(() {
                                              _minPrice = values.start;
                                              _maxPrice = values.end;
                                            });
                                          },
                                        ),
                                        Text("Select Stores", style: TextStyle(fontSize: 18)),
                                        Expanded(
                                          child: ListView(
                                            children: availableStores.map((store) {
                                              return CheckboxListTile(
                                                title: Text(store),
                                                value: selectedStores.contains(store),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    if (value == true) {
                                                      selectedStores.add(store);
                                                    } else {
                                                      selectedStores.remove(store);
                                                    }
                                                  });
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            filterProducts();
                                            Navigator.pop(context);
                                          },
                                          child: Text("Apply Filters"),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Text("Filter"),
                      ),
                    ],
                  ),
                ),
                // Products list
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductTile(
                        product: products[index],
                        isSelected: selectedProducts.contains(products[index]),
                        onSelect: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedProducts.add(products[index]);
                            } else {
                              selectedProducts.remove(products[index]);
                            }
                          });
                        },
                        onTap: () async {
                          final url = products[index].link;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Could not launch $url', style: TextStyle(color: Colors.red)),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                // Compare Button
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      "Compare Selected Products (${selectedProducts.length})",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: compareSelectedProducts,
                  ),
                ),
              ],
            ),
    );
  }
}

// Implement the ProductSearchDelegate for handling search
class ProductSearchDelegate extends SearchDelegate {
  final Function fetchProducts;

  ProductSearchDelegate({required this.fetchProducts});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search bar
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search bar
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    fetchProducts(query); // Fetch products based on the search query
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Type to search products...',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  @override
  void showResults(BuildContext context) {
    fetchProducts(query); // Fetch products when user submits the search
    super.showResults(context);
  }
}
