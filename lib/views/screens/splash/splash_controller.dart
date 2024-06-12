import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recycling_app/views/routes/routes.dart';

class SplashController extends ChangeNotifier {
  final Permission _locationPermission;
  String? _routeName;
  String? get routeName => _routeName;

  SplashController(this._locationPermission);

  Future<void> checkPermission() async {
    final isGRanted = await _locationPermission.isGranted;
    _routeName = isGRanted ? Routes.onboardingRoute : Routes.permissionRoute;
    notifyListeners();
  }
}
