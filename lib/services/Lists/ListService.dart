import 'package:dio/dio.dart';
import 'package:marketgo/bloc/UserBloc.dart';
import 'package:marketgo/config.dart';
import 'package:marketgo/models/ListModel.dart';

class ListService {
  static ListService _instance = ListService._internal();

  ListService._internal();

  factory ListService() {
    return _instance;
  }

  Future<List<ListModel>> getUserLists() async {
    var token = UserBloc().user.token;
    var response = await Dio().get(Config().baseUrl + "/list",
        options: Options(headers: {'Authorization': "Bearer $token"}));
    print(response); //TODO try catrch
    var list = ListModel.fromList(response.data);
    return list;
  }

  Future<ListModel> addUserList(ListModel listModel) async {
    var token = UserBloc().user.token;
    var response = await Dio().post(Config().baseUrl + "/list",
        data: {"name": listModel.name},
        options: Options(headers: {'Authorization': "Bearer $token"}));
    //TODO try catch
    var list = ListModel.fromJson(response.data);
    return list;
  }
}
