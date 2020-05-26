import 'package:marketgo/models/CategoryModel.dart';
import 'package:marketgo/services/ApiService.dart';

class CategoryService {
  static CategoryService _instance = CategoryService._internal();

  CategoryService._internal();

  factory CategoryService() {
    return _instance;
  }

  Future<List<CategoryModel>> getCategories() async {
    var response = await ApiService().getAuthHttp().get('/category');
    var list = CategoryModel.fromList(response.data);
    return list;
  }
}
