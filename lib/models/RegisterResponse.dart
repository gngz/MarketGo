class RegisterResponse {
  String message;
  String field;
  String validation;

  String token;
  RegisterResponse({this.message, this.field, this.validation, this.token});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    var regres = new RegisterResponse(
        message: json["message"],
        field: json["field"],
        validation: json['validation'],
        token: json['token']);
    return regres;
  }
}
