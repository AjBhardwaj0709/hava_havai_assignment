import 'package:bloc/bloc.dart';
import 'package:hava_havai/data/models/product_model.dart';
import 'package:hava_havai/logic/events/cart_event.dart';
import 'package:hava_havai/logic/states/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
  }
  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final cartItems = Map<Product, int>.from(state.cartItems);
    if (cartItems.containsKey(event.product)) {
      cartItems[event.product] = cartItems[event.product]! + 1;
    } else {
      cartItems[event.product] = 1;
    }
    emit(CartState(
        cartItems: cartItems, totalPrice: _calculateTotal(cartItems)));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final cartItems = Map<Product, int>.from(state.cartItems);
    cartItems.remove(event.product);
    emit(CartState(
        cartItems: cartItems, totalPrice: _calculateTotal(cartItems)));
  }

  void _onIncreaseQuantity(IncreaseQuantity event, Emitter<CartState> emit) {
    final cartItems = Map<Product, int>.from(state.cartItems);
    if (cartItems.containsKey(event.product)) {
      cartItems[event.product] = cartItems[event.product]! + 1;
    }
    emit(CartState(
        cartItems: cartItems, totalPrice: _calculateTotal(cartItems)));
  }

  void _onDecreaseQuantity(DecreaseQuantity event, Emitter<CartState> emit) {
    final cartItems = Map<Product, int>.from(state.cartItems);
    if (cartItems.containsKey(event.product) && cartItems[event.product]! > 1) {
      cartItems[event.product] = cartItems[event.product]! - 1;
    } else {
      cartItems.remove(event.product);
    }
    emit(CartState(
        cartItems: cartItems, totalPrice: _calculateTotal(cartItems)));
  }

  double _calculateTotal(Map<Product, int> cartItems) {
    double total = 0;
    cartItems.forEach((product, quantity) {
      double discountedPrice =
          product.price * (1 - product.discountPercentage / 100);
      total += discountedPrice * quantity;
    });
    return total;
  }
}
