import 'package:ego/Bot/BotController.dart';
import 'package:flutter/cupertino.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:ego/Bot/BotChatInput.dart';
import 'package:ego/Bot/BotChatMessage.dart';

BotController _controller = BotController();

class BotPage extends StatefulWidget {
  @override
  _BotPageState createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> with WidgetsBindingObserver {
  double _previousMessageHeight = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.init();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    if (_controller.focusNode.hasFocus) {
      _controller.forceScrollBottom();
    }
  }

  double calculateSingleLineHeight(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.height;
  }

  double calculateTextHeight(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(fontSize: 16.0)), // Adjust the font size as needed
      maxLines: null,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);
    return textPainter.height;
  }

  @override
  Widget build(BuildContext context) {
    _controller.setBotState(() {
      setState(() {});
    });
    return KeyboardDismisser(
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('EgoAI'),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CupertinoScrollbar(
                  controller: _controller.scrollControllerMessages,
                  child: ListView.builder(
                    key: _controller.listKey,
                    controller: _controller.scrollControllerMessages,
                    itemCount: _controller.messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message = _controller.messages[index];
                      final messageText = message["text"];

                      final textStyle = TextStyle(
                          fontSize: 16.0); // Adjust font size as needed
                      final textPainter = TextPainter(
                        text: TextSpan(text: messageText, style: textStyle),
                        textDirection: TextDirection.ltr,
                      );
                      textPainter.layout();

                      final messageContainerWidth =
                          MediaQuery.of(context).size.width *
                              0.7; // Adjust as needed

                      if (textPainter.width > messageContainerWidth &&
                          _controller.sending) {
                        Future.delayed(Duration(milliseconds: 50), () {
                          _controller.scrollToBottom();
                          _controller.triggerBotState();
                        });
                      }

                      return AutoScrollChatMessage(
                        text: messageText,
                        isBot: message["isBot"],
                        images: message["images"],
                        index: index,
                      );
                    },
                  ),
                ),
              ),
              ChatInput(),
            ],
          ),
        ),
      ),
    );
  }
}

class AutoScrollChatMessage extends StatefulWidget {
  final String text;
  final bool isBot;
  final int index;
  final List<Asset> images;

  AutoScrollChatMessage(
      {required this.text,
      required this.isBot,
      required this.index,
      required this.images});

  @override
  _AutoScrollChatMessageState createState() => _AutoScrollChatMessageState();
}

class _AutoScrollChatMessageState extends State<AutoScrollChatMessage> {
  bool shouldScrollDown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        shouldScrollDown = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AutoScrollTag(
      key: Key(widget.index.toString()),
      controller: _controller.scrollControllerMessages,
      index: widget.index,
      child: shouldScrollDown
          ? (widget.isBot
              ? KeepAliveChatMessage(
                  text: widget.text,
                  isBot: widget.isBot,
                  images: widget.images,
                )
              : ChatMessage(
                  text: widget.text,
                  isBot: widget.isBot,
                  images: widget.images,
                ))
          : Container(), // Placeholder before it's ready to scroll
    );
  }
}
