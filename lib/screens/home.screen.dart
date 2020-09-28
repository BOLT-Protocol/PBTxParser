import 'package:flutter/material.dart';

import '../utils/i18n.dart';
import '../themes.dart';

final t = I18n.t;

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t('pocket_bank'),
        ),
      ),
      body: Container(),
    );
  }
}
