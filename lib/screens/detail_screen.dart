import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'main_shell.dart';
import '../utils/formatters.dart';
import '../widgets/cart_badge_icon.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.product, this.onGoToCart})
      : super(key: key);

  final Product product;
  final VoidCallback? onGoToCart;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final oldPrice = widget.product.price * 1.3;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) => CartBadgeIcon(
              count: cartProvider.uniqueItemCount,
              onTap: _goToCart,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: List<Widget>.generate(
                3,
                (index) => Hero(
                  tag: index == 0
                      ? 'product-${widget.product.id}'
                      : 'product-${widget.product.id}-$index',
                  child: widget.product.image.startsWith('assets/')
                      ? Image.asset(
                          widget.product.image,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.product.image,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey.shade200),
                        ),
                ),
              ),
              options: CarouselOptions(
                height: 320,
                viewportFraction: 1,
                enableInfiniteScroll: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        formatCurrency(widget.product.price),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Color(0xFFE53935),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatCurrency(oldPrice),
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _showVariationSheet,
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Chọn kích cỡ, màu sắc',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Mô tả chi tiết',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  AnimatedCrossFade(
                    firstChild: Text(
                      widget.product.description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    secondChild: Text(widget.product.description),
                    crossFadeState: expanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                    child: Text(expanded ? 'Thu gọn' : 'Xem thêm'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
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
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_bubble_outline),
                    ),
                    IconButton(
                      onPressed: _goToCart,
                      icon: const Icon(Icons.shopping_cart_outlined),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _showVariationSheet,
                        child: const Text('Thêm vào giỏ hàng'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showVariationSheet,
                        child: const Text('Mua ngay'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToCart() {
    if (widget.onGoToCart != null) {
      Navigator.of(context).pop();
      widget.onGoToCart!.call();
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell(initialIndex: 1)),
      (route) => false,
    );
  }

  Future<void> _showVariationSheet() async {
    final cart = context.read<CartProvider>();

    String selectedSize = 'M';
    String selectedColor = 'Đỏ';
    int quantity = 1;
    final sizes = ['S', 'M', 'L'];
    final colors = ['Xanh', 'Đỏ', 'Đen'];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chọn phân loại',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  const Text('Size'),
                  Wrap(
                    spacing: 8,
                    children: sizes
                        .map(
                          (size) => ChoiceChip(
                            label: Text(size),
                            selected: selectedSize == size,
                            onSelected: (_) {
                              setSheetState(() {
                                selectedSize = size;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Màu sắc'),
                  Wrap(
                    spacing: 8,
                    children: colors
                        .map(
                          (color) => ChoiceChip(
                            label: Text(color),
                            selected: selectedColor == color,
                            onSelected: (_) {
                              setSheetState(() {
                                selectedColor = color;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Số lượng: '),
                      IconButton(
                        onPressed: () {
                          if (quantity <= 1) {
                            return;
                          }
                          setSheetState(() {
                            quantity -= 1;
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$quantity'),
                      IconButton(
                        onPressed: () {
                          setSheetState(() {
                            quantity += 1;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        cart.addToCart(
                          product: widget.product,
                          size: selectedSize,
                          color: selectedColor,
                          quantity: quantity,
                        );
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(content: Text('Thêm thành công')),
                        );
                      },
                      child: const Text('Xác nhận'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
