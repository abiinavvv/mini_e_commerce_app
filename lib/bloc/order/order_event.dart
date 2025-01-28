import 'package:mini_ec/models/cart_item.dart';

abstract class OrderEvent {}

class FetchOrderDetails extends OrderEvent {
  final String orderId;
  FetchOrderDetails(this.orderId);
}

class PlaceOrder extends OrderEvent {
  final List<CartItem> items;
  final double total;

  PlaceOrder({required this.items, required this.total});
}
