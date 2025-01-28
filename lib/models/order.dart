import 'package:mini_ec/models/cart_item.dart';

class Order {
  final String? id;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  Order(
      {this.id,
      required this.items,
      required this.totalAmount,
      required this.status,
      required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      'items': items
          .map((item) => {
                'productId': item.product.id,
                'quantity': item.quantity,
                'price': item.product.price,
              })
          .toList(),
      'total': totalAmount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'],
      items: (json['items'] as List)
          .map((itemJson) => CartItem.fromJson(itemJson))
          .toList(),
      totalAmount: json['totalAmount'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}


