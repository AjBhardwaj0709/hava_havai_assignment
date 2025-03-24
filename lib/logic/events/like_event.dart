import 'package:equatable/equatable.dart';
import 'package:hava_havai/data/models/product_model.dart';

abstract class LikeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ToogleLikeEvent extends LikeEvent {
  final Product product;

  ToogleLikeEvent(this.product);

  @override
  List<Object> get props => [product];
}
