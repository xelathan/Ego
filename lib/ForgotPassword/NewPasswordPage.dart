import 'package:ego/ForgotPassword/ForgotPasswordController.dart';
import 'package:ego/Login/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final ForgotPasswordController _controller = ForgotPasswordController();

class NewPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  bool _isLoading = false;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _showToast() {
    String message = 'Password successfully changed';
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: CupertinoColors.darkBackgroundGray,
      ),
      child: Text(
        message,
        style: TextStyle(color: CupertinoColors.white),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    _controller.setNewPasswordState(() {
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
              Text(
                "Password must be at least 8 characters",
                style: TextStyle(
                  color: _controller.theme.primaryColor,
                ),
              ),
              SizedBox(height: 16.0),
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
                  child: _isLoading
                      ? CupertinoActivityIndicator(color: CupertinoColors.white)
                      : Text('Submit', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    if (_controller.validatePassword()) {
                      if (await _controller.changePassword()) {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
                        );
                        _controller.dispose();
                        setState(() {});
                        _showToast();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
