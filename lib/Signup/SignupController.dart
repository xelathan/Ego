import 'dart:convert';
import 'package:ego/Api.dart';
import 'package:http/http.dart' as http;
import 'package:ego/Signup/SignupModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupController {
  static final SignupController _this = SignupController._();
  SignupController._();
  factory SignupController() => _this;

  late Function setSignupStateHandler;

  void setSignupState(Function handler) {
    setSignupStateHandler = handler;
  }

  void triggerSignupState() {
    setSignupStateHandler();
  }

  void dispose() {
    SignupModel.firstName.text = "";
    SignupModel.lastName.text = "";
    SignupModel.email.text = "";
    SignupModel.password.text = "";
    SignupModel.phone.text = "";
    SignupModel.confirmPassword.text = "";
    SignupModel.firstNameErrorMessage = "";
    SignupModel.lastNameErrorMessage = "";
    SignupModel.emailErrorMessage = "";
    SignupModel.passwordErrorMessage = "";
    SignupModel.confirmPasswordErrorMessage = "";
    SignupModel.phoneErrorMessage = "";
    SignupModel.firstNameFocus.unfocus();
    SignupModel.lastNameFocus.unfocus();
    SignupModel.emailFocus.unfocus();
    SignupModel.passwordFocus.unfocus();
    SignupModel.confirmPasswordFocus.unfocus();
    SignupModel.phoneFocus.unfocus();
  }

  bool validateSignup(BuildContext context) {
    bool valid = true;
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    final phoneRegExp = RegExp(r'^\(?(\d{3})\)?[-.\s]?(\d{3})[-.\s]?(\d{4})$');
    if (SignupModel.firstName.text.isEmpty) {
      SignupModel.firstNameErrorMessage = "First Name is required";
      valid = false;
    } else {
      SignupModel.firstNameErrorMessage = "";
    }
    if (SignupModel.lastName.text.isEmpty) {
      SignupModel.lastNameErrorMessage = "Last Name is required";
      valid = false;
    } else {
      SignupModel.lastNameErrorMessage = "";
    }
    if (SignupModel.email.text.isEmpty) {
      SignupModel.emailErrorMessage = "Email is required";
      valid = false;
    } else if (!emailRegExp.hasMatch(SignupModel.email.text)) {
      SignupModel.emailErrorMessage = "Invalid email";
      valid = false;
    } else {
      SignupModel.emailErrorMessage = "";
    }

    if (SignupModel.phone.text.isEmpty) {
      SignupModel.phoneErrorMessage = "Phone number is required";
      valid = false;
    } else if (!phoneRegExp.hasMatch(SignupModel.phone.text)) {
      SignupModel.phoneErrorMessage = "Invalid phone number";
      valid = false;
    } else {
      SignupModel.phoneErrorMessage = "";
    }

    if (SignupModel.password.text.isEmpty) {
      SignupModel.passwordErrorMessage = "Password is required";
      valid = false;
    } else if (SignupModel.password.text.length < 8) {
      SignupModel.passwordErrorMessage =
          "Password must be at least 8 characters";
      valid = false;
    } else {
      SignupModel.passwordErrorMessage = "";
    }
    if (SignupModel.confirmPassword.text.isEmpty) {
      SignupModel.confirmPasswordErrorMessage = "Confirm Password is required";
      valid = false;
    } else if (SignupModel.confirmPassword.text != SignupModel.password.text) {
      SignupModel.confirmPasswordErrorMessage = "Password does not match";
      valid = false;
    } else {
      SignupModel.confirmPasswordErrorMessage = "";
    }

    if (SignupModel.firstNameErrorMessage.isNotEmpty) {
      FocusScope.of(context).requestFocus(SignupModel.firstNameFocus);
    } else if (SignupModel.lastNameErrorMessage.isNotEmpty) {
      FocusScope.of(context).requestFocus(SignupModel.lastNameFocus);
    } else if (SignupModel.emailErrorMessage.isNotEmpty) {
      FocusScope.of(context).requestFocus(SignupModel.emailFocus);
    } else if (SignupModel.phoneErrorMessage.isNotEmpty) {
      FocusScope.of(context).requestFocus(SignupModel.phoneFocus);
    } else if (SignupModel.passwordErrorMessage.isNotEmpty) {
      FocusScope.of(context).requestFocus(SignupModel.passwordFocus);
    } else if (SignupModel.confirmPasswordErrorMessage.isNotEmpty) {
      FocusScope.of(context).requestFocus(SignupModel.confirmPasswordFocus);
    }
    triggerSignupState();
    return valid;
  }

  Future<bool> signup(BuildContext context) async {
    final response =
        await http.post(Uri.parse('${Api.endpoint}/signup'), body: {
      'firstName': SignupModel.firstName.text,
      'lastName': SignupModel.lastName.text,
      'email': SignupModel.email.text.toLowerCase(),
      'phone': SignupModel.phone.text,
      'password': SignupModel.password.text,
    });
    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final responseData = jsonDecode(response.body);
      Api.token = responseData['token'];
      Api.refreshToken = responseData['refresh_token'];
      await prefs.setString('token', Api.token);
      await prefs.setString('refreshToken', Api.refreshToken);
      dispose();
      return true;
    } else {
      final responseData = jsonDecode(response.body);
      SignupModel.emailErrorMessage = responseData['message'];
      triggerSignupState();
      return false;
    }
  }

  TextEditingController get email => SignupModel.email;
  TextEditingController get password => SignupModel.password;
  TextEditingController get firstName => SignupModel.firstName;
  TextEditingController get lastName => SignupModel.lastName;
  TextEditingController get phone => SignupModel.phone;
  TextEditingController get confirmPassword => SignupModel.confirmPassword;
  FocusNode get emailFocusNode => SignupModel.emailFocus;
  FocusNode get passwordFocusNode => SignupModel.passwordFocus;
  FocusNode get firstNameFocusNode => SignupModel.firstNameFocus;
  FocusNode get lastNameFocusNode => SignupModel.lastNameFocus;
  FocusNode get confirmPasswordFocusNode => SignupModel.confirmPasswordFocus;
  FocusNode get phoneFocus => SignupModel.phoneFocus;
  String get firstNameErrorMessage => SignupModel.firstNameErrorMessage;
  String get lastNameErrorMessage => SignupModel.lastNameErrorMessage;
  String get emailErrorMessage => SignupModel.emailErrorMessage;
  String get passwordErrorMessage => SignupModel.passwordErrorMessage;
  String get confirmPasswordErrorMessage =>
      SignupModel.confirmPasswordErrorMessage;
  String get phoneErrorMessage => SignupModel.phoneErrorMessage;
  CupertinoThemeData get theme => SignupModel.theme;

  set firstNameErrorMessage(String firstNameErrorMessage) {
    SignupModel.firstNameErrorMessage = firstNameErrorMessage;
  }

  set lastNameErrorMessage(String lastNameErrorMessage) {
    SignupModel.lastNameErrorMessage = lastNameErrorMessage;
  }

  set emailErrorMessage(String emailErrorMessage) {
    SignupModel.emailErrorMessage = emailErrorMessage;
  }

  set phoneErrorMessage(String phoneErrorMessage) {
    SignupModel.phoneErrorMessage = phoneErrorMessage;
  }

  set passwordErrorMessage(String passwordErrorMessage) {
    SignupModel.passwordErrorMessage = passwordErrorMessage;
  }

  set confirmPasswordErrorMessage(String confirmPasswordErrorMessage) {
    SignupModel.confirmPasswordErrorMessage = confirmPasswordErrorMessage;
  }

  set theme(CupertinoThemeData theme) {
    SignupModel.theme = theme;
  }
}
