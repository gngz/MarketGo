import "package:dio/dio.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marketgo/models/Register.dart';
import '../config.dart';

class Auth {
  static final storage = new FlutterSecureStorage();

  static void authenticate(String email, String password) async {
    try {
      var response = await Dio().post(Config.BASE_URL + "/login",
          data: {"email": email, "password": password});

      await storage.write(key: "token", value: response.data);
      print(await storage.read(key: "token"));
    } catch (e) {
      print(e);
    }
  }

  static void register(Register registerDto) async {
    try {
      var response = await Dio()
          .post("${Config.BASE_URL}/register", data: registerDto.toJson());
    } catch (e) {}
  }
}
