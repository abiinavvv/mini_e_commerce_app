import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_ec/bloc/cart/cart_event.dart';
import 'package:mini_ec/bloc/cart/cart_state.dart';
import 'package:mini_ec/models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartBloc extends Bloc<CartEvent, CartState> {
  final SharedPreferences prefs;
  List<CartItem> _items = [];

  CartBloc({required this.prefs}) : super(CartInitial()) {
    on<LoadCart>((event, emit) async {
      emit(CartLoading());
      _loadCart();
      emit(CartLoaded(_items, _calculateTotal()));
    });

    on<ClearCart>((event, emit) {
      _items.clear();
      _saveCart();
      emit(CartLoaded(_items, 0));
    });

    on<AddToCart>((event, emit) {
      final existingIndex =
          _items.indexWhere((item) => item.product.id == event.product.id);
      if (existingIndex >= 0) {
        _items[existingIndex].quantity++;
      } else {
        _items.add(CartItem(product: event.product));
      }
      _saveCart();
      emit(CartLoaded(_items, _calculateTotal()));
    });

    on<RemoveFromCart>((event, emit) {
      _items.removeWhere((item) => item.product.id == event.productId);
      _saveCart();
      emit(CartLoaded(_items, _calculateTotal()));
    });

    on<UpdateQuantity>((event, emit) {
      final index =
          _items.indexWhere((item) => item.product.id == event.productId);
      if (index >= 0) {
        if (event.quantity > 0) {
          _items[index].quantity = event.quantity;
        } else {
          _items.removeAt(index);
        }
        _saveCart();
        emit(CartLoaded(_items, _calculateTotal()));
      }
    });
  }

  double _calculateTotal() {
    return _items.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  void _saveCart() {
    final String cartJson =
        json.encode(_items.map((item) => item.toJson()).toList());
    prefs.setString('cart', cartJson);
  }

  void _loadCart() {
    final String? cartJson = prefs.getString('cart');
    if (cartJson != null) {
      final List<dynamic> decodedData = json.decode(cartJson);
      _items = decodedData.map((item) => CartItem.fromJson(item)).toList();
    }
  }
}
