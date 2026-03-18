class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;
  final int ratingCount;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawRating = json['rating'];
    final ratingMap = rawRating is Map
        ? Map<String, dynamic>.from(rawRating)
        : null;

    final parsedRating = rawRating is num
        ? rawRating.toDouble()
        : (ratingMap?['rate'] as num?)?.toDouble() ?? 0;
    final parsedRatingCount =
        (json['ratingCount'] as num?)?.toInt() ??
        (ratingMap?['count'] as num?)?.toInt() ??
        0;

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: (json['description'] as String?) ?? '',
      category: (json['category'] as String?) ?? '',
      image: (json['image'] as String?) ?? '',
      rating: parsedRating,
      ratingCount: parsedRatingCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }
}
