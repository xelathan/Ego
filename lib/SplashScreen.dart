import 'dart:convert';

import 'package:ego/Api.dart';
import 'package:ego/Home/HomePage.dart';
import 'package:ego/Login/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  void _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? refreshToken = prefs.getString('refreshToken');
    // Wait for a moment to simulate a splash screen

    await Future.delayed(Duration(seconds: 2));

    if (token != null &&
        token.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty) {
      final response = await http.post(
        Uri.parse('${Api.endpoint}/refresh_token'),
        body: {
          "refresh_token": refreshToken,
          "access_token": token,
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Api.token = responseData['access_token'];
        await prefs.setString('token', Api.token);
        Navigator.pushReplacement(
          context,
          _fadePageRouteBuilder(HomePage()),
        );
      } else if (response.statusCode == 400) {
        Api.token = token;
        Navigator.pushReplacement(
          context,
          _fadePageRouteBuilder(HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          _fadePageRouteBuilder(LoginPage()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        _fadePageRouteBuilder(LoginPage()),
      );
    }
  }

  PageRouteBuilder _fadePageRouteBuilder(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        var fadeAnimation =
            Tween<double>(begin: begin, end: end).animate(animation);
        return FadeTransition(opacity: fadeAnimation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: Curves.easeOut, // Use an easing curve
      ),
      child: Container(
        color: CupertinoColors.white,
        child: Center(
          child: Text(
            "Ego",
            style: TextStyle(
                color: CupertinoTheme.of(context).primaryColor,
                fontSize: 48.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
