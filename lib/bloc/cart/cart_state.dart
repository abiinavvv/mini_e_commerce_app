import 'package:mini_ec/models/cart_item.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double totalAmount;

  CartLoaded(this.items, this.totalAmount);
}