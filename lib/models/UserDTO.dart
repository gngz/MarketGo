import 'package:marketgo/models/User.dart';

class UserDTO {
  String token;
  User user;
  UserDTO({this.user, this.token});

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return new UserDTO(user: User.fromJson(json['user']), token: json['token']);
  }
}
