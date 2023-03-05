

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register/src/ui/editUserScreen.dart';
import 'package:flutter_login_register/src/ui/homeScreen.dart';
import 'package:flutter_login_register/src/ui/splashScreen.dart';
import 'package:flutter_login_register/src/ui/startScreen.dart';

class Routes {
  static const splash = '/';
  static const intro = '/intro';
  static const home = '/home';
  static const editUser = '/editUser';

  static Route routes(RouteSettings settings) {

    // Helper nested function.
    MaterialPageRoute buildRoute(Widget widget) {
      return MaterialPageRoute(builder: (_) => widget, settings: settings);
    }

    switch (settings.name) {
      case splash:
        return buildRoute(const SplashScreen());
      case intro:
        return buildRoute(const StartScreen());
      case home:
        return buildRoute(const HomeScreen());
      case editUser:
        return buildRoute(const EditMyUserScreen());
      default:
        throw Exception('Route does not exists');
    }
  }
}