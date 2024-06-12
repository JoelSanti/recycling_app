import 'package:flutter/material.dart';
import 'package:recycling_app/views/routes/routes.dart';
import 'package:recycling_app/views/screens/home/homepage.dart';
import 'package:recycling_app/views/screens/mainscreen.dart';
import 'package:recycling_app/views/screens/map/recycling_points.dart';
import 'package:recycling_app/views/screens/onboarding/onboarding_screen.dart';
import 'package:recycling_app/views/screens/permissions/request_permission.dart';
import 'package:recycling_app/views/screens/splash/splash_page.dart';

Map<String, Widget Function(BuildContext)> appRoutes() {
  return {
    Routes.splashRoute: (context) => const SplashPage(),
    Routes.permissionRoute: (context) => const RequestPermission(),
    Routes.mainScreenRoute: (context) => const Mainscreen(),
    Routes.recognitionRoute: (context) => const HomePage(),
    Routes.locationRoute: (context) => const RecyclingPoints(),
    Routes.onboardingRoute: (context) => const OnboardingScreen(),
  };
}
