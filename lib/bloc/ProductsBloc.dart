import 'dart:async';

import 'package:marketgo/models/Product.dart';
import 'package:marketgo/services/Lists/ListService.dart';

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

  Future<void> getFromServer(int id) async {
    var products = await ListService().getProducts(id);
    ProductsBloc().setProduct(products);
  }

  Future<bool> removeProduct(Product prod, int listId) async {
    var isRemoved = await ListService().removeProductFromList(prod, listId);
    if (isRemoved) {
      _product.remove(prod);
      _productBlocController.sink.add(_product);
      return true;
    }
    return false;
  }

  Future<bool> updateQuantity(int listId, Product product, int quantity) async {
    bool isUpdated =
        await ListService().updateProductQuantity(listId, product, quantity);

    if (isUpdated) {
      var index = _product.indexOf(product);
      if (index != -1) {
        _product[index].quantity = quantity;
        _productBlocController.sink.add(_product);
      }
    }

    return isUpdated;
  }

  Future<bool> setReaded(String ean, int listId) async {
    var product =
        _product.where((element) => element.ean.compareTo(ean) == 0).toList();

    if (product.length == 1) {
      product[0].readed = true;
      _productBlocController.sink.add(_product);
      return true;
    } else {
      var newProduct = await ListService().addProductByEan(ean, listId, 1);
      if (newProduct != null) {
        newProduct.readed = true;
        newProduct.quantity = 1;
        _product.add(newProduct);
        _productBlocController.sink.add(_product);
        return true;
      }
    }

    return false;
  }

  void clear() {
    this._product = null;
  }

  void dispose() {
    _productBlocController.close();
  }
}
