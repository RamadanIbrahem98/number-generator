abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class IsAcceptedEmail implements StringValidator {
  @override
  bool isValid(String value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }
}

class IsNumeric implements StringValidator {
  @override
  bool isValid(String value) {
    return RegExp("(^[0][1-9]+)|([1-9]\d*)").hasMatch(value);
  }
}

class IsAcceptedPassword implements StringValidator {
  @override
  bool isValid(String value) {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(value);
  }
}

class EmailAndPasswordValidator {
  final StringValidator emailValidator = IsAcceptedEmail();
  final StringValidator passwordValidator = IsAcceptedPassword();
  final StringValidator textFieldValidator = NonEmptyStringValidator();
  final String emailInValidMessage = "Email is invalid";
  final String passwordInValidMessage =
      "Password must contain at least 8 characters, one capital case letter, one lower case letter,\none number, one special character";
  final String textFieldInValidMessage = "This field is required";
}

class UserNumberInput {
  final StringValidator inputValidator = IsNumeric();
  final String inputInvalidMessage = "You have to enter numbers only";
}
