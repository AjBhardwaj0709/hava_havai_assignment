

import 'package:bloc/bloc.dart';
import 'package:hava_havai/data/models/product_model.dart';
import 'package:hava_havai/logic/events/like_event.dart';
import 'package:hava_havai/logic/states/like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  LikeBloc() : super(const LikeState()) {
    on<ToogleLikeEvent>((event, emit) {
      final updatedLikes = List<Product>.from(state.likedProducts);
      if (updatedLikes.contains(event.product)) {
        updatedLikes.remove(event.product); // Unlike product
      } else {
        updatedLikes.add(event.product); // Like product
      }
      emit(state.copyWith(likedProducts: updatedLikes));
    });
  }
}
