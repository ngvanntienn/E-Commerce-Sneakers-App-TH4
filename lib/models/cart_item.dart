import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final String size;
  final String color;
  int quantity;
  bool selected;

  CartItem({
    required this.id,
    required this.product,
    required this.size,
    required this.color,
    required this.quantity,
    this.selected = true,
  });

  double get lineTotal => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'size': size,
      'color': color,
      'quantity': quantity,
      'selected': selected,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: (json['id'] as String?) ?? '',
      product:
          Product.fromJson((json['product'] as Map<String, dynamic>?) ?? {}),
      size: (json['size'] as String?) ?? 'M',
      color: (json['color'] as String?) ?? 'Black',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      selected: (json['selected'] as bool?) ?? true,
    );
  }
}
