import 'package:flutter/foundation.dart';

import '../models/app_order.dart';
import '../models/cart_item.dart';

class OrdersProvider extends ChangeNotifier {
  final List<AppOrder> _orders = <AppOrder>[];

  List<AppOrder> get orders => List<AppOrder>.unmodifiable(_orders);

  List<AppOrder> byStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  Future<void> placeOrder({
    required List<CartItem> items,
    required String address,
    required String paymentMethod,
  }) async {
    final clonedItems = items
        .map(
          (item) => CartItem(
            id: item.id,
            product: item.product,
            size: item.size,
            color: item.color,
            quantity: item.quantity,
            selected: false,
          ),
        )
        .toList();

    _orders.insert(
      0,
      AppOrder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        items: clonedItems,
        address: address,
        paymentMethod: paymentMethod,
      ),
    );
    notifyListeners();
  }
}
