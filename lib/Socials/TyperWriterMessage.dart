import 'dart:async';
import 'package:flutter/material.dart';

class TypewriterChatMessage extends StatefulWidget {
  final String text;
  final bool isBot;

  TypewriterChatMessage({required this.text, required this.isBot});

  @override
  _TypewriterChatMessageState createState() => _TypewriterChatMessageState();
}

class _TypewriterChatMessageState extends State<TypewriterChatMessage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late StreamController<int> _streamController;
  late ScrollController _scrollController;

  int _currentLine = 0; // Track the current line being displayed

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100 * widget.text.length),
    );

    _streamController = StreamController<int>();

    _scrollController = ScrollController();

    _animationController.forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // When the animation completes, update the current line and scroll to the bottom
        setState(() {
          _currentLine = widget.text.length - 1;
        });
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _streamController.close();
    super.dispose();
  }

  void _onLineChange(int lineIndex) {
    if (!_streamController.isClosed) {
      _streamController.sink.add(lineIndex);

      // Check if the line index has reached the last line
      if (lineIndex == widget.text.length - 1) {
        // Scroll to the bottom
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: widget.isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: widget.isBot ? Colors.grey[300] : Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: StreamBuilder<int>(
          stream: _streamController.stream,
          initialData: -1,
          builder: (context, snapshot) {
            final lineIndex = snapshot.data ?? -1;
            final currentText = widget.text.substring(0, lineIndex + 1);
            return Text(
              currentText,
              style: TextStyle(
                color: widget.isBot ? Colors.black : Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
