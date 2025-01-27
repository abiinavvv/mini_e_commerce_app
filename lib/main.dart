import 'package:flutter/material.dart';
import 'package:mini_ec/providers/cart_provider.dart';
import 'package:mini_ec/screens/cart_screen.dart';
import 'package:mini_ec/screens/product_detail_screen.dart';
import 'package:mini_ec/screens/product_list_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cartProvider = CartProvider();
  await cartProvider.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: cartProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter E-commerce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => ProductListScreen(),
        '/product-detail': (ctx) => ProductDetailScreen(),
        '/cart': (ctx) => CartScreen(),
      },
    );
  }
}