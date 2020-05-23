import 'package:marketgo/bloc/UserBloc.dart';
import 'package:marketgo/models/ListModel.dart';
import 'package:marketgo/models/Product.dart';
import 'package:marketgo/services/ApiService.dart';

class ListService {
  static ListService _instance = ListService._internal();

  ListService._internal();

  factory ListService() {
    return _instance;
  }

  Future<List<ListModel>> getUserLists() async {
    var token = UserBloc().user.token;
    var response = await ApiService().getAuthHttp().get("/list");
    print(response); //TODO try catrch
    List<ListModel> list;
    try {
      list = ListModel.fromList(response.data);
    } catch (e) {
      print("Ocorreu um euro ao buscar listas $e");
      return null;
    }
    return list;
  }

  // TODO SOME shit
  Future<List<Product>> getProducts(int id) async {
    var response = await ApiService().getAuthHttp().get("/list/$id/products/");

    if (response.statusCode == 200) {
      return Product.fromList(response.data);
    } else {
      return null;
    }
  }

  Future<ListModel> addUserList(ListModel listModel) async {
    var token = UserBloc().user.token;
    var response = await ApiService()
        .getAuthHttp()
        .post("/list", data: {"name": listModel.name});
    //TODO try catch
    ListModel list;
    try {
      list = ListModel.fromJson(response.data);
    } catch (e) {
      print("Ocorreu umao adicionar uma lista $e");
      return null;
    }
    return list;
  }

  Future<bool> removeUserList(ListModel list) async {
    var token = UserBloc().user.token;
    try {
      var response =
          await ApiService().getAuthHttp().delete("/list/${list.id}");
      if (response.statusCode == 200) return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
