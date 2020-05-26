import 'dart:async';

import 'package:marketgo/models/CategoryModel.dart';
import 'package:marketgo/services/CategoryService.dart';

class CategoryBloc {
  static final CategoryBloc _singleton = CategoryBloc._internal();

  List<CategoryModel> categories;

  factory CategoryBloc() {
    return _singleton;
  }

  CategoryBloc._internal() {
    categories = new List<CategoryModel>();
    _listBlocController.sink.add(categories);
  }

  final _listBlocController = StreamController<List<CategoryModel>>.broadcast();

  Stream<List<CategoryModel>> get stream => _listBlocController.stream;

  void getFromServer() async {
    var categories = await CategoryService().getCategories();
    this.categories = categories;
    _listBlocController.sink.add(categories);
  }

  void dispose() {
    _listBlocController.close();
  }
}
