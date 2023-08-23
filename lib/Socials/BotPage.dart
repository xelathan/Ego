import 'package:ego/Socials/BotController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // Add this line
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

BotController _controller = BotController();

class BotPage extends StatefulWidget {
  @override
  _BotPageState createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> with WidgetsBindingObserver {
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
                      if (index >= _controller.messages.length - 50) {
                        return AutoScrollTag(
                          key: ValueKey(index),
                          controller: _controller.scrollControllerMessages,
                          index: index,
                          child: KeepAliveChatMessage(
                            text: message["text"],
                            isBot: message["isBot"],
                          ),
                        );
                      }
                      return AutoScrollTag(
                        key: ValueKey(index),
                        controller: _controller.scrollControllerMessages,
                        index: index,
                        child: ChatMessage(
                          text: message["text"],
                          isBot: message["isBot"],
                        ),
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

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isBot;

  ChatMessage({required this.text, required this.isBot});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isBot ? Colors.grey[300] : Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: isBot
            ? AnimatedTextKit(
                onTap: () => _controller.focusNode.unfocus(),
                animatedTexts: [
                  TypewriterAnimatedText(text,
                      textStyle: TextStyle(
                        color: isBot ? Colors.black : Colors.white,
                      ),
                      speed: Duration(milliseconds: 25),
                      cursor: ""),
                ],
                isRepeatingAnimation: false,
                repeatForever: false,
                totalRepeatCount: 0,
                onFinished: () {
                  _controller.sending = false;
                  _controller.triggerChatInputState();
                  _controller.triggerBotState();
                },
              )
            : Text(
                text,
                style: TextStyle(
                  color: isBot ? Colors.black : Colors.white,
                ),
              ),
      ),
    );
  }
}

class ChatInput extends StatefulWidget {
  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final int maxLines = 5;

  @override
  Widget build(BuildContext context) {
    _controller.setChatInputState(() {
      setState(() {});
    });
    return GestureDetector(
      onTap: () => _controller.focusNode.unfocus(),
      child: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey[200],
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight:
                          maxLines * 24.0, // Adjust the line height as needed
                    ),
                    child: CupertinoScrollbar(
                      controller: _controller.scrollControllerInput,
                      child: SingleChildScrollView(
                        controller: _controller.scrollControllerInput,
                        child: NotificationListener(
                          onNotification: (notification) {
                            if (_controller.focusNode.hasFocus) {
                              _controller.forceScrollBottom();
                              _controller.triggerBotState();
                            }
                            return false;
                          },
                          child: CupertinoTextField(
                            onTap: () {
                              _controller.scrollControllerMessages
                                  .scrollToIndex(
                                _controller.messages.length - 1,
                                preferPosition: AutoScrollPosition.end,
                              );
                              _controller.triggerBotState();
                            },
                            focusNode: _controller.focusNode,
                            controller: _controller.textEditingController,
                            placeholder: 'Enter a message',
                            padding: EdgeInsets.all(12),
                            maxLines: null, // Allow multiple lines
                            keyboardType: TextInputType.multiline,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CupertinoButton(
                  disabledColor: CupertinoColors.systemGrey,
                  onPressed: !_controller.sending
                      ? () {
                          // Handle sending message functionality
                          // For example, you can add the message to the list and clear the input field
                          _controller.sending = true;
                          _controller.triggerChatInputState();
                          final newMessage = {
                            "text": _controller.textEditingController.text,
                            "isBot": false,
                          };
                          _controller.textEditingController.clear();
                          _controller.messages.add(newMessage);
                          _controller.scrollToBottom();
                          _controller.triggerBotState();
                          _controller.generateBotResponse(newMessage["text"]);
                          _controller.triggerChatInputState();
                        }
                      : null,
                  child: Icon(CupertinoIcons.arrow_up_circle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class KeepAliveChatMessage extends StatefulWidget {
  final String text;
  final bool isBot;

  KeepAliveChatMessage({required this.text, required this.isBot});

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
      text: widget.text,
      isBot: widget.isBot,
    );
  }
}
