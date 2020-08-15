class Validators {
  static String isValidEmail(String email) {
    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!email.contains('@') || !email.contains('.')) {
      return 'Invalid email address';
    }
    return null;
  }

  static String isValidPassword(String password) {
    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Password must be longer than 6 characters';
    }
    return null;
  }
}
