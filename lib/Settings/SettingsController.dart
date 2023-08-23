import 'package:ego/Api.dart';
import 'package:ego/Login/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController {
  static final SettingsController _this = SettingsController._();
  SettingsController._();
  factory SettingsController() => _this;

  late Function setSettingsStateHandler;

  void setSettingsState(Function handler) {
    setSettingsStateHandler = handler;
  }

  void triggerSignupState() {
    setSettingsStateHandler();
  }

  Future<void> signOut(BuildContext context) async {
    final response =
        await http.post(Uri.parse('${Api.endpoint}/sign_out'), headers: {
      'Authorization': 'Bearer ${Api.token}',
    });
    if (response.statusCode == 200) {
      Api.token = "";
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', Api.token);
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
}
