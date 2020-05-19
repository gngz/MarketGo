class Config {
  static final Config _singleton = Config._internal();

  String get baseUrl {
    return "http://192.168.1.15:3333";
  }

  factory Config() {
    return _singleton;
  }

  Config._internal();
}
