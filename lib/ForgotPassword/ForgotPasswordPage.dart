import 'package:ego/ForgotPassword/ForgotPasswordController.dart';
import 'package:ego/ForgotPassword/VerifyCodePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final ForgotPasswordController _controller = ForgotPasswordController();

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late FToast fToast;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  _showToast() {
    String message = 'Verification code sent to email';
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

    _controller.setForgotPasswordState(() {
      setState(() {});
    });
    _controller.theme = CupertinoTheme.of(context);
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Forgot Password'),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Send verification code",
                style: TextStyle(
                    color: _controller.theme.primaryColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
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
              SizedBox(height: 24.0),
              Container(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    if (await _controller.validateEmail()) {
                      if (await _controller.sendEmail()) {
                        _showToast();
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => VerifyCodePage()),
                        );
                      }
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: _isLoading
                      ? CupertinoActivityIndicator(color: CupertinoColors.white)
                      : Text(
                          'Submit',
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
