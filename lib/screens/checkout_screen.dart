import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../utils/formatters.dart';
import 'main_shell.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();
  String paymentMethod = 'COD';

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final checkoutItems = cartProvider.selectedItems;
    final total = checkoutItems.fold<double>(
      0,
      (sum, item) => sum + item.lineTotal,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Địa chỉ nhận hàng',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _addressController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Nhập địa chỉ giao hàng',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Phương thức thanh toán',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: [
              ChoiceChip(
                label: const Text('COD'),
                selected: paymentMethod == 'COD',
                onSelected: (_) {
                  setState(() {
                    paymentMethod = 'COD';
                  });
                },
              ),
              ChoiceChip(
                label: const Text('Momo'),
                selected: paymentMethod == 'Momo',
                onSelected: (_) {
                  setState(() {
                    paymentMethod = 'Momo';
                  });
                },
              ),
            ],
          ),
          const Divider(),
          ...checkoutItems.map(
            (item) => ListTile(
              title: Text(
                item.product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('${item.size}/${item.color} x${item.quantity}'),
              trailing: Text(formatCurrency(item.lineTotal)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng cộng',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                formatCurrency(total),
                style: const TextStyle(
                  color: Color(0xFFE53935),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: _placeOrder,
            child: const Text('Đặt hàng'),
          ),
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ nhận hàng')),
      );
      return;
    }

    final cartProvider = context.read<CartProvider>();
    if (cartProvider.selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có sản phẩm nào được chọn')),
      );
      return;
    }

    final ordersProvider = context.read<OrdersProvider>();

    await ordersProvider.placeOrder(
      items: cartProvider.selectedItems,
      address: _addressController.text.trim(),
      paymentMethod: paymentMethod,
    );

    final itemIds = cartProvider.selectedItems.map((item) => item.id).toList();
    await cartProvider.removePurchased(itemIds);

    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đặt hàng thành công'),
        content: const Text('Đơn hàng của bạn đã được tạo.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }
}
