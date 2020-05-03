import 'dart:convert';

import "package:dio/dio.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marketgo/models/RegisterRequest.dart';
import 'package:marketgo/models/RegisterResponse.dart';
import 'package:marketgo/services/Exceptions.dart';
import '../config.dart';

class Auth {
  static final storage = new FlutterSecureStorage();

  static void authenticate(String email, String password) async {
    try {
      var response = await Dio().post(Config.BASE_URL + "/authp",
          data: {"email": email, "password": password});

      await storage.write(key: "token", value: response.data);
      print(await storage.read(key: "token"));
    } catch (e) {
      print(e);
    }
  }

  static void register(RegisterRequest registerDto) async {
    var response = await Dio()
        .post("${Config.BASE_URL}/auth/register", data: registerDto.toJson());
    print(response.data);
    RegisterResponse regResponse = RegisterResponse.fromJson(response.data[0]);
    if (regResponse.token == null) {
      throw new RegisterException(
          RegisterException.getValidation(regResponse.validation),
          regResponse.field);
    }

    print("this is response: $response");
  }
}
