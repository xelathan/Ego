import 'package:ego/Custom_Widgets/CupertinoListSelectable.dart';
import 'package:ego/Settings/SettingsController.dart';
import 'package:flutter/cupertino.dart';

SettingsController _controller = SettingsController();

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Settings'),
        ),
        child: SafeArea(
            child: CupertinoFormSection.insetGrouped(
          margin: EdgeInsets.all(16.0),
          children: [
            CupertinoListSelectable(
              leading: const Icon(CupertinoIcons.person_crop_circle),
              chevron: true,
              borderRadius: 16.0,
              title: const Text('Account'),
              onTap: () {
                //_controller.signOut(context);
              },
            ),
            CupertinoListSelectable(
              leading: const Icon(
                CupertinoIcons.arrow_right_square,
                color: CupertinoColors.destructiveRed,
              ),
              chevron: false,
              borderRadius: 16.0,
              title: const Text(
                'Sign out',
                style: TextStyle(color: CupertinoColors.destructiveRed),
              ),
              onTap: () {
                _controller.signOut(context);
              },
            ),
          ],
        )));
  }
}
