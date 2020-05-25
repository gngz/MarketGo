import 'package:dio/dio.dart';
import 'package:marketgo/bloc/UserBloc.dart';
import 'package:marketgo/config.dart';

typedef void OnTimeoutCallback(String title);

class ApiService {
  static ApiService _instance = ApiService._internal();
  ApiService._internal();

  factory ApiService() {
    return _instance;
  }
  Dio getHttp() {
    var dio = new Dio();
    dio.options.baseUrl = Config().baseUrl;
    //dio.options.connectTimeout = 5 * 1000; //2 secs
    /* if (callback != null) {
      dio.interceptors.add(InterceptorsWrapper(onError: (DioError e) async {
        callback("Não foi possivel");
        return e;
      }));
    } */
    return dio;
  }

  Dio getAuthHttp() {
    var dio = getHttp();
    var token = UserBloc().user?.token;
    if (token != null) dio.options.headers["Authorization"] = "Bearer $token";

    return dio;
  }
}
