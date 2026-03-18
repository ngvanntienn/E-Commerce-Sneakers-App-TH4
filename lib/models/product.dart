class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });

  final String id;
  final String name;
  final int price;
  final String? imageUrl;
}
