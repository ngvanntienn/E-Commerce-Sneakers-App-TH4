import 'package:flutter/material.dart';

import 'providers/cart_provider.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final CartProvider _cartProvider = CartProvider();

  @override
  void dispose() {
    _cartProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sneakers Cart',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: CartScreen(cartProvider: _cartProvider),
    );
  }
}
