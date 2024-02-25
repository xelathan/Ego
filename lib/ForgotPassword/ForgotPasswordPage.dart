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
    String message = 'Verification code sent to phone';
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
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Forgot Password'),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Send verification code",
                  style: TextStyle(
                      color: _controller.theme.primaryColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 24.0),
              CupertinoFormSection.insetGrouped(children: [
                CupertinoTextFormFieldRow(
                  prefix: Text("Phone"),
                  padding: const EdgeInsets.all(12.0),
                  keyboardType: TextInputType.phone,
                  controller: _controller.phoneNumber,
                ),
              ]),
              _controller.phoneErrorMessage.isNotEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          _controller.phoneErrorMessage,
                          style: const TextStyle(
                            color: CupertinoColors.systemRed,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Container(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      // _showToast();
                      // Navigator.push(
                      //   context,
                      //   CupertinoPageRoute(
                      //       builder: (context) => VerifyCodePage()),
                      // );
                      if (await _controller.validatePhoneNumber()) {
                        if (await _controller.sendSMS()) {
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
                        ? CupertinoActivityIndicator(
                            color: CupertinoColors.white)
                        : Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
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
