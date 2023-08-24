import 'package:flutter/material.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';
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
  static List<Asset> resultList = [];
}
