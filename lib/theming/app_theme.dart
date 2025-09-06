import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  final ThemeData _theme = ThemeData(
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ), // 2
    ),
    primarySwatch: materialMainColor,
    primaryColor: mainColor,
    colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
    useMaterial3: true,
    primaryIconTheme: IconThemeData(color: mainColor),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Roboto-Regular',
  );

  ThemeData get appThemeData => _theme;

  static Color mainColor = const Color(0xff1F2261);
  static Color mainTextColor = Colors.black;
  static Color subTextColor = Color(0xff808080);
  static Color textFieldBackgroundColor = Color(0xffEFEFEF);
  static Color titleTextColor = Color(0xff989898);

  static Map<int, Color> cColor = {
    50: const Color.fromRGBO(31, 34, 97, .1),
    100: const Color.fromRGBO(31, 34, 97, .2),
    200: const Color.fromRGBO(31, 34, 97, .3),
    300: const Color.fromRGBO(31, 34, 97, .4),
    400: const Color.fromRGBO(31, 34, 97, .5),
    500: const Color.fromRGBO(31, 34, 97, .6),
    600: const Color.fromRGBO(31, 34, 97, .7),
    700: const Color.fromRGBO(31, 34, 97, .8),
    800: const Color.fromRGBO(31, 34, 97, .9),
    900: const Color.fromRGBO(31, 34, 97, 1),
  };

  static MaterialColor get materialMainColor =>
      MaterialColor(0xff1F2261, cColor);

  static TextStyle appThinTextStyle = TextStyle(
    fontFamily: 'Roboto-Thin',
    fontSize: 14,
    color: AppTheme.mainTextColor,
  );

  static TextStyle appLightTextStyle = TextStyle(
    fontFamily: 'Roboto-Light',
    fontSize: 14,
    color: AppTheme.mainTextColor,
  );

  static TextStyle appRegularTextStyle = TextStyle(
    fontFamily: 'Roboto-Regular',
    fontSize: 14,
    color: AppTheme.mainTextColor,
  );

  static TextStyle appMediumTextStyle = TextStyle(
    fontFamily: 'Roboto-Medium',
    fontSize: 14,
    color: AppTheme.mainTextColor,
  );

  static TextStyle appSemiBoldTextStyle = TextStyle(
    fontFamily: 'Roboto-SemiBold',
    fontSize: 14,
    color: AppTheme.mainTextColor,
  );

  static TextStyle appBoldTextStyle = TextStyle(
    fontFamily: 'Roboto-Bold',
    fontSize: 14,
    color: AppTheme.mainTextColor,
  );
}