import 'package:ego/Bot/BotController.dart';
import 'package:ego/Bot/ImageListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BotController _controller = BotController();

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
        color: CupertinoColors.white,
        child: Column(
          children: [
            _controller.resultList.isNotEmpty && !_controller.sending
                ? Container(
                    padding: EdgeInsets.all(8),
                    child: ImageListWidget(_controller.resultList, (index) {
                      _controller.resultList.removeAt(index);
                      _controller.triggerChatInputState();
                    }),
                  )
                : SizedBox.shrink(),
            Row(
              children: [
                CupertinoButton(
                  // Button for uploading files
                  onPressed: () {
                    _controller.pickImages();
                  },
                  child: Icon(CupertinoIcons.photo),
                ),
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
                              _controller.scrollControllerMessages.animateTo(
                                _controller.scrollControllerMessages.position
                                    .maxScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
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
                      ? () async {
                          // Handle sending message functionality
                          // For example, you can add the message to the list and clear the input field

                          _controller.textEditingController.text == null
                              ? _controller.textEditingController.text = ""
                              : null;

                          _controller.sending = true;
                          _controller.triggerChatInputState();
                          final newMessage = {
                            "text": _controller.textEditingController.text,
                            "isBot": false,
                            "images": _controller.resultList,
                            "typewriterEffect": false
                          };
                          _controller.textEditingController.clear();
                          final imageList = _controller.resultList;
                          _controller.messages.add(newMessage);
                          _controller.triggerBotState();
                          _controller.generateBotResponse(
                              newMessage["text"], imageList);
                          _controller.resultList = [];
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
