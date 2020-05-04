class User {
  String email;
  String name;
  String avatar;

  User({this.name, this.email, this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
        name: json['name'], email: json['email'], avatar: json['avatar']);
  }
}
