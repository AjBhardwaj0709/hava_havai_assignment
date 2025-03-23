import 'package:dio/dio.dart';
import 'package:hava_havai/data/models/product_model.dart';

class ProductRepository {
  final Dio _dio = Dio();

  Future<List<Product>> fetchProducts( {required int limit, required int skip}) async {
    try {
      final response = await _dio.get(
        'https://dummyjson.com/products/category/smartphones?limit=$limit&skip=$skip',
      );

      if (response.statusCode == 200) {
        final List allproducts = response.data['products'];
       
       
        return allproducts.map((product) => Product.fromJson(product)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
