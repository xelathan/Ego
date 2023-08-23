import 'dart:convert';

import 'package:ego/Socials/BotModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ego/Api.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class BotController {
  static final BotController _this = BotController._();
  BotController._();
  factory BotController() => _this;

  late Function setBotStateHandler;
  late Function setChatInputStateHandler;

  void setBotState(Function handler) {
    setBotStateHandler = handler;
  }

  void setChatInputState(Function handler) {
    setChatInputStateHandler = handler;
  }

  void triggerBotState() {
    setBotStateHandler();
  }

  void triggerChatInputState() {
    setChatInputStateHandler();
  }

  void init() {}

  void dispose() {
    focusNode.dispose();
  }

  Future<void> generateBotResponse(String message) async {
    final response = await http.post(Uri.parse('${Api.endpoint}/chat'), body: {
      "message": message,
    }, headers: {
      'Authorization': 'Bearer ${Api.token}' // Include the token in the headers
    });
    final data = jsonDecode(response.body);
    BotModel.messages.add({"text": data['bot_message'], "isBot": true});
    scrollToBottom();
    triggerBotState();
  }

  void scrollToBottom() {
    final isUserAtBottom = scrollControllerMessages.position.pixels >=
        scrollControllerMessages.position.maxScrollExtent - 100;

    if (isUserAtBottom) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollControllerMessages.animateTo(
          scrollControllerMessages.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void forceScrollBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollControllerMessages.animateTo(
        scrollControllerMessages.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
  }

  List<Map<String, dynamic>> get messages => BotModel.messages;
  set messages(List<Map<String, dynamic>> messages) {
    BotModel.messages = messages;
  }

  get focusNode => BotModel.focusNode;
  get textEditingController => BotModel.textEditingController;
  ScrollController get scrollControllerInput => BotModel.scrollControllerInput;
  AutoScrollController get scrollControllerMessages =>
      BotModel.scrollControllerMessages;
  GlobalKey get listKey => BotModel.listKey;
  bool get sending => BotModel.sending;
  set sending(bool sending) {
    BotModel.sending = sending;
  }
}
