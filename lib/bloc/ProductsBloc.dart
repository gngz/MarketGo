import 'dart:async';

import 'package:marketgo/models/Product.dart';

class ProductsBloc {
  static final ProductsBloc _instance = ProductsBloc._internal();
  List<Product> _product;
  List<Product> get product => _product;

  factory ProductsBloc() {
    return _instance;
  }

  ProductsBloc._internal();

  final _productBlocController = StreamController<List<Product>>.broadcast();

  Stream<List<Product>> get stream => _productBlocController.stream;

  void setProduct(List<Product> product) {
    this._product = product;
    _productBlocController.sink.add(product);
  }

  void clear() {
    this._product = null;
  }

  void dispose() {
    _productBlocController.close();
  }
}
