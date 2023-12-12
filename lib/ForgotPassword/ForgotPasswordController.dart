import 'dart:convert';

import 'package:ego/ForgotPassword/ForgotPasswordModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ego/Api.dart';

class ForgotPasswordController {
  static final ForgotPasswordController _this = ForgotPasswordController._();
  ForgotPasswordController._();
  factory ForgotPasswordController() => _this;

  late Function setForgotPasswordStateHandler;
  late Function setVerifyCodeStateHandler;
  late Function setNewPasswordStateHandler;

  void setForgotPasswordState(Function handler) {
    setForgotPasswordStateHandler = handler;
  }

  void triggerForgotPasswordState() {
    setForgotPasswordStateHandler();
  }

  void setVerifyCodeState(Function handler) {
    setVerifyCodeStateHandler = handler;
  }

  void triggerVerifyCodeState() {
    setVerifyCodeStateHandler();
  }

  void setNewPasswordState(Function handler) {
    setNewPasswordStateHandler = handler;
  }

  void triggerNewPasswordState() {
    setNewPasswordStateHandler();
  }

  void dispose() {
    ForgotPasswordModel.phoneNumber.text = "";
    ForgotPasswordModel.newPassword.text = "";
    ForgotPasswordModel.confirmPassword.text = "";
    ForgotPasswordModel.confirmPasswordError = "";
    ForgotPasswordModel.newPasswordError = "";
    ForgotPasswordModel.verificationCodeList
        .forEach((controller) => controller.text = "");
    ForgotPasswordModel.verificationCodeFocusList
        .forEach((controller) => controller.unfocus());
    ForgotPasswordModel.verificationCodeError = "";
    ForgotPasswordModel.phoneErrorMessage = "";
  }

  Future<bool> validatePhoneNumber() async {
    bool valid = true;
    RegExp phoneRegExp = RegExp(r'^\(?(\d{3})\)?[-.\s]?(\d{3})[-.\s]?(\d{4})$');
    if (ForgotPasswordModel.phoneNumber.text.isEmpty) {
      ForgotPasswordModel.phoneErrorMessage = "Phone Number is required";
      valid = false;
    } else if (!phoneRegExp.hasMatch(ForgotPasswordModel.phoneNumber.text)) {
      ForgotPasswordModel.phoneErrorMessage = "Invalid Phone Number";
      valid = false;
    } else {
      final response = await http.post(
        Uri.parse('${Api.endpoint}/validate_phone'),
        body: {
          'phone': ForgotPasswordModel.phoneNumber.text,
        },
      );
      if (response.statusCode == 200) {
        ForgotPasswordModel.phoneErrorMessage = "";
      } else {
        ForgotPasswordModel.phoneErrorMessage = "Phone Number doesn't exist";
        valid = false;
      }
    }
    triggerForgotPasswordState();
    return Future(() => valid);
  }

  Future<bool> sendSMS() async {
    bool success = false;
    final response = await http.post(
      Uri.parse('${Api.endpoint}/send_sms'),
      body: {
        'phone': ForgotPasswordModel.phoneNumber.text,
      },
    );

    if (response.statusCode == 200) {
      triggerForgotPasswordState();
      success = true;
      return Future(() => success);
    } else {
      print("Could not send sms");
      return Future(() => success);
    }
  }

  Future<bool> validateCode() async {
    bool success = false;
    final response = await http.post(
      Uri.parse('${Api.endpoint}/verify_code'),
      body: {
        'code': verificationCode,
      },
    );
    if (response.statusCode == 200) {
      success = true;
      return Future(() => success);
    } else {
      success = false;
      final data = jsonDecode(response.body);
      ForgotPasswordModel.verificationCodeError = data['message'];
      triggerVerifyCodeState();
      return Future(() => success);
    }
  }

  bool validatePassword() {
    bool valid = true;
    if (ForgotPasswordModel.newPassword.text.isEmpty) {
      ForgotPasswordModel.newPasswordError = "Password is required";
      valid = false;
    } else if (ForgotPasswordModel.newPassword.text.length < 8) {
      ForgotPasswordModel.newPasswordError =
          "Password must be at least 8 characters";
      valid = false;
    } else {
      ForgotPasswordModel.newPasswordError = "";
    }

    if (ForgotPasswordModel.confirmPassword.text.isEmpty) {
      ForgotPasswordModel.confirmPasswordError = "Confirm Password is required";
      valid = false;
    } else if (ForgotPasswordModel.confirmPassword.text !=
        ForgotPasswordModel.newPassword.text) {
      ForgotPasswordModel.confirmPasswordError = "Password does not match";
      valid = false;
    } else {
      ForgotPasswordModel.confirmPasswordError = "";
    }

    triggerNewPasswordState();
    return valid;
  }

  Future<bool> changePassword() async {
    bool success = false;
    final response = await http.post(
      Uri.parse('${Api.endpoint}/change_password'),
      body: {
        'phone': ForgotPasswordModel.phoneNumber.text,
        'password': ForgotPasswordModel.newPassword.text,
        'code': verificationCode
      },
    );
    if (response.statusCode == 200) {
      success = true;
    }
    return Future(() => success);
  }

  String get verificationCode => ForgotPasswordModel.verificationCodeList
      .map((controller) => controller.text)
      .join();
  TextEditingController get phoneNumber => ForgotPasswordModel.phoneNumber;
  TextEditingController get newPassword => ForgotPasswordModel.newPassword;
  List<TextEditingController> get verificationCodeList =>
      ForgotPasswordModel.verificationCodeList;
  List<FocusNode> get verificationCodeFocusList =>
      ForgotPasswordModel.verificationCodeFocusList;
  TextEditingController get confirmPassword =>
      ForgotPasswordModel.confirmPassword;
  CupertinoThemeData get theme => ForgotPasswordModel.theme;
  String get phoneErrorMessage => ForgotPasswordModel.phoneErrorMessage;
  String get verificationCodeErrorMessage =>
      ForgotPasswordModel.verificationCodeError;
  String get newPasswordError => ForgotPasswordModel.newPasswordError;
  String get confirmPasswordError => ForgotPasswordModel.confirmPasswordError;

  set theme(CupertinoThemeData theme) {
    ForgotPasswordModel.theme = theme;
  }
}
