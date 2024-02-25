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
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.setLoginState(() {
      setState(() {});
    });
    _controller.theme = CupertinoTheme.of(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
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
              CupertinoFormSection.insetGrouped(
                children: [
                  CupertinoTextFormFieldRow(
                    prefix: Text("Email"),
                    padding: EdgeInsets.all(12.0),
                    keyboardType: TextInputType.emailAddress,
                    controller: _controller.email,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: Text("Password"),
                    padding: EdgeInsets.all(12.0),
                    obscureText: true,
                    controller: _controller.password,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ],
              ),
              _controller.errorMessage.isNotEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text(
                          _controller.errorMessage,
                          style: TextStyle(
                            color: CupertinoColors.systemRed,
                          ),
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
                      _controller.dispose();
                      setState(() {});
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
                    setState(() {
                      _isLoading = true;
                    });
                    if (_controller.validateLogin()) {
                      if (await _controller.login()) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(builder: (context) => HomePage()),
                          (Route<dynamic> route) => false,
                        );
                        _controller.dispose();
                        setState(() {});
                      }
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: _isLoading
                      ? CupertinoActivityIndicator(color: CupertinoColors.white)
                      : Text(
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
                    _controller.dispose();
                    setState(() {});
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
