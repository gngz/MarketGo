class RegisterRequest {
  String firstName;
  String lastName;
  String email;
  String password;

  Map<String, dynamic> toJson() {
    return {
      'name': "$firstName $lastName",
      'email': email,
      'password': password
    };
  }
}
