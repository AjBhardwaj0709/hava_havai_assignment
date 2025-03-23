import 'package:dio/dio.dart';
import 'package:hava_havai/data/models/product_model.dart';

class ProductRepository {
  final Dio _dio = Dio();
  bool output = true;
  Future<List<Product>> fetchProducts(int limit, int skip) async {
    final response = await _dio
        .get('https://dummyjson.com/products?limit=${limit * 100}&skip=$skip ');

    if (response.statusCode == 200) {
      final List allproducts = response.data['products'];
      final List products = allproducts
          .where((product) => product['category'] == 'smartphones')
          .take(limit)
          .toList();
      while (output == true) {
        print(products[1]);
        output = false;
      }
      // print(products);
      return products.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
