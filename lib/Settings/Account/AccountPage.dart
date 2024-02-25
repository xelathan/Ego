import 'package:ego/Settings/Account/AccountController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _controller = AccountController();

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AccountPageState();
  }
}

class AccountPageState extends State<AccountPage> {
  bool _isLoading = false;
  bool _isLoading2 = false;
  late FToast fToast;
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

  _showToast(message) {
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
    _controller.setAccountState(() {
      setState(() {});
    });
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      resizeToAvoidBottomInset: true,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Account'),
      ),
      child: SafeArea(
        child: FutureBuilder(
            future: _controller.retrieveUserInfo(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text("Account Info"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: CupertinoFormSection.insetGrouped(
                            children: [
                              CupertinoTextFormFieldRow(
                                prefix: Text("First name:"),
                                controller: _controller.firstName,
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: Text("Last name:"),
                                controller: _controller.lastName,
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: Text("Email:"),
                                controller: _controller.email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: Text("Phone:"),
                                controller: _controller.phone,
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                        ),
                        CupertinoFormSection.insetGrouped(
                          children: [
                            CupertinoTextFormFieldRow(
                              prefix: Text("Current password:"),
                              controller: _controller.password,
                              placeholder: "required",
                              obscureText: true,
                            )
                          ],
                        ),
                        _controller.errorMessage != ""
                            ? Align(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    _controller.errorMessage,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Container(
                            width: double.infinity,
                            child: CupertinoButton.filled(
                              onPressed: () async {
                                if (!_isLoading2) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (_controller.validateChanges()) {
                                    if (await _controller.saveInfo()) {
                                      await _controller.retrieveUserInfo();
                                      _controller.password.text = "";
                                      _showToast(
                                          "Account info successfully changed");
                                      _controller.triggerAccountState();
                                    }
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                              child: _isLoading
                                  ? CupertinoActivityIndicator(
                                      color: CupertinoColors.white)
                                  : Text(
                                      'Save Info',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text("Change password"),
                        SizedBox(
                          height: 20,
                        ),
                        CupertinoFormSection.insetGrouped(children: [
                          CupertinoTextFormFieldRow(
                            prefix: Text("New password:"),
                            controller: _controller.newPassword,
                            obscureText: true,
                            placeholder: "At least 8 characters",
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: Text("Current Password:"),
                            controller: _controller.password_section_two,
                            obscureText: true,
                            placeholder: "required",
                          ),
                        ]),
                        _controller.errorMessagePassword != ""
                            ? Align(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    _controller.errorMessagePassword,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              )
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 16),
                          child: Container(
                            width: double.infinity,
                            child: CupertinoButton.filled(
                              onPressed: () async {
                                if (!_isLoading) {
                                  setState(() {
                                    _isLoading2 = true;
                                  });
                                  if (_controller.validateNewPassword()) {
                                    if (await _controller.saveNewPassword()) {
                                      _controller.newPassword.text = "";
                                      _controller.password_section_two.text =
                                          "";
                                      _showToast(
                                          "Password successfully changed");
                                      _controller.triggerAccountState();
                                    }
                                  }
                                  setState(() {
                                    _isLoading2 = false;
                                  });
                                }
                              },
                              child: _isLoading2
                                  ? CupertinoActivityIndicator(
                                      color: CupertinoColors.white)
                                  : Text(
                                      'Save password',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: CupertinoActivityIndicator());
              }
            }),
      ),
    );
  }
}
