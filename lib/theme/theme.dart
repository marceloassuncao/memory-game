import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? true;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemeProvider() {
    this.init();
  }

  Future<void> init() async {
    darkTheme = await darkThemePreference.getTheme();
  }

  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = true;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    // if (isDarkTheme) return ThemeData.dark();
    return ThemeData(
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      primarySwatch: Colors.blue,
      fontFamily: 'Lato',
      scaffoldBackgroundColor: isDarkTheme
          ? ThemeData.dark().scaffoldBackgroundColor
          : Colors.grey[200],
    );
    // return ThemeData(
    //   primarySwatch: Colors.blue,
    //   fontFamily: 'Lato',
    //   scaffoldBackgroundColor: Colors.grey[200],
    //   primaryColor: isDarkTheme ? Colors.black : Colors.white,
    //   backgroundColor: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
    //   indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
    //   buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
    //   hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
    //   highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
    //   hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
    //   focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
    //   disabledColor: Colors.grey,
    //   textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
    //   cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
    //   canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
    //   brightness: isDarkTheme ? Brightness.dark : Brightness.light,
    //   buttonTheme: Theme.of(context).buttonTheme.copyWith(
    //       colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
    //   appBarTheme: AppBarTheme(
    //     elevation: 0.0,
    //   ),
    // );
  }
}

class SlideAnimationPage extends MaterialPage {
  final bool slideHorizontal;
  final Widget child;

  SlideAnimationPage(
      {Key key, @required this.child, this.slideHorizontal = true})
      : super(key: key, child: child);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, anotherAnimation, child) {
        animation =
            CurvedAnimation(curve: Curves.fastOutSlowIn, parent: animation);
        Tween<Offset> position = slideHorizontal
            ? Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
            : Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0));
        return SlideTransition(
          position: position.animate(animation),
          child: child,
        );
      },
    );
  }
}
