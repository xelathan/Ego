import 'package:ego/ForgotPassword/ForgotPasswordController.dart';
import 'package:ego/ForgotPassword/NewPasswordPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ForgotPasswordController _controller = ForgotPasswordController();

class VerifyCodePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller.setVerifyCodeState(() {
      setState(() {});
    });
    _controller.theme = CupertinoTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CupertinoPageScaffold(
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
                  "Messages for code",
                  style: TextStyle(
                      color: _controller.theme.primaryColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    6,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DigitCardTextField(
                        index: index,
                        controller: _controller.verificationCodeList[index],
                        focusNode: _controller.verificationCodeFocusList[index],
                        onBackspacePressed: () {
                          int focusedIndex = _controller
                              .verificationCodeFocusList
                              .indexWhere((node) => node.hasFocus);
                          _controller.verificationCodeList[focusedIndex]
                              .clear();
                          if (focusedIndex > 0) {
                            print("in");
                            FocusScope.of(context).requestFocus(
                              _controller
                                  .verificationCodeFocusList[focusedIndex - 1],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
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
                SizedBox(height: 8.0),
                CupertinoButton(child: Text("Resend code"), onPressed: () {}),
                SizedBox(height: 8.0),
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
                        ? CupertinoActivityIndicator(
                            color: CupertinoColors.white)
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
      ),
    );
  }
}

class DigitCardTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function? onBackspacePressed;
  final int index;

  DigitCardTextField({
    required this.controller,
    required this.focusNode,
    this.onBackspacePressed,
    required this.index,
  });

  @override
  _DigitCardTextFieldState createState() => _DigitCardTextFieldState();
}

class _DigitCardTextFieldState extends State<DigitCardTextField> {
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode;
    _internalFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      // Rebuild the widget when focus changes
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isFocused = _internalFocusNode.hasFocus;

    return SizedBox(
      width: 45,
      height: 60,
      child: CupertinoTextField(
        style: TextStyle(color: CupertinoColors.systemBlue, fontSize: 32),
        showCursor: false,
        controller: widget.controller,
        focusNode: _internalFocusNode,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: BoxDecoration(
          color: isFocused
              ? CupertinoColors.systemGrey3
              : CupertinoColors.lightBackgroundGray,
          borderRadius: BorderRadius.circular(8.0),
        ),
        textAlignVertical: TextAlignVertical.center,
        onChanged: (value) {
          if (value.isEmpty && widget.onBackspacePressed != null) {
            widget.onBackspacePressed!();
          } else if (value.length == 1 && widget.index != 5) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
