import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../cubits/decode_transaction/decode_transaction_cubit.dart';
import '../repository/decode.repository.dart';

import '../utils/i18n.dart';
import '../widgets/header.dart';
import '../widgets/bar.dart';
import '../widgets/footer.dart';

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

  DecodeRepository _decodeRepo;
  DecodeTransactionCubit _decodeCubit;
  Widget _widget = Container();

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
  void didChangeDependencies() {
    _decodeRepo = Provider.of<DecodeRepository>(context);
    _decodeCubit = DecodeTransactionCubit(_decodeRepo);
    super.didChangeDependencies();
  }

  Widget resultWidget(List<String> result, Size screenSize) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              t('decode_tx'),
              style:
                  Theme.of(context).textTheme.headline3.copyWith(fontSize: 24),
            ),
          ),
          Column(
            children: result
                .map(
                  (e) => Container(
                      margin: EdgeInsets.only(bottom: 16),
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                          color: Color(0xfff5f5f5),
                          border: Border.all(color: Colors.black54, width: 1),
                          borderRadius: BorderRadius.circular(8)),
                      child: SelectableText('$e')),
                )
                .toList(),
          ),
          SizedBox(
            height: 32,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              t('input_new_tx_hex'),
              style:
                  Theme.of(context).textTheme.headline3.copyWith(fontSize: 24),
            ),
          ),
        ],
      ),
    );
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
            BlocBuilder<DecodeTransactionCubit, DecodeTransactionState>(
                cubit: _decodeCubit,
                builder: (context, state) {
                  if (state is Decoded)
                    _widget = resultWidget(state.decodedTx, screenSize);
                  if (state is DecodeTransactionInitial) _widget = Container();
                  return Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          Bar(
                            title: t('decode_a_tx'),
                            screenSize: screenSize,
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          _widget,
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.1),
                            child: Column(
                              children: [
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
                                      _decodeCubit.decode(_txHexCtrl.text);
                                    },
                                    color: Theme.of(context).primaryColor,
                                    child: Text(
                                      t('decode_tx'),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
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
                  );
                }),
          ],
        ),
      ),
    );
  }
}
