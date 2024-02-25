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
  bool _isLoading = false;

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
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      resizeToAvoidBottomInset: true,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Signup'),
      ),
      child: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Create Ego Account",
                    style: TextStyle(
                        color: _controller.theme.primaryColor,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 24.0),
                CupertinoFormSection.insetGrouped(children: [
                  CupertinoTextFormFieldRow(
                    prefix: SizedBox(child: Text("First name")),
                    placeholder: 'required',
                    padding: EdgeInsets.all(12.0),
                    keyboardType: TextInputType.text,
                    controller: _controller.firstName,
                    focusNode: _controller.firstNameFocusNode,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: SizedBox(child: Text("Last name")),
                    placeholder: 'required',
                    padding: EdgeInsets.all(12.0),
                    keyboardType: TextInputType.text,
                    controller: _controller.lastName,
                    focusNode: _controller.lastNameFocusNode,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: SizedBox(child: Text("Email")),
                    placeholder: 'required',
                    padding: EdgeInsets.all(12.0),
                    keyboardType: TextInputType.text,
                    controller: _controller.email,
                    focusNode: _controller.emailFocusNode,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: SizedBox(child: Text("Phone")),
                    placeholder: 'required',
                    padding: EdgeInsets.all(12.0),
                    keyboardType: TextInputType.phone,
                    controller: _controller.phone,
                    focusNode: _controller.phoneFocus,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: SizedBox(child: Text("Password")),
                    placeholder: 'At least 8 characters',
                    padding: EdgeInsets.all(12.0),
                    obscureText: true,
                    controller: _controller.password,
                    focusNode: _controller.passwordFocusNode,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: SizedBox(child: Text("Confirm password")),
                    placeholder: 'Must match password',
                    padding: EdgeInsets.all(12.0),
                    obscureText: true,
                    controller: _controller.confirmPassword,
                    focusNode: _controller.confirmPasswordFocusNode,
                  ),
                ]),
                _controller.errorMessage.isNotEmpty
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            _controller.errorMessage,
                            style: TextStyle(
                              color: CupertinoColors.systemRed,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      child: _isLoading
                          ? CupertinoActivityIndicator(
                              color: CupertinoColors.white,
                            )
                          : Text('Signup',
                              style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
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
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
