import 'package:frdemo/view/attendance.dart';
import 'package:frdemo/view/dashboard.dart';
import 'package:frdemo/routes/app_routes.dart';

import 'package:frdemo/view/registrationLive.dart';
import 'package:frdemo/view/splash.dart';
import 'package:flutter/material.dart';

class AppPages {
  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.registration: (context) => UpdateProfileScreen(),
      AppRoutes.splash: (context) => SplashSCreen(),
      AppRoutes.attendance: (context) => Attendance(),
      AppRoutes.dashboard: (context) => DashboardScreen(),
    };
  }
}
