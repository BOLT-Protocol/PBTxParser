import 'package:flutter/material.dart';

import '../utils/i18n.dart';
import '../widgets/header.dart';
import '../widgets/bar.dart';
import '../widgets/footer.dart';
import '../widgets/web_scrollbar.dart';

final t = I18n.t;

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _txHexCtrl;
  ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _txHexCtrl = TextEditingController();
    // https://blog.codemagic.io/flutter-web-getting-started-with-responsive-design/
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              title: t('pocket_bank'),
              screenSize: screenSize,
              scrollPosition: _scrollPosition,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Bar(
                      title: t('decode_a_tx'),
                      screenHeight: screenSize.height,
                      screenWidth: screenSize.width,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.1),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 32,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            width: double.infinity,
                            child: Text(
                              t('tx_hex'),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                width: 1,
                              ))),
                              controller: _txHexCtrl,
                              minLines: screenSize.height ~/ 50,
                              maxLines: 1000,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 50),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              elevation: 0.0,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              onPressed: () {
                                print('${_txHexCtrl.text}');
                              },
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                t('decode_tx'),
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Footer(
                      screenSize: screenSize,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
