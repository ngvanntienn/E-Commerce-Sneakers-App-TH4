import 'product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    this.isSelected = true,
  });

  final Product product;
  final int quantity;
  final bool isSelected;

  int get subtotal => product.price * quantity;

  CartItem copyWith({Product? product, int? quantity, bool? isSelected}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
