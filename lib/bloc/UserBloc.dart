import 'dart:async';
import 'package:marketgo/models/UserDTO.dart';

class UserBloc {
  static final UserBloc _singleton = UserBloc._internal();
  UserDTO _user;
  UserDTO get user => _user;

  factory UserBloc() {
    return _singleton;
  }

  UserBloc._internal();

  final _userBlocController = StreamController<UserDTO>.broadcast();

  Stream<UserDTO> get stream => _userBlocController.stream;

  void setUser(UserDTO user) {
    this._user = user;
    _userBlocController.sink.add(user);
  }

  void clear() {
    this._user = null;
  }

  void dispose() {
    _userBlocController.close();
  }
}
