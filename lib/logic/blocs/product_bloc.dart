import 'package:bloc/bloc.dart';
import 'package:hava_havai/data/models/product_model.dart';
import 'package:hava_havai/data/repositories/product_repository.dart';
import 'package:hava_havai/logic/events/product_event.dart';
import 'package:hava_havai/logic/states/product_state.dart';

// class ProductBloc extends Bloc<ProductEvent, ProductState> {
//   final ProductRepository productRepository;
//   List<Product> productList = [];
//   bool isFetching = false; // Prevents multiple simultaneous fetches

//   ProductBloc({required this.productRepository}) : super(ProductInitial()) {
//     on<FetchProducts>(_onFetchProducts);
//   }

//   Future<void> _onFetchProducts(
//       FetchProducts event, Emitter<ProductState> emit) async {
//     if (isFetching) return;
//     isFetching = true;

//     try {
//       if (productList.isEmpty) {
//         emit(ProductLoading());
//       }

//       final newProducts =
//           await productRepository.fetchProducts(event.limit, event.skip);

//       if (newProducts.isNotEmpty) {
//         productList.addAll(newProducts);
//         emit(ProductLoaded(
//             products: productList, hasMore: newProducts.length == event.limit));
//       } else {
//         emit(ProductLoaded(products: productList, hasMore: false));
//       }
//     } catch (e) {
//       emit(ProductError(e.toString()));
//     } finally {
//       isFetching = false;
//     }
//   }
// }



class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  List<Product> allProducts = []; // Store all fetched products
  bool hasMore = true;

  ProductBloc({required this.productRepository}) : super(ProductLoading()) {
    on<FetchProducts>((event, emit) async {
      if (!hasMore) return;

      try {
      final newProducts = await productRepository.fetchProducts(
            limit: event.limit, skip: event.skip);

        if (newProducts.isEmpty) {
          hasMore = false; // No more products to load
        } else {
          allProducts.addAll(newProducts);
        }

        emit(ProductLoaded(products: allProducts, hasMore: hasMore));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
