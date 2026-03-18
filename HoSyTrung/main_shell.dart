import 'package:flutter/material.dart';

import 'cart_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({Key? key, this.initialIndex = 0}) : super(key: key);

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int currentIndex;

  late final List<Widget> pages = [
    HomeScreen(onGoToTab: _goToTab),
    CartScreen(onGoToTab: _goToTab),
    const OrdersScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex.clamp(0, pages.length - 1);
  }

  void _goToTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Giỏ hàng',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Đơn mua',
          ),
        ],
      ),
    );
  }
}
