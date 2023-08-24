import 'dart:convert';
import 'package:ego/Bot/BotModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ego/Api.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';

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

  void dispose() {}

  Future<void> pickImages() async {
    try {
      resultList = await MultipleImagesPicker.pickImages(
        maxImages: 5, // Maximum number of images to select
        enableCamera: true, // Allow capturing images from camera
      );
    } on Exception catch (e) {
      // Handle exception if any
      print(e);
    }

    triggerChatInputState();
  }

  Future<void> generateBotResponse(
      String message, List<Asset> imageList) async {
    final response = await http.post(Uri.parse('${Api.endpoint}/chat'), body: {
      "message": message,
    }, headers: {
      'Authorization': 'Bearer ${Api.token}' // Include the token in the headers
    });
    final data = jsonDecode(response.body);

    if (imageList.isNotEmpty) {
      List<Uint8List> imageBytesList =
          await Future.wait(imageList.map((asset) async {
        ByteData byteData = await asset.getByteData();
        return byteData.buffer.asUint8List();
      }));
      List<String> base64Images = imageBytesList.map((byteData) {
        Uint8List imageData = byteData.buffer.asUint8List();
        String base64Image = base64Encode(imageData);
        return base64Image;
      }).toList();
      final response =
          await http.post(Uri.parse('${Api.endpoint}/upload_image'),
              body: jsonEncode({
                "images": base64Images,
              }),
              headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${Api.token}' // Include the token in the headers
          });

      print(jsonDecode(response.body));
    }

    BotModel.messages
        .add({"text": data['bot_message'], "isBot": true, "images": <Asset>[]});
    scrollToBottom();
    triggerBotState();
  }

  void scrollToBottom() {
    final isUserAtBottom = scrollControllerMessages.position.pixels >=
        scrollControllerMessages.position.maxScrollExtent - 50;

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

  List<Asset> get resultList => BotModel.resultList;
  set resultList(List<Asset> resultList) {
    BotModel.resultList = resultList;
  }
}
