import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final Function(bool?)? onSelect;
  final VoidCallback onTap;

  ProductTile({
    required this.product,
    required this.isSelected,
    required this.onSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        title: Text(product.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${product.price} (${product.source})"),
            SizedBox(height: 5),
            Text('Tap to view details', style: TextStyle(color: Colors.blue)),
          ],
        ),
        trailing: Image.network(product.thumbnail),
        leading: Checkbox(
          value: isSelected,
          onChanged: onSelect,
        ),
        onTap: onTap,
      ),
    );
  }
}
