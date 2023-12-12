import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class BotModel {
  static List<Map<String, dynamic>> messages = [];
  static final GlobalKey listKey = GlobalKey();
  static final FocusNode focusNode = FocusNode();
  static final TextEditingController textEditingController =
      TextEditingController();
  static final ScrollController scrollControllerInput = ScrollController();
  static final AutoScrollController scrollControllerMessages =
      AutoScrollController();
  static bool sending = false;
  bool isKeyboardVisible = false;
  static List<XFile> resultList = [];
  static List<dynamic> threads = [];
  static bool isDrawerOpen = false;
  static TextEditingController rename = TextEditingController();
}
