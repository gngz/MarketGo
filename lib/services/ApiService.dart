import 'package:dio/dio.dart';
import 'package:marketgo/bloc/UserBloc.dart';
import 'package:marketgo/config.dart';

class ApiService {
  static ApiService _instance = ApiService._internal();
  ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  Dio getHttp() {
    var dio = new Dio();
    dio.options.baseUrl = Config().baseUrl;
    return dio;
  }

  Dio getAuthHttp() {
    var dio = getHttp();
    var token = UserBloc().user?.token;
    if (token != null) dio.options.headers["Authorization"] = "Bearer $token";

    return dio;
  }
}
