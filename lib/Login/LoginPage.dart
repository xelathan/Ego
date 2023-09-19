import 'package:ego/Home/HomePage.dart';
import 'package:ego/Login/LoginController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final LoginPageController _controller = LoginPageController();

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller.setLoginState(() {
      setState(() {});
    });
    _controller.theme = CupertinoTheme.of(context);

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Login'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Ego",
                style: TextStyle(
                    color: _controller.theme.primaryColor,
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                "It's all about you",
                style: TextStyle(
                  color: _controller.theme.primaryColor,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 24.0),
              CupertinoTextField(
                  placeholder: 'Email',
                  padding: EdgeInsets.all(12.0),
                  keyboardType: TextInputType.text,
                  controller: _controller.email,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: _controller.emailErrorMessage.isNotEmpty
                            ? CupertinoColors.destructiveRed
                            : CupertinoColors.systemGrey3),
                  )),
              _controller.emailErrorMessage.isNotEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _controller.emailErrorMessage,
                        style: TextStyle(
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 16.0),
              CupertinoTextField(
                  placeholder: 'Password',
                  padding: EdgeInsets.all(12.0),
                  obscureText: true,
                  controller: _controller.password,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: _controller.passwordErrorMessage.isNotEmpty
                            ? CupertinoColors.destructiveRed
                            : CupertinoColors.systemGrey3),
                  )),
              _controller.passwordErrorMessage.isNotEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _controller.passwordErrorMessage,
                        style: TextStyle(
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                    )
                  : SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(""),
                  CupertinoButton(
                    onPressed: () {
                      _controller.toForgotPassword(context);
                    },
                    child: Text('Forgot Password?'),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () async {
                    if (_controller.validateLogin()) {
                      if (await _controller.login()) {
                        setState(() {
                          Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => HomePage()),
                            (Route<dynamic> route) => false,
                          );
                        });
                      }
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              const Divider(
                color: Colors.grey, // Set the color to gray
                thickness: 1, // Set the thickness of the divider
              ),
              SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () {
                    // Perform signup action here
                    _controller.toSignUp(context);
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
