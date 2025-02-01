import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mini_ec/models/order.dart';
import 'package:mini_ec/models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  final String baseUrll = 'https://6798cd06be2191d708b0e3ff.mockapi.io/api';

  Future<Order> placeOrder(Order order) async {
    try {
      // POST REQUEST TO CREATE A NEW ORDER USING MOCK API

      final response = await http.post(
        Uri.parse('$baseUrll/orders'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'items': order.items
              .map((item) => {
                    'productId': item.product.id,
                    'quantity': item.quantity,
                    'price': item.product.price,
                  })
              .toList(),
          'total': order.totalAmount,
          'status': 'Order being Packed',
          'createdAt': order.createdAt.toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);

        // Create a new Order object with the ID from the responses
        return Order(
          id: responseData['id'].toString(),
          items: order.items,
          totalAmount: order.totalAmount,
          status: 'Order being Packed',
          createdAt: order.createdAt,
        );
      } else {
        throw Exception('Failed to place order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
