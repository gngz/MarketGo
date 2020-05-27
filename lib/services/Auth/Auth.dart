import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marketgo/bloc/ListsBloc.dart';
import 'package:marketgo/bloc/UserBloc.dart';
import 'package:marketgo/models/RegisterRequest.dart';
import 'package:marketgo/models/RegisterResponse.dart';
import 'package:marketgo/models/UserDTO.dart';
import 'package:marketgo/models/User.dart';
import 'package:marketgo/services/ApiService.dart';
import 'package:marketgo/services/Auth/Exceptions.dart';

enum SocialProvider { FACEBOOK, GOOGLE }

class Auth {
  static final storage = new FlutterSecureStorage();

  static Future<UserDTO> getUser() async {
    var email = await storage.read(key: "user_email");
    var name = await storage.read(key: "user_name");
    var avatar = await storage.read(key: "user_avatar");
    var token = await storage.read(key: "token");
    return new UserDTO(
        user: new User(email: email, name: name, avatar: avatar), token: token);
  }

  static void _clearBlocs() {
    UserBloc().clear();
    ListsBloc().clear();
  }

  static Future<void> logout() async {
    await storage.deleteAll();
    _clearBlocs();
  }

  static Future<void> authenticate(String email, String password) async {
    var response = await ApiService()
        .getHttp()
        .post("/auth", data: {"email": email, "password": password});

    var loginData = UserDTO.fromJson(response.data);

    await _storeData(loginData);
  }

  static Future<void> _storeData(UserDTO userData) async {
    UserBloc().setUser(userData);
    await storage.write(key: "token", value: userData.token);
    await storage.write(key: "user_name", value: userData.user.name);
    await storage.write(key: "user_email", value: userData.user.email);
    if (userData.user.avatar != null)
      await storage.write(key: "user_avatar", value: userData.user.avatar);
  }

  static Future<void> autenticateSocial(
      SocialProvider provider, String token) async {
    var url;

    if (provider == SocialProvider.FACEBOOK) {
      url = "/auth/facebook";
    } else {
      url = "/auth/google";
    }
    var response =
        await ApiService().getHttp().post(url, data: {"token": token});
    var userData = UserDTO.fromJson(response.data);

    await _storeData(userData);
  }

  static Future<void> register(RegisterRequest registerDto) async {
    var response = await ApiService()
        .getHttp()
        .post("/auth/register", data: registerDto.toJson());
    RegisterResponse regResponse = RegisterResponse.fromJson(response.data);
    if (regResponse.token == null) {
      throw new RegisterException(
          RegisterException.getValidation(regResponse.validation),
          regResponse.field);
    }
  }
}
