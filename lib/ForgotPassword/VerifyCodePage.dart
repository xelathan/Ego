import 'package:ego/ForgotPassword/ForgotPasswordController.dart';
import 'package:ego/ForgotPassword/NewPasswordPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final ForgotPasswordController _controller = ForgotPasswordController();

class VerifyCodePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    _controller.setVerifyCodeState(() {
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
                "Check email for code",
                style: TextStyle(
                    color: _controller.theme.primaryColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24.0),
              CupertinoTextField(
                  placeholder: 'Verification code',
                  padding: EdgeInsets.all(12.0),
                  keyboardType: TextInputType.text,
                  controller: _controller.verificationCode,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color:
                            _controller.verificationCodeErrorMessage.isNotEmpty
                                ? CupertinoColors.destructiveRed
                                : CupertinoColors.systemGrey3),
                  )),
              _controller.verificationCodeErrorMessage.isNotEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _controller.verificationCodeErrorMessage,
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
                    if (await _controller.validateCode()) {
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => NewPasswordPage()),
                      );
                    }
                  },
                  child: _isLoading
                      ? CupertinoActivityIndicator(color: CupertinoColors.white)
                      : Text(
                          'Send',
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
