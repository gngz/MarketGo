import 'dart:async';

import 'package:marketgo/models/User.dart';

class UserBloc {
  static final UserBloc _singleton = UserBloc._internal();
  User _user;
  User get user => _user;

  factory UserBloc() {
    return _singleton;
  }

  UserBloc._internal();

  final _userBlocController = StreamController<User>.broadcast();

  Stream<User> get stream => _userBlocController.stream;

  void setUser(User user) {
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
