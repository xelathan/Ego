// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

class CupertinoMenu extends StatelessWidget {
  const CupertinoMenu({
    super.key,
    required this.child,
    this.leading,
    this.trailing,
    this.color,
    this.iconColor,
    this.onTap,
    this.textColor,
    this.items,
    this.offset,
  });

  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final Color? color;
  final Color? iconColor;
  final Function()? onTap;

  final Color? textColor;
  final List<PullDownMenuEntry>? items;
  final Offset? offset;

  @override
  Widget build(BuildContext context) {
    void showButtonMenu() {
      Offset _offset = offset ?? Offset.zero;

      final RenderBox button = context.findRenderObject() as RenderBox;
      final RenderBox overlay = Navigator.of(context, rootNavigator: true)
          .overlay
          ?.context
          .findRenderObject()! as RenderBox;
      final Rect position = Rect.fromPoints(
        button.localToGlobal(_offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + _offset,
            ancestor: overlay),
      );
      showPullDownMenu(
        context: Navigator.of(context, rootNavigator: true).context,
        position: position,
        items: items ?? [],
      );
    }

    return MaterialButton(
      color: color ?? Colors.transparent,
      elevation: 0,
      height: kMinInteractiveDimension,
      highlightColor: Colors.transparent,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minWidth: kMinInteractiveDimension,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16.0,
        ),
      ),
      highlightElevation: 0,
      splashColor: Colors.transparent,
      visualDensity: VisualDensity.compact,
      onLongPress: onTap ?? showButtonMenu,
      onPressed: onTap ?? showButtonMenu,
      child: IconTheme(
        data: IconThemeData(
            color: iconColor ?? CupertinoColors.activeBlue, size: 24),
        child: DefaultTextStyle(
          style: TextStyle(
              color: textColor ?? CupertinoColors.black,
              fontSize: 16,
              inherit: false),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              leading ?? const SizedBox(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: child,
              ),
              trailing ?? const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
