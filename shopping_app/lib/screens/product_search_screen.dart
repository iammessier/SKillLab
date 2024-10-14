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

  Future<void> compareSelectedProducts() async {
    if (selectedProducts.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProductComparisonScreen(products: selectedProducts),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('No products selected for comparison.',
                style: TextStyle(color: Colors.red))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pricee',
          style: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 10,
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
                'assets/animations/loading.json',
                width: 200,
                height: 200,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final url = products[index].link;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Could not launch $url',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            );
                          }
                        },
                        child: Card(
                          margin: EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(15),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                products[index].thumbnail,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              products[index].title,
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              "${products[index].price} (${products[index].source})",
                              style: GoogleFonts.roboto(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                            trailing: Checkbox(
                              value: selectedProducts.contains(products[index]),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedProducts.add(products[index]);
                                  } else {
                                    selectedProducts.remove(products[index]);
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 5,
                    ),
                    child: Text(
                      "Compare Selected Products (${selectedProducts.length})",
                      style: GoogleFonts.roboto(
                          fontSize: 18, color: Colors.white),
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
