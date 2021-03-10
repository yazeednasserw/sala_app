import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Helpers/Di/get_it.dart';
import 'Helpers/Routes/routeGenerator.dart';
import 'Helpers/LanguageLocalization/app_localizations.dart';
import 'Helpers/responsiveness/responsiveness.dart';

//only for dev - to shoe the screen whe app starts pass the route name
// assign null if not needed
// String devFirstRoute = "complaint";
String devFirstRoute;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  configureDependencies();
  runApp(DeviceWrapper());
}

class DeviceWrapper extends StatelessWidget {
  const DeviceWrapper({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  // screen Size
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Future initState() {
    super.initState();
  }

  Locale _locale;

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive.instance.init(
      mediaQueryData: MediaQuery.of(context),
      width: 375.0,
      height: 812.0,
      allowFontAccesibility: false,
      useSafeArea: false,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,

      title: 'one8',
      theme: ThemeData(
// Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Color(0xff14138C),
        accentColor: Color(0xff7368FB),

        appBarTheme: AppBarTheme(color: Color(0xff09163A), iconTheme: IconThemeData(color: Colors.white)),
// Define the default font family.
        fontFamily: 'Cairo',

// Define the default TextTheme. Use this to specify the default
// text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 52.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'ara-hamah-alfidaa',
          ),
          headline2: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold, fontFamily: 'ara-hamah-alfidaa'),
          headline3: TextStyle(
              fontSize: 35.0, fontWeight: FontWeight.bold, fontFamily: 'ara-hamah-alfidaa', color: Colors.white),
          headline4: TextStyle(
              fontSize: 28.0, fontWeight: FontWeight.bold, fontFamily: 'ara-hamah-alfidaa', color: Color(0xffA4B1C0)),
          bodyText1: TextStyle(
            fontSize: 14.0,
          ),
        ),
      ),

      // List all of the app's supported locales here
      supportedLocales: [
        Locale('ar', ''),
        Locale('en', ''),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // location_picker.S.delegate,
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (locale != null &&
              locale.languageCode != null &&
              locale.countryCode != null &&
              supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
//          if (supportedLocale.languageCode == locale.languageCode &&
//              supportedLocale.countryCode == locale.countryCode) {
//            return supportedLocale;
//          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },

      initialRoute: devFirstRoute != null ? devFirstRoute : '/',
      onGenerateRoute: routeGenerator.generateRoute,
    );
  }
}
