import 'package:ego/Socials/BotPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class KeyboardAwareWidget extends StatefulWidget {
  final Widget child;

  const KeyboardAwareWidget({required this.child});

  @override
  _KeyboardAwareWidgetState createState() => _KeyboardAwareWidgetState();
}

class _KeyboardAwareWidgetState extends State<KeyboardAwareWidget> {
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        if (_isKeyboardVisible)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ChatInput(),
          ),
      ],
    );
  }
}
