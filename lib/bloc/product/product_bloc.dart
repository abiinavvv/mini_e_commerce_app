import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_ec/bloc/product/product_event.dart';
import 'package:mini_ec/bloc/product/product_state.dart';
import 'package:mini_ec/services/api_service.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService apiService;

  ProductBloc({required this.apiService}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await apiService.getProducts();
      emit(ProductLoaded(
        products: products,
        displayedProducts: products,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(ProductLoaded(
          products: currentState.products,
          displayedProducts: currentState.products,
          searchQuery: '',
        ));
        return;
      }

      final filteredProducts = currentState.products.where((product) {
        return product.title.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
      }).toList();

      emit(ProductLoaded(
        products: currentState.products,
        displayedProducts: filteredProducts,
        searchQuery: query,
      ));
    }
  }
}
