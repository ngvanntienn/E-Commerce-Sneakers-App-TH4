import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../utils/formatters.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key, required this.onGoToTab}) : super(key: key);

  final ValueChanged<int> onGoToTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.items.isEmpty) {
            return const Center(
              child: Text(
                'Giỏ hàng đang trống',
                style: TextStyle(fontSize: 17),
              ),
            );
          }

          return ListView.builder(
            itemCount: cartProvider.items.length,
            itemBuilder: (context, index) {
              final item = cartProvider.items[index];
              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  cartProvider.removeItem(item.id);
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  leading: Checkbox(
                    value: item.selected,
                    onChanged: (value) {
                      cartProvider.setItemSelected(item.id, value ?? false);
                    },
                  ),
                  title: Text(
                    item.product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phân loại: ${item.size} / ${item.color}',
                        style: const TextStyle(fontSize: 14.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatCurrency(item.product.price),
                        style: const TextStyle(
                          color: Color(0xFFE53935),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (item.quantity == 1) {
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Xóa sản phẩm?'),
                                    content: const Text(
                                      'Bạn có muốn xóa sản phẩm này khỏi giỏ không?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('Không'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text('Xóa'),
                                      ),
                                    ],
                                  ),
                                );
                                if (shouldDelete == true) {
                                  cartProvider.removeItem(item.id);
                                }
                                return;
                              }
                              cartProvider.decreaseQuantity(item.id);
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () {
                              cartProvider.increaseQuantity(item.id);
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 68,
                    child: item.product.image.startsWith('assets/')
                        ? Image.asset(item.product.image, fit: BoxFit.contain)
                        : CachedNetworkImage(
                            imageUrl: item.product.image,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          return SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 8,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 390;

                  final selectAll = Row(
                    children: [
                      Checkbox(
                        value: cartProvider.isAllSelected,
                        onChanged: (value) {
                          cartProvider.toggleSelectAll(value ?? false);
                        },
                      ),
                      const Flexible(
                        child: Text(
                          'Chọn tất cả',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  );

                  final totalBlock = Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Tổng thanh toán',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        formatCurrency(cartProvider.selectedTotal),
                        style: const TextStyle(
                          color: Color(0xFFE53935),
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  );

                  final checkoutButton = SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: cartProvider.selectedItems.isEmpty
                          ? null
                          : () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CheckoutScreen(),
                                ),
                              );
                              onGoToTab(0);
                            },
                      child: const Text(
                        'Thanh toán',
                        style: TextStyle(fontSize: 15.5),
                      ),
                    ),
                  );

                  if (isNarrow) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(child: selectAll),
                            totalBlock,
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(width: double.infinity, child: checkoutButton),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: selectAll),
                      totalBlock,
                      const SizedBox(width: 10),
                      checkoutButton,
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
