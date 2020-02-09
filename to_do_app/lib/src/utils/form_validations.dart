class Validations {
  String mandatoryAndLength(String value) {
    if (value.length == 0) {
      return 'Field is mandatory.';
    } else if (value.length < 2) {
      return 'Your name should have more than 2 characters.';
    }
    return null;
  }
}
