import "package:dio/dio.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marketgo/models/RegisterRequest.dart';
import 'package:marketgo/models/RegisterResponse.dart';
import 'package:marketgo/models/SocialResponse.dart';
import 'package:marketgo/services/Auth/Exceptions.dart';
import 'package:marketgo/config.dart';

enum SocialProvider { FACEBOOK, GOOGLE }

class Auth {
  static final storage = new FlutterSecureStorage();

  static void authenticate(String email, String password) async {
    try {
      var response = await Dio().post(Config().baseUrl + "/auth",
          data: {"email": email, "password": password});

      await storage.write(key: "token", value: response.data);
      print(await storage.read(key: "token"));
    } catch (e) {
      print(e);
    }
  }

  static void autenticateSocial(SocialProvider provider, String token) async {
    var url;

    if (provider == SocialProvider.FACEBOOK) {
      url = Config().baseUrl + "/auth/facebook";
    } else {
      url = Config().baseUrl + "/auth/google";
    }
    try {
      var response = await Dio().post(url, data: {"token": token});
      var data = SocialResponse.fromJson(response.data);
      await storage.write(key: "token", value: data.token);
      print(await storage.read(key: "token"));
    } catch (e) {
      print(e);
    }
  }

  static void register(RegisterRequest registerDto) async {
    var response = await Dio()
        .post("${Config().baseUrl}/auth/register", data: registerDto.toJson());
    print(response.data);
    RegisterResponse regResponse = RegisterResponse.fromJson(response.data);
    if (regResponse.token == null) {
      throw new RegisterException(
          RegisterException.getValidation(regResponse.validation),
          regResponse.field);
    }

    print("this is response: $response");
  }
}
