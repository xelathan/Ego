import 'package:ego/ForgotPassword/ForgotPasswordController.dart';
import 'package:ego/Home/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:ego/Signup/SignupController.dart';
import 'package:flutter/material.dart';

final ForgotPasswordController _controller = ForgotPasswordController();

class NewPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  @override
  void initState() {
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
    // TODO: implement build

    _controller.setForgotPasswordState(() {
      setState(() {});
    });
    _controller.theme = CupertinoTheme.of(context);
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Forgot Password'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Change Password",
                style: TextStyle(
                    color: _controller.theme.primaryColor,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text("Password must be at least 8 characters"),
              CupertinoTextField(
                  placeholder: 'Password',
                  padding: EdgeInsets.all(12.0),
                  obscureText: true,
                  controller: _controller.newPassword,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: _controller.newPasswordError.isNotEmpty
                            ? CupertinoColors.destructiveRed
                            : CupertinoColors.systemGrey3),
                  )),
              _controller.newPasswordError.isNotEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _controller.newPasswordError,
                        style: TextStyle(
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 16.0),
              CupertinoTextField(
                  placeholder: 'Confirm Password',
                  padding: EdgeInsets.all(12.0),
                  obscureText: true,
                  controller: _controller.confirmPassword,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: _controller.confirmPasswordError.isNotEmpty
                            ? CupertinoColors.destructiveRed
                            : CupertinoColors.systemGrey3),
                  )),
              _controller.confirmPasswordError.isNotEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _controller.confirmPasswordError,
                        style: TextStyle(
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                child: CupertinoButton.filled(
                  child: Text('Submit', style: TextStyle(color: Colors.white)),
                  onPressed: () async {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
