import 'package:marketgo/models/User.dart';

class RegisterResponse {
  String message;
  String field;
  String validation;
  User user;
  String token;
  RegisterResponse(
      {this.message, this.field, this.validation, this.user, this.token});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    var regres = new RegisterResponse(
        message: json["message"],
        field: json["field"],
        validation: json['validation'],
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        token: json['token'] != null ? json['token'] : null);
    return regres;
  }
}
