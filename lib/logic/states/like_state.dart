import 'package:equatable/equatable.dart';
import 'package:hava_havai/data/models/product_model.dart';

class LikeState extends Equatable {
  final List<Product> likedProducts;

  const LikeState({this.likedProducts = const []});

  LikeState copyWith({List<Product>? likedProducts}) {
    return LikeState(
      likedProducts: likedProducts ?? this.likedProducts,
    );
  }

  @override
  List<Object> get props => [likedProducts];
}
