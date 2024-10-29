class Product {
  final String title;
  final String price;
  final String source;
  final String thumbnail;
  final String link;
  final double? rating; // Ensure this is a double

  Product({
    required this.title,
    required this.price,
    required this.source,
    required this.thumbnail,
    required this.link,
    this.rating, // Optional, can be null
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      price: json['price'],
      source: json['source'],
      thumbnail: json['thumbnail'],
      link: json['link'],
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null, // Ensure it’s a double
    );
  }
}
