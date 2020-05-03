enum Validation { unique, required }

class RegisterException implements Exception {
  String _error;
  Validation validation;
  String field;

  String get errorMessage => _error;
  RegisterException(Validation validation, String field) {
    this.validation = validation;
    this.field = field;
  }

  static Validation getValidation(String validation) {
    switch (validation) {
      case "email":
      case "unique":
        return Validation.unique;
      case "required":
        return Validation.required;
      default:
        return null;
    }
  }
}
