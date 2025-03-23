import 'package:bloc/bloc.dart';
import 'package:hava_havai/data/models/product_model.dart';
import 'package:hava_havai/data/repositories/product_repository.dart';
import 'package:hava_havai/logic/events/product_event.dart';
import 'package:hava_havai/logic/states/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  List<Product> productList = [];
  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
  }
  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      final newProducts =
          await productRepository.fetchProducts(event.limit, event.skip);
      productList.addAll(newProducts);
      emit(ProductLoaded(
          products: productList, hasMore: newProducts.isNotEmpty));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
