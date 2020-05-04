import "package:dio/dio.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marketgo/bloc/UserBloc.dart';
import 'package:marketgo/models/RegisterRequest.dart';
import 'package:marketgo/models/RegisterResponse.dart';
import 'package:marketgo/models/LoginResponse.dart';
import 'package:marketgo/models/User.dart';
import 'package:marketgo/services/Auth/Exceptions.dart';
import 'package:marketgo/config.dart';

enum SocialProvider { FACEBOOK, GOOGLE }

class Auth {
  static final storage = new FlutterSecureStorage();

  static Future<User> getUser() async {
    var email = await storage.read(key: "user_email");
    var name = await storage.read(key: "user_name");
    var avatar = await storage.read(key: "user_avatar");

    return new User(email: email, name: name, avatar: avatar);
  }

  static Future<void> logout() async {
    await storage.deleteAll();
  }

  static void authenticate(String email, String password) async {
    try {
      var response = await Dio().post(Config().baseUrl + "/auth",
          data: {"email": email, "password": password});

      var loginData = LoginResponse.fromJson(response.data);

      _storeData(loginData.user, loginData.token);

      print(await storage.read(key: "user_name"));
    } catch (e) {
      print(e);
    }
  }

  static void _storeData(User user, String token) async {
    UserBloc().setUser(user);
    await storage.write(key: "token", value: token);
    await storage.write(key: "user_name", value: user.name);
    await storage.write(key: "user_email", value: user.email);
    if (user.avatar != null)
      await storage.write(key: "user_avatar", value: user.avatar);
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
      var data = LoginResponse.fromJson(response.data);

      _storeData(data.user, data.token);

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
