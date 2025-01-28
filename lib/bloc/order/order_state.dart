import 'package:mini_ec/models/order.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderPlacing extends OrderState {}

class OrderPlaced extends OrderState {
  final Order order;

  OrderPlaced(this.order);
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}
