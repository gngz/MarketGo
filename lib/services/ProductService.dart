import 'package:marketgo/models/Product.dart';
import 'package:marketgo/services/ApiService.dart';

class ProductService {
  static ProductService _instance = ProductService._internal();

  ProductService._internal();

  factory ProductService() {
    return _instance;
  }

  Future<List<Product>> getAll() async {
    var response = await ApiService().getAuthHttp().get('/product/all');

    if (response.statusCode == 200) return Product.fromList(response.data);
    return null;
  }

  Future<List<Product>> getProductFromCategory(int id) async {
    var response =
        await ApiService().getAuthHttp().get('/product/category/$id');

    if (response.statusCode == 200) return Product.fromList(response.data);
    return null;
  }
}
