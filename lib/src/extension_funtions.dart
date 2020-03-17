/// Extension functions for the string method to be used in login
extension NumberParsing on String {
  /// Check if an email is valid or not
  bool isValidEmail() {
    final emailRegex = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
    return emailRegex.hasMatch(this);
  }
  /// Check if a password fulfils our requirements
  bool isValidPassword() {
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegex.hasMatch(this);
  }
}