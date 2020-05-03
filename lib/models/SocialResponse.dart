class SocialResponse {
  String token;

  SocialResponse({this.token});

  factory SocialResponse.fromJson(Map<String, dynamic> json) {
    var regres = new SocialResponse(token: json['token']);
    return regres;
  }
}
