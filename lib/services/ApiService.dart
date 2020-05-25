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
    dio.options.connectTimeout = 5 * 1000; //2 secs
    dio.interceptors.add(InterceptorsWrapper(onError: (DioError e) async {
      //mostrar um toast de erro, com inversão de dependências era capaz de se tornar fixe...
      return e;
    }));
    return dio;
  }

  Dio getAuthHttp() {
    var dio = getHttp();
    var token = UserBloc().user?.token;
    if (token != null) dio.options.headers["Authorization"] = "Bearer $token";

    return dio;
  }
}
