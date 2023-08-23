import 'package:flutter/cupertino.dart';

class CupertinoListSelectable extends StatelessWidget {
  CupertinoListSelectable({
    Key? key,
    required this.borderRadius,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
    required this.chevron,
  }) : super(key: key);
  final double borderRadius;
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final Function onTap;
  final bool chevron;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius:
          BorderRadius.circular(borderRadius), // Adjust the border radius
      child: Container(
        color: CupertinoColors.white,
        child: CupertinoButton(
          onPressed: () {
            onTap();
          },
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: leading ?? SizedBox(height: 0.0),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  subtitle ?? SizedBox(height: 0.0),
                ],
              ),
              Spacer(),
              chevron
                  ? Icon(CupertinoIcons.chevron_forward)
                  : SizedBox(height: 0.0),
              SizedBox(width: 16.0)
            ],
          ),
        ),
      ),
    );
  }
}
