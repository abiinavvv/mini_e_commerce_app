import 'package:mini_ec/models/product.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
    final List<Product> displayedProducts;  // Store filtered products
  final String searchQuery;

  ProductLoaded({
    required this.products,
    List<Product>? displayedProducts,
    this.searchQuery = '',
  }) : displayedProducts = displayedProducts ?? products;

    ProductLoaded copyWith({
    List<Product>? allProducts,
    List<Product>? displayedProducts,
    String? searchQuery,
  }) {
    return ProductLoaded(
      products: allProducts ?? products,
      displayedProducts: displayedProducts ?? this.displayedProducts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}