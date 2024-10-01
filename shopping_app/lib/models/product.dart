class Product {
  final String title;
  final String price;
  final String source;
  final String thumbnail;
  final String link;

  Product({
    required this.title,
    required this.price,
    required this.source,
    required this.thumbnail,
    required this.link,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      price: json['price'],
      source: json['source'],
      thumbnail: json['thumbnail'],
      link: json['link'],
    );
  }
}
