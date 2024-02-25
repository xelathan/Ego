import 'dart:convert';

import 'package:ego/Api.dart';
import 'package:ego/Settings/Account/AccountModel.dart';
import 'package:http/http.dart' as http;

class AccountController {
  static final AccountController _this = AccountController._();
  AccountController._();
  factory AccountController() => _this;

  late Function setAccountStateHandler;

  void setAccountState(Function handler) {
    setAccountStateHandler = handler;
  }

  void triggerAccountState() {
    setAccountStateHandler();
  }

  void dispose() {
    AccountModel.firstName.text = "";
    AccountModel.lastName.text = "";
    AccountModel.email.text = "";
    AccountModel.phone.text = "";
    AccountModel.newPassword.text = "";
    AccountModel.password_section_two.text = "";
    AccountModel.errorMessage = "";
    AccountModel.errorMessagePassword = "";
  }

  bool validateChanges() {
    bool valid = true;
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    final phoneRegExp = RegExp(r'^\(?(\d{3})\)?[-.\s]?(\d{3})[-.\s]?(\d{4})$');
    if (AccountModel.firstName.text.isEmpty) {
      AccountModel.errorMessage = "First name is required";
      valid = false;
    } else if (AccountModel.lastName.text.isEmpty) {
      AccountModel.errorMessage = "Last name is required";
      valid = false;
    } else if (AccountModel.email.text.isEmpty) {
      AccountModel.errorMessage = "Email is required";
      valid = false;
    } else if (!emailRegExp.hasMatch(AccountModel.email.text)) {
      AccountModel.errorMessage = "Invalid email";
      valid = false;
    } else if (AccountModel.phone.text.isEmpty) {
      AccountModel.errorMessage = "Phone is required";
      valid = false;
    } else if (!phoneRegExp.hasMatch(AccountModel.phone.text)) {
      AccountModel.errorMessage = "Invalid phone number";
      valid = false;
    } else if (AccountModel.password.text.isEmpty) {
      AccountModel.errorMessage = "Password is required";
      valid = false;
    } else {
      valid = true;
      AccountModel.errorMessage = "";
    }

    return valid;
  }

  bool validateNewPassword() {
    bool valid = true;
    if (AccountModel.newPassword.text.isEmpty) {
      AccountModel.errorMessagePassword = "New password required";
      valid = false;
    } else if (AccountModel.newPassword.text.length < 8) {
      AccountModel.errorMessagePassword =
          "Password must be at least 8 characters";
      valid = false;
    } else if (AccountModel.password_section_two.text.isEmpty) {
      AccountModel.errorMessagePassword = "Current password required";
      valid = false;
    } else if (AccountModel.password_section_two.text ==
        AccountModel.newPassword.text) {
      AccountModel.errorMessagePassword =
          "New password can't be the same as current password";
      valid = false;
    } else {
      AccountModel.errorMessagePassword = "";
      valid = true;
    }

    return valid;
  }

  Future<bool> saveNewPassword() async {
    final response = await http.post(Uri.parse('${Api.endpoint}/new_password'),
        headers: {
          'Authorization': 'Bearer ${Api.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "new_password": AccountModel.newPassword.text,
          "current_password": AccountModel.password_section_two.text,
        }));
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      AccountModel.errorMessage = data['message'];
      return false;
    }
  }

  Future<bool> saveInfo() async {
    final response =
        await http.post(Uri.parse('${Api.endpoint}/update_user_info'),
            headers: {
              'Authorization': 'Bearer ${Api.token}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "first_name": AccountModel.firstName.text,
              "last_name": AccountModel.lastName.text,
              "email": AccountModel.email.text,
              "phone": AccountModel.phone.text,
              "password": AccountModel.password.text
            }));

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      AccountModel.errorMessage = data['message'];
      return false;
    }
  }

  get firstName => AccountModel.firstName;
  get lastName => AccountModel.lastName;
  get email => AccountModel.email;
  get phone => AccountModel.phone;
  get password => AccountModel.password;
  get errorMessage => AccountModel.errorMessage;
  get newPassword => AccountModel.newPassword;
  get password_section_two => AccountModel.password_section_two;
  get errorMessagePassword => AccountModel.errorMessagePassword;

  Future<bool> retrieveUserInfo() async {
    final response =
        await http.post(Uri.parse('${Api.endpoint}/get_user_data'), headers: {
      'Authorization': 'Bearer ${Api.token}',
      'Content-Type': 'application/json',
    });

    final data = jsonDecode(response.body);
    AccountModel.firstName.text = data['firstName'];
    AccountModel.lastName.text = data['lastName'];
    AccountModel.email.text = data['email'];
    AccountModel.phone.text = data['phone'];
    return true;
  }
}
