import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/product_provider.dart';
import 'screens/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cartProvider = CartProvider();
  await cartProvider.loadFromStorage();

  runApp(MyApp(cartProvider: cartProvider));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.cartProvider}) : super(key: key);

  final CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
        ChangeNotifierProvider<OrdersProvider>(create: (_) => OrdersProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF003049)),
          fontFamily: 'Quicksand',
          useMaterial3: true,
        ),
        title: 'TH4 - Sneakers',
        home: const MainShell(),
      ),
    );
  }
}
