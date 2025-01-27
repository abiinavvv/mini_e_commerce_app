import 'package:flutter/foundation.dart';
import 'package:mini_ec/models/cart_item.dart';
import 'package:mini_ec/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  SharedPreferences? _prefs;

  List<CartItem> get items => _items;

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCart();
  }

  void addItem(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    _saveCart();
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
      } else {
        _items.removeAt(index);
      }
      _saveCart();
      notifyListeners();
    }
  }

  void _saveCart() {
    final String cartJson = json.encode(_items.map((item) => item.toJson()).toList());
    _prefs?.setString('cart', cartJson);
  }

  void _loadCart() {
    final String? cartJson = _prefs?.getString('cart');
    if (cartJson != null) {
      final List<dynamic> decodedData = json.decode(cartJson);
      _items = decodedData.map((item) => CartItem.fromJson(item)).toList();
      notifyListeners();
    }
  }
}