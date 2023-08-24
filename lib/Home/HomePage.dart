import 'package:ego/Settings/SettingsPage.dart';
import 'package:ego/Bot/BotPage.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [BotPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_3_fill), label: 'Socials'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.gear_alt_fill), label: 'Settings'),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      tabBuilder: (BuildContext context, int index) {
        return _pages[index];
      },
    );
  }
}
