import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_ec/bloc/cart/cart_bloc.dart';
import 'package:mini_ec/bloc/cart/cart_event.dart';
import 'package:mini_ec/bloc/order/order_event.dart';
import 'package:mini_ec/bloc/order/order_state.dart';
import 'package:mini_ec/models/order.dart';
import 'package:mini_ec/services/api_service.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiService apiService;
  final CartBloc cartBloc;

  OrderBloc({required this.apiService, required this.cartBloc})
      : super(OrderInitial()) {
    on<PlaceOrder>((event, emit) async {
      emit(OrderPlacing());
      try {
        final order = Order(
          items: event.items,
          totalAmount: event.total,
          status: 'pending',
          createdAt: DateTime.now(),
        );

        final placedOrder = await apiService.placeOrder(order);
        // Clear cart after successful order
        cartBloc.add(ClearCart());
        emit(OrderPlaced(placedOrder));
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });
  }
}
