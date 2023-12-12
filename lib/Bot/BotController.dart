import 'dart:convert';
import 'dart:io';
import 'package:ego/Bot/BotDrawer.dart';
import 'package:ego/Bot/BotModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ego/Api.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> triggerBotState() async {
    await setBotStateHandler();
  }

  void triggerChatInputState() {
    setChatInputStateHandler();
  }

  void init() {}

  void dispose() {
    BotModel.textEditingController.text = "";
    BotModel.messages.clear();
    BotModel.resultList.clear();
  }

  Future<void> pickImages() async {
    try {
      resultList = await ImagePicker().pickMultiImage();
    } on Exception catch (e) {
      print(e);
    }

    triggerChatInputState();
  }

  Future<void> generateBotResponse(
      String message, List<XFile> imageList) async {
    List<String> base64Images = [];
    if (imageList.isNotEmpty) {
      List<Uint8List> bytesList = [];
      for (XFile _file in resultList) {
        final file = File(_file.path);
        final bytes = await file.readAsBytes();
        bytesList.add(bytes);
      }
      base64Images = bytesList.map((byteData) {
        Uint8List imageData = byteData.buffer.asUint8List();
        String base64Image = base64Encode(imageData);
        return base64Image;
      }).toList();
    }

    final response = await http.post(Uri.parse('${Api.endpoint}/chat'),
        body: jsonEncode({"message": message, "image": base64Images}),
        headers: {
          'Authorization': 'Bearer ${Api.token}',
          'Content-Type': 'application/json',
        });
    final data = jsonDecode(response.body);
    print(data['image'] != "");

    if (data['image'] != "") {
      Uint8List bytes = base64Decode(data['image']);
      Image image = Image.memory(bytes);

      BotModel.messages.add({
        "text": data['message'],
        "isBot": true,
        "images": <Image>[image],
        'typewriterEffect': true
      });
    } else {
      BotModel.messages.add({
        "text": data['message'],
        "isBot": true,
        "images": <Image>[],
        'typewriterEffect': true,
      });
    }
    triggerBotState();
  }

  Future<void> newThread() async {
    BotModel.messages = [];
    final response =
        await http.post(Uri.parse('${Api.endpoint}/new_thread'), headers: {
      'Authorization': 'Bearer ${Api.token}',
      'Content-Type': 'application/json',
    });

    final data = jsonDecode(response.body);
    print(data);
    triggerBotState();
  }

  PageRouteBuilder openDrawer() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BotDrawer(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset(0.0, 0.0);
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Future<List<dynamic>> getThreads() async {
    final response =
        await http.get(Uri.parse('${Api.endpoint}/get_threads'), headers: {
      'Authorization': 'Bearer ${Api.token}',
      'Content-Type': 'application/json',
    });

    final data = jsonDecode(response.body);
    if (response.statusCode == 400) {
      return [];
    }
    return data['threads'];
  }

  Future<void> loadThread(context, thread_id) async {
    final response = await http.post(Uri.parse('${Api.endpoint}/load_thread'),
        headers: {
          'Authorization': 'Bearer ${Api.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"thread_id": thread_id}));

    BotModel.messages = [];
    final data = jsonDecode(response.body);

    for (int i = data['messages'].length - 1; i >= 0; i--) {
      if (data['messages'][i]['role'] == 'user') {
        BotModel.messages.add({
          "text": data['messages'][i]['message'],
          "isBot": false,
          "images": <Image>[],
          'typewriterEffect': false
        });
      } else {
        BotModel.messages.add({
          "text": data['messages'][i]['message'],
          "isBot": true,
          "images": <Image>[],
          'typewriterEffect': false
        });
      }
    }
    BotModel.isDrawerOpen = false;
    await triggerBotState();
  }

  void showRenameOption(context, thread_id) {
    Navigator.pop(context);
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Rename'),
          content: Column(
            children: [
              Text('Enter the new name for the thread: '),
              CupertinoTextField(
                style: TextStyle(
                  fontSize: 14.0, // Set your desired font size
                ),
                placeholder: "Name",
                controller: rename,
              )
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () async {
                final response = await http.post(
                    Uri.parse("${Api.endpoint}/rename_thread"),
                    headers: {
                      'Authorization': 'Bearer ${Api.token}',
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode(
                        {"thread_id": thread_id, "name": rename.text}));

                print(jsonDecode(response.body));
                rename.clear();
                Navigator.of(context).pop();
                triggerBotState();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteThread(thread_id, context) async {
    final response = await http.post(Uri.parse('${Api.endpoint}/delete_thread'),
        headers: {
          'Authorization': 'Bearer ${Api.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"thread_id": thread_id}));

    final data = jsonDecode(response.body);
    if (data['status'] == "success") {
      if (data['delete_current']) {
        BotModel.messages = [];
      }
      Navigator.of(context).pop();
      triggerBotState();
    }
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

  List<XFile> get resultList => BotModel.resultList;
  set resultList(List<XFile> resultList) {
    BotModel.resultList = resultList;
  }

  bool get isDrawerOpen => BotModel.isDrawerOpen;
  set isDrawerOpen(bool isDrawerOpen) {
    BotModel.isDrawerOpen = isDrawerOpen;
  }

  TextEditingController get rename => BotModel.rename;
}
