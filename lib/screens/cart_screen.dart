import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../utils/formatters.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.cartProvider});

  final CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart Screen'), centerTitle: true),
      body: AnimatedBuilder(
        animation: cartProvider,
        builder: (context, _) {
          if (cartProvider.isEmpty) {
            return const Center(child: Text('Giỏ hàng đang trống'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  itemCount: cartProvider.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return _CartItemTile(
                      item: item,
                      cartProvider: cartProvider,
                    );
                  },
                ),
              ),
              _CartSummaryBar(cartProvider: cartProvider),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item, required this.cartProvider});

  final CartItem item;
  final CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) {
        cartProvider.removeItem(item.product.id);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Đã xóa ${item.product.name} khỏi giỏ hàng'),
            ),
          );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Checkbox(
              value: item.isSelected,
              onChanged: (value) {
                cartProvider.toggleItemSelection(item.product.id, value);
              },
            ),
            title: Text(item.product.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Đơn giá: ${formatCurrencyVnd(item.product.price)}'),
                Text('Thành tiền: ${formatCurrencyVnd(item.subtotal)}'),
              ],
            ),
            trailing: _QuantityControl(item: item, cartProvider: cartProvider),
          ),
        ),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({required this.item, required this.cartProvider});

  final CartItem item;
  final CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => _onDecrementPressed(context),
            tooltip: 'Giảm số lượng',
          ),
          Text(formatQuantityLabel(item.quantity)),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              cartProvider.incrementQuantity(item.product.id);
            },
            tooltip: 'Tăng số lượng',
          ),
        ],
      ),
    );
  }

  Future<void> _onDecrementPressed(BuildContext context) async {
    if (item.quantity > 1) {
      cartProvider.decrementQuantity(item.product.id);
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa sản phẩm?'),
          content: const Text(
            'Số lượng đang là 1. Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (shouldDelete ?? false) {
      cartProvider.removeItem(item.product.id);
    }
  }
}

class _CartSummaryBar extends StatelessWidget {
  const _CartSummaryBar({required this.cartProvider});

  final CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Checkbox(
                  value: cartProvider.isAllSelected,
                  onChanged: (value) {
                    cartProvider.toggleSelectAll(value ?? false);
                  },
                ),
                const Text('Chọn tất cả'),
                const Spacer(),
                Text(
                  'Tổng: ${formatCurrencyVnd(cartProvider.selectedTotal)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cartProvider.selectedProductCount == 0
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã xử lý thanh toán (demo)'),
                          ),
                        );
                      },
                child: Text(
                  'Thanh toán (${cartProvider.selectedProductCount} sản phẩm)',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
