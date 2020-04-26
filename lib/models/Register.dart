class Register {
  String firstName;
  String lastName;
  String email;
  String password;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password
    };
  }
}
