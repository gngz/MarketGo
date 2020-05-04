import 'package:marketgo/models/User.dart';

class LoginResponse {
  String token;
  User user;
  LoginResponse({this.user, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return new LoginResponse(
        user: User.fromJson(json['user']), token: json['token']);
  }
}
