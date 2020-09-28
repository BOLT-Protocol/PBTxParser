import 'package:PBTxParser/screens/home.screen.dart';

import '../themes.dart';
import 'package:flutter/material.dart';

class GeneralAppbar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final String routeName;
  final Function leadingFunc;
  final Map actions;

  // For Appbar actions
  final bool disable;

  GeneralAppbar(
      {this.title: '',
      this.routeName,
      this.leadingFunc,
      this.actions,
      this.disable: false});

  @override
  Widget build(BuildContext context) {
    Widget genLeading(String routeName) {
      Widget leading = SizedBox();
      switch (routeName) {
        case HomeScreen.routeName:
          leading = GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Image.asset('assets/images/ic_launcher.png'),
            onTap: leadingFunc ??
                () {
                  Navigator.of(context).pop();
                },
          );
          break;
        default:
      }

      return leading;
    }

    Widget actionItem(Widget content, Function func) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(child: content),
        ),
        onTap: func,
      );
    }

    List<Widget> genActions(String routeName) {
      List<Widget> _actions = [];

      switch (routeName) {
        case HomeScreen.routeName:
          _actions = actions.entries.map((MapEntry entry) {
            return actionItem(
                Icon(
                  entry.key == 'hide' ? Icons.visibility_off : Icons.info,
                  color: PBColors.text_01,
                  size: 28,
                ),
                entry.value);
          }).toList();
          break;
      }

      return _actions;
    }

    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Theme.of(context).accentColor,
      leading: genLeading(routeName),
      actions: genActions(routeName),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
