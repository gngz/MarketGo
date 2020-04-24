import "package:dio/dio.dart";
import '../config.dart';

class Auth {
  static void authenticate(String email, String password) async {
    try {
      var response = await Dio().post(Config.BASE_URL + "/login",
          data: {"email": email, "password": password});

      print(response.data.toString());
    } catch (e) {}
  }
}
