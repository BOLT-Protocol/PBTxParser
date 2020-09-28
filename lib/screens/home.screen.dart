import 'dart:html';

import 'package:flutter/material.dart';

import '../utils/i18n.dart';
import '../widgets/appbar.dart';
import '../themes.dart';
import 'dart:math' as math show pi;

final t = I18n.t;

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _txHexCtrl;

  @override
  void initState() {
    _txHexCtrl = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO REFRESH
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1, vertical: 16),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/ic_launcher.png',
                          width: 50,
                        ),
                        SizedBox(width: 10),
                        Text(
                          t('pocket_bank'),
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              color:
                                  Theme.of(context).textTheme.headline3.color),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Row(
                          children: [
                            Transform.rotate(
                                angle: -math.pi / 4,
                                child: Icon(
                                  Icons.send,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                  size: screenHeight * 0.05,
                                )),
                            Text(
                              t('decode_a_tx'),
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ],
                        ),
                        width: double.infinity,
                        height: 150, //screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            // begin: Alignment.topCenter,
                            // end: Alignment.bottomCenter,
                            begin: const Alignment(0.0, -1.0),
                            end: const Alignment(0.0, 0.6),
                            colors: <Color>[
                              Theme.of(context).accentColor,
                              Theme.of(context).textTheme.overline.color,
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
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
                            Container(
                              child: TextField(
                                controller: _txHexCtrl,
                                minLines: 16,
                                maxLines: 100,
                              ),
                            ),
                            // Container(
                            //   padding: EdgeInsets.symmetric(vertical: 8),
                            //   width: double.infinity,
                            //   child: Text(
                            //     t('network'),
                            //     textAlign: TextAlign.start,
                            //   ),
                            // ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
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
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(color: PBColors.footer_01),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1, vertical: 32),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  //TODO Icon social media
                                  Text(
                                    t('we_r_social'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            color: PBColors.brand_02,
                                            fontWeight: FontWeight.w200),
                                  ),
                                ],
                              ),
                              OutlineButton(
                                hoverColor: PBColors.footer_02,
                                borderSide: BorderSide(
                                  color: PBColors.brand_02,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                onPressed: () {
                                  print('${_txHexCtrl.text}');
                                },
                                child: Row(
                                  children: [
                                    //TODO Icon github
                                    Text(
                                      t('fork_me'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: PBColors.brand_02,
                                            fontWeight: FontWeight.w200,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          t('power_by'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                color: PBColors.brand_02,
                                                fontWeight: FontWeight.w200,
                                              ),
                                        ),
                                        GestureDetector(
                                          child: Text(
                                            t('pb_web_services'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    color: PBColors.brand_02,
                                                    fontWeight: FontWeight.w200,
                                                    decoration: TextDecoration
                                                        .underline),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        t('copyright'),
                                        textAlign: TextAlign.right,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                              color: PBColors.brand_02,
                                              fontWeight: FontWeight.w200,
                                            ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
