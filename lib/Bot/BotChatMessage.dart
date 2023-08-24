import 'package:ego/Bot/BotController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart'; // Add this line

BotController _controller = BotController();

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isBot;
  final List<Asset> images;

  ChatMessage({required this.text, required this.isBot, required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: isBot
            ? Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "EgoAI",
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          text,
                          textStyle: TextStyle(
                            color: CupertinoColors.black,
                          ),
                          speed: Duration(milliseconds: 25),
                        ),
                      ],
                      onFinished: () {
                        _controller.sending = false;
                        _controller.triggerChatInputState();
                        _controller.triggerBotState();
                      },
                      repeatForever: false,
                      totalRepeatCount: 0,
                      isRepeatingAnimation: false,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "You",
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      text,
                      style: TextStyle(
                        color: CupertinoColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  images.length > 0
                      ? Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: images.map((asset) {
                            return AssetThumb(
                              asset: asset,
                              width: 100,
                              height: 100,
                            );
                          }).toList(),
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }
}

class KeepAliveChatMessage extends StatefulWidget {
  final String text;
  final bool isBot;
  final List<Asset> images;

  KeepAliveChatMessage(
      {required this.text, required this.isBot, required this.images});

  @override
  _KeepAliveChatMessageState createState() => _KeepAliveChatMessageState();
}

class _KeepAliveChatMessageState extends State<KeepAliveChatMessage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChatMessage(
      images: widget.images,
      text: widget.text,
      isBot: widget.isBot,
    );
  }
}
