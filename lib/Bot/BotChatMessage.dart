import 'dart:io';

import 'package:ego/Bot/BotController.dart';
import 'package:flutter/cupertino.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:image_picker/image_picker.dart';

BotController _controller = BotController();

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isBot;
  final List<Object> images;
  final bool typewriterEffect;

  ChatMessage(
      {required this.text,
      required this.isBot,
      required this.images,
      required this.typewriterEffect});

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
                  images.length > 0
                      ? Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: images.map((asset) {
                            Image _img = asset as Image;
                            return asset;
                          }).toList(),
                        )
                      : Container(),
                  images.length > 0 ? SizedBox(height: 8) : Container(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: typewriterEffect
                        ? AnimatedTextKit(
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
                          )
                        : Text(
                            text,
                            style: TextStyle(
                              color: CupertinoColors.black,
                            ),
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
                            if (asset is XFile) {
                              return Image.file(
                                File(asset.path),
                                width: 100,
                                height: 100,
                              );
                            } else {
                              return Container();
                            }
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
  final List<Object> images;
  final bool typewriterEffect;

  KeepAliveChatMessage(
      {required this.text,
      required this.isBot,
      required this.images,
      required this.typewriterEffect});

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
      typewriterEffect: widget.typewriterEffect,
    );
  }
}
