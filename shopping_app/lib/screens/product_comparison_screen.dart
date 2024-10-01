import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductComparisonScreen extends StatelessWidget {
  final List<Product> products;

  ProductComparisonScreen({required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Comparison'),
      ),
      body: SingleChildScrollView( // Wrap in SingleChildScrollView for better scrolling
        child: Column(
          children: products.map((product) {
            return Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Price: ${product.price}", style: TextStyle(fontSize: 16)),
                        Image.network(product.thumbnail, width: 100, height: 100), // Display product image
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("Source: ${product.source}", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Link: ${product.link}", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
