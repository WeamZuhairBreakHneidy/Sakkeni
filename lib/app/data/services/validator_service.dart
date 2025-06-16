import 'package:get/get.dart';

class ValidationController extends GetxController {
  String? validateName(String value) {
    if (value.isEmpty) {
      return "error_name_must_not_be_empty".tr;
    } else if (value.length < 2) {
      return "error_name_is_too_short".tr;
    } else if (!RegExp(r"^[A-Za-z\s]+$").hasMatch(value)) {
      return "error_invalid_name".tr;
    }
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return "error_email_must_not_be_empty".tr;
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
      return "error_invalid_email_format".tr;
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "error_password_must_not_be_empty".tr;
    } else if (value.length < 8) {
      return "error_password_too_short".tr;
    } else if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
      return "error_password_uppercase_required".tr;
    } else if (!RegExp(r'^(?=.*?[a-z])').hasMatch(value)) {
      return "error_password_lowercase_required".tr;
    } else if (!RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
      return "error_password_number_required".tr;
    } else if (!RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(value)) {
      return "error_password_special_char_required".tr;
    }
    return null;
  }

  String? validateLoginPassword(String value) {
    if (value.isEmpty) {
      return "error_password_must_not_be_empty".tr;
    } else if (value.length < 6) {
      return "error_password_too_short".tr;
    }
    return null;
  }

  String? validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return "error_phone_must_not_be_empty".tr;
    } else if (!RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(value)) {
      return "error_invalid_phone_number".tr;
    }
    return null;
  }

  String? validateNumber(String value) {
    if (value.isEmpty) {
      return "error_number_must_not_be_empty".tr;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "error_invalid_number".tr;
    }
    return null;
  }

  String? validateResetCode(String value) {
    if (value.isEmpty) {
      return "error_reset_code_must_not_be_empty".tr;
    } else if (value.length != 8) {
      return "error_reset_code_invalid_length".tr;
    }
    return null;
  }

  String? validateDefault(String value) {
    if (value.isEmpty) {
      return "error_must_not_be_empty".tr;
    }
    return null;
  }
}
String? validatePasswordConfirmation(String value, String originalPassword) {
  if (value.isEmpty) {
    return "error_password_confirmation_must_not_be_empty".tr;
  } else if (value != originalPassword) {
    return "error_passwords_do_not_match".tr;
  }
  return null;
}

enum ValidatorType {
  Name,
  Email,
  Password,
  LoginPassword,
  PhoneNumber,
  Number,
  Code,
  Default,
}
