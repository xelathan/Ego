import 'dart:convert';
import 'package:ego/Api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;

class SocialLoginPage extends StatelessWidget {
  SocialLoginPage({Key? key, required this.socialName}) : super(key: key);
  final String socialName;

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      if (url.startsWith('https://ego-api-9d0b64be123d.herokuapp.com/')) {
        // Extract token and pass it back to your Flutter code
        // You can use a package like uri to parse the URL
        // Then, you can close the WebView or navigate to another page
        if (socialName == "Instagram") {
          final shortLivedCode = url.substring(url.indexOf('?code=') + 6);
          final response = await http.post(
              Uri.parse('https://api.instagram.com/oauth/access_token'),
              body: {
                "client_id": "310597398029950",
                "client_secret": "d46486e58f0526157db23a0473d68d8f",
                "grant_type": "authorization_code",
                "redirect_uri": "https://ego-api-9d0b64be123d.herokuapp.com/",
                "code": "${shortLivedCode}"
              });

          final data1 = jsonDecode(response.body);
          Api.instagramToken = data1['access_token'];
          Api.instagramUserId = data1['user_id'].toString();

          final response2 = await http.get(Uri.parse(
              "https://graph.instagram.com/access_token?grant_type=ig_exchange_token&client_secret=d46486e58f0526157db23a0473d68d8f&access_token=${Api.instagramToken}"));

          final data2 = jsonDecode(response2.body);
          Api.instagramToken = data2['access_token'];
        }
        print(Api.instagramToken);
        flutterWebviewPlugin.close().then((value) => Navigator.pop(context));
      }
    });
    return WebviewScaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('${socialName}'),
      ),
      url:
          'https://api.instagram.com/oauth/authorize?client_id=310597398029950&redirect_uri=https://ego-api-9d0b64be123d.herokuapp.com/&scope=user_profile,user_media&response_type=code',
    );
  }
}
