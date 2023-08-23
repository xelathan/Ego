import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class BotModel {
  static List<Map<String, dynamic>> messages = [
    {
      "text":
          "Hi, I'm EgoAI, your personal assistant. I can help you with your social media marketing. What would you like to do?",
      "isBot": true
    },
    {
      "text":
          "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
      "isBot": false
    }
  ];
  static final GlobalKey listKey = GlobalKey();
  static final FocusNode focusNode = FocusNode();
  static final TextEditingController textEditingController =
      TextEditingController();
  static final ScrollController scrollControllerInput = ScrollController();
  static final AutoScrollController scrollControllerMessages =
      AutoScrollController();
  static bool sending = false;
  bool isKeyboardVisible = false;
}
