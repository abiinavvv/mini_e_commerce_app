import 'package:mini_ec/models/product.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;

  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final int productId;

  RemoveFromCart(this.productId);
}

class UpdateQuantity extends CartEvent {
  final int productId;
  final int quantity;

  UpdateQuantity(this.productId, this.quantity);
}

class LoadCart extends CartEvent {}

class ClearCart extends CartEvent {}
