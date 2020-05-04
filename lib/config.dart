class Config {
  static final Config _singleton = Config._internal();

  String get baseUrl {
    return "http://10.0.2.2:3333";
  }

  factory Config() {
    return _singleton;
  }

  Config._internal();
}
