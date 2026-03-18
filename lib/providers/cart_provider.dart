import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [
    CartItem(
      product: const Product(
        id: 'sp-01',
        name: 'Nike Air Force 1',
        price: 2590000,
      ),
      quantity: 1,
      isSelected: true,
    ),
    CartItem(
      product: const Product(
        id: 'sp-02',
        name: 'Adidas Ultraboost Light',
        price: 3290000,
      ),
      quantity: 2,
      isSelected: true,
    ),
    CartItem(
      product: const Product(
        id: 'sp-03',
        name: 'Puma RS-X Efekt',
        price: 2190000,
      ),
      quantity: 1,
      isSelected: false,
    ),
  ];

  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  bool get isEmpty => _items.isEmpty;

  bool get isAllSelected =>
      _items.isNotEmpty && _items.every((item) => item.isSelected);

  int get selectedProductCount =>
      _items.where((item) => item.isSelected).length;

  int get selectedTotal => _items
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + item.subtotal);

  void toggleItemSelection(String productId, bool? isSelected) {
    final index = _findItemIndex(productId);
    if (index < 0) return;

    final currentItem = _items[index];
    _items[index] = currentItem.copyWith(
      isSelected: isSelected ?? !currentItem.isSelected,
    );
    notifyListeners();
  }

  void toggleSelectAll(bool shouldSelectAll) {
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(isSelected: shouldSelectAll);
    }
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    final index = _findItemIndex(productId);
    if (index < 0) return;

    final currentItem = _items[index];
    _items[index] = currentItem.copyWith(quantity: currentItem.quantity + 1);
    notifyListeners();
  }

  void decrementQuantity(String productId) {
    final index = _findItemIndex(productId);
    if (index < 0) return;

    final currentItem = _items[index];
    if (currentItem.quantity <= 1) return;

    _items[index] = currentItem.copyWith(quantity: currentItem.quantity - 1);
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  int _findItemIndex(String productId) {
    return _items.indexWhere((item) => item.product.id == productId);
  }
}
