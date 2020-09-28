import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'utils/i18n.dart';
import 'cubits/delegate.dart';
import 'themes.dart';
import 'widgets/top_layer.dart';
import 'cubits/notification/notification_cubit.dart';

import 'screens/home.screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /** BLOC migrattion 4.0.1 => 6.0.3 */
  // BlocSupervisor.delegate = PBDelegate();
  Bloc.observer = PBObserver();

  runApp(PBTxParser());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class PBTxParser extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
        // MultiProvider(
        //   providers: [],
        //   child:
        MultiBlocProvider(
      providers: [
        BlocProvider<NotificationCubit>(
          create: (BuildContext context) => NotificationCubit(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          builder: (context, widget) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: Stack(
              children: <Widget>[
                widget,
                TopLayer(),
              ],
            ),
          ),
          // title: I18n.t('pocket_band'), // Can not use translation in MaterialApp before i18n loaded
          title: 'Pocket Bank',
          theme: pbThemeData,
          // TODO: update myDarkThemeData style
          // darkTheme: myDarkThemeData,
          // home: HomePage(title: I18n.t('login')),
          routes: {
            '/': (context) => HomeScreen(),
            HomeScreen.routeName: (context) => HomeScreen(),
          },

          localizationsDelegates: [
            const I18nDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('ja', 'JP'),
          ],
          localeListResolutionCallback: (deviceLocales, supportedLocales) {
            Locale locale = supportedLocales.toList()[0];
            for (Locale deviceLocale in deviceLocales) {
              if (I18nDelegate().isSupported(deviceLocale)) {
                locale = deviceLocale;
                break;
              }
            }
            Intl.defaultLocale = locale.languageCode;
            return locale;
          },
        ),
        // ),
      ),
    );
  }
}
