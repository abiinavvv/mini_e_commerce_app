import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_ec/bloc/cart/cart_bloc.dart';
import 'package:mini_ec/bloc/order/order_bloc.dart';
import 'package:mini_ec/bloc/product/product_bloc.dart';
import 'package:mini_ec/screens/cart_screen.dart';
import 'package:mini_ec/screens/order_confirmation_screen.dart';
import 'package:mini_ec/screens/product_detail_screen.dart';
import 'package:mini_ec/screens/product_list_screen.dart';
import 'package:mini_ec/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService();

  runApp(MyApp(prefs: prefs, apiService: apiService));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final ApiService apiService;

  const MyApp({
    super.key,
    required this.prefs,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductBloc(apiService: apiService),
        ),
        BlocProvider(
          create: (context) => CartBloc(prefs: prefs),
        ),
        BlocProvider(
          create: (context) => OrderBloc(
            apiService: apiService,
            cartBloc: context.read<CartBloc>(),
          ),
        ),
      ],
      child: MaterialApp(
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
          '/order-confirmation': (ctx) => OrderConfirmationScreen(),
        },
      ),
    );
  }
}
