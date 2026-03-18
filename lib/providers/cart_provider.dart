import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  static const String _storageKey = 'th4_cart_items';

  final List<CartItem> _items = <CartItem>[];

  List<CartItem> get items => List<CartItem>.unmodifiable(_items);

  int get uniqueItemCount => _items.length;

  bool get isAllSelected =>
      _items.isNotEmpty && _items.every((item) => item.selected);

  List<CartItem> get selectedItems =>
      _items.where((item) => item.selected).toList(growable: false);

  double get selectedTotal {
    return selectedItems.fold(0, (sum, item) => sum + item.lineTotal);
  }

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return;
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    _items
      ..clear()
      ..addAll(
        decoded
            .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    notifyListeners();
  }

  Future<void> addToCart({
    required Product product,
    required String size,
    required String color,
    required int quantity,
  }) async {
    final id = _buildItemId(product.id, size, color);
    final existingIndex = _items.indexWhere((item) => item.id == id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
      _items[existingIndex].selected = true;
    } else {
      _items.add(
        CartItem(
          id: id,
          product: product,
          size: size,
          color: color,
          quantity: quantity,
        ),
      );
    }

    await _save();
    notifyListeners();
  }

  Future<void> removeItem(String itemId) async {
    _items.removeWhere((item) => item.id == itemId);
    await _save();
    notifyListeners();
  }

  Future<void> setItemSelected(String itemId, bool value) async {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index < 0) {
      return;
    }
    _items[index].selected = value;
    await _save();
    notifyListeners();
  }

  Future<void> toggleSelectAll(bool value) async {
    for (final item in _items) {
      item.selected = value;
    }
    await _save();
    notifyListeners();
  }

  Future<void> increaseQuantity(String itemId) async {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index < 0) {
      return;
    }
    _items[index].quantity += 1;
    await _save();
    notifyListeners();
  }

  Future<void> decreaseQuantity(String itemId) async {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index < 0) {
      return;
    }

    _items[index].quantity -= 1;
    if (_items[index].quantity <= 0) {
      _items.removeAt(index);
    }
    await _save();
    notifyListeners();
  }

  Future<void> removePurchased(List<String> itemIds) async {
    _items.removeWhere((item) => itemIds.contains(item.id));
    await _save();
    notifyListeners();
  }

  String _buildItemId(int productId, String size, String color) {
    return '${productId}_${size}_$color';
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = _items.map((item) => item.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(payload));
  }
}
