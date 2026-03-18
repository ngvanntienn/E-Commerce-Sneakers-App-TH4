import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider({ProductService? service})
    : _service = service ?? ProductService();

  final ProductService _service;

  static const int _pageSize = 8;

  final List<Product> _allProducts = <Product>[];
  final List<Product> _visibleProducts = <Product>[];

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? errorMessage;
  int _currentPage = 0;

  List<Product> get products => List<Product>.unmodifiable(_visibleProducts);

  Future<void> initialFetch() async {
    if (_visibleProducts.isNotEmpty || isLoading) {
      return;
    }
    await refresh();
  }

  Future<void> refresh() async {
    isLoading = true;
    errorMessage = null;
    _currentPage = 0;
    hasMore = true;
    notifyListeners();

    try {
      final fetched = await _service.fetchProducts();
      _allProducts
        ..clear()
        ..addAll(fetched);
      _visibleProducts.clear();
      _appendNextPage();
    } catch (e) {
      errorMessage = 'Không tải được danh sách sản phẩm. Vui lòng thử lại.';
      _allProducts.clear();
      _visibleProducts.clear();
      hasMore = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (isLoading || isLoadingMore || !hasMore) {
      return;
    }

    isLoadingMore = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 450));
    _appendNextPage();

    isLoadingMore = false;
    notifyListeners();
  }

  List<String> get categories {
    final set = <String>{};
    for (final product in _allProducts) {
      set.add(product.category);
    }
    return set.toList();
  }

  void _appendNextPage() {
    final start = _currentPage * _pageSize;
    final end = (start + _pageSize).clamp(0, _allProducts.length);

    if (start >= _allProducts.length) {
      hasMore = false;
      return;
    }

    _visibleProducts.addAll(_allProducts.sublist(start, end));
    _currentPage += 1;
    hasMore = end < _allProducts.length;
  }
}
