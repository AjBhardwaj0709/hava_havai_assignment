import 'package:equatable/equatable.dart';
import 'package:hava_havai/data/models/product_model.dart';

class CartState extends Equatable {
  final Map<Product, int> cartItems;
  final Map<int, bool> isCheckedMap;
  final double totalPrice;

  CartState({
    required this.cartItems,
    required this.totalPrice,
    required this.isCheckedMap,
  });

  int get totalQuantity =>
      cartItems.values.fold(0, (sum, quantity) => sum + quantity);

  @override
  List<Object?> get props => [cartItems, totalPrice, isCheckedMap];

  // ✅ Add a copyWith method to update state easily
  CartState copyWith({
    Map<Product, int>? cartItems,
    Map<int, bool>? isCheckedMap,
    double? totalPrice,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      totalPrice: totalPrice ?? this.totalPrice,
      isCheckedMap: isCheckedMap ?? this.isCheckedMap,
    );
  }
}

// ✅ Fix CartInitial constructor by initializing isCheckedMap
class CartInitial extends CartState {
  CartInitial() : super(cartItems: {}, totalPrice: 0, isCheckedMap: {});
}
