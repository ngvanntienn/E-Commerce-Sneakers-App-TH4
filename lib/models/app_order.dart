import 'cart_item.dart';

enum OrderStatus { waitingConfirm, shipping, delivered, canceled }

class AppOrder {
  final String id;
  final DateTime createdAt;
  final List<CartItem> items;
  final String address;
  final String paymentMethod;
  final OrderStatus status;

  AppOrder({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.address,
    required this.paymentMethod,
    this.status = OrderStatus.waitingConfirm,
  });

  double get total => items.fold(0, (sum, item) => sum + item.lineTotal);
}
