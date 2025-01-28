import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_ec/bloc/product/product_event.dart';
import 'package:mini_ec/bloc/product/product_state.dart';
import 'package:mini_ec/services/api_service.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService apiService;

  ProductBloc({required this.apiService}) : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await apiService.getProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
