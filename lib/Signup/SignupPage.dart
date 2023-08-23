import 'package:ego/Home/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:ego/Signup/SignupController.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SignupController _controller = SignupController();

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

    _controller.setSignupState(() {
      setState(() {});
    });
    _controller.theme = CupertinoTheme.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Signup'),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create Ego Account",
                style: TextStyle(
                    color: _controller.theme.primaryColor,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              CupertinoTextField(
                placeholder: 'First Name',
                padding: EdgeInsets.all(12.0),
                keyboardType: TextInputType.text,
                controller: _controller.firstName,
                focusNode: _controller.firstNameFocusNode,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                      color: _controller.firstNameErrorMessage.isNotEmpty
                          ? CupertinoColors.destructiveRed
                          : CupertinoColors.systemGrey3),
                ),
              ),
              _controller.firstNameErrorMessage.isNotEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _controller.firstNameErrorMessage,
                        style: TextStyle(
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 16.0),
              CupertinoTextField(
                  placeholder: 'Last Name',
                  padding: EdgeInsets.all(12.0),
                  keyboardType: TextInputType.text,
                  controller: _controller.lastName,
                  focusNode: _controller.lastNameFocusNode,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: _controller.lastNameErrorMessage.isNotEmpty
                            ? CupertinoColors.destructiveRed
                            : CupertinoColors.systemGrey3),
                  )),
              _controller.lastNameErrorMessage.isNotEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _controller.lastNameErrorMessage,
                        style: TextStyle(
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 16.0),
              CupertinoTextField(
                  placeholder: 'Email',
                  padding: EdgeInsets.all(12.0),
                  keyboardType: TextInputType.text,
                  controller: _controller.email,
                  focusNode: _controller.emailFocusNode,
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
              const Divider(
                color: Colors.grey, // Set the color to gray
                thickness: 1, // Set the thickness of the divider
              ),
              SizedBox(height: 16.0),
              Text("Password must be at least 8 characters"),
              SizedBox(height: 16.0),
              CupertinoTextField(
                  placeholder: 'Password',
                  padding: EdgeInsets.all(12.0),
                  obscureText: true,
                  controller: _controller.password,
                  focusNode: _controller.passwordFocusNode,
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
              SizedBox(height: 16.0),
              CupertinoTextField(
                  placeholder: 'Confirm Password',
                  padding: EdgeInsets.all(12.0),
                  obscureText: true,
                  controller: _controller.confirmPassword,
                  focusNode: _controller.confirmPasswordFocusNode,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color:
                            _controller.confirmPasswordErrorMessage.isNotEmpty
                                ? CupertinoColors.destructiveRed
                                : CupertinoColors.systemGrey3),
                  )),
              _controller.confirmPasswordErrorMessage.isNotEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _controller.confirmPasswordErrorMessage,
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
                  child: Text('Signup', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (_controller.validateSignup(context)) {
                      if (await _controller.signup(context)) {
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
