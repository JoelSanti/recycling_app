import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recycling_app/models/response/auth/auth_model.dart';
import 'package:recycling_app/views/routes/routes.dart';

class SplashController extends ChangeNotifier {
  final Permission _locationPermission;
  final AuthModel _authModel;
  String? _routeName;
  String? get routeName => _routeName;

  SplashController(this._locationPermission, this._authModel);

  Future<void> checkPermission() async {
    final isGranted = await _locationPermission.isGranted;
    if (isGranted) {
      await _authModel.checkAuthenticationStatus();
      final isAuthenticated = _authModel.isAuthenticated;
      _routeName =
          isAuthenticated ? Routes.mainScreenRoute : Routes.onboardingRoute;
    } else {
      _routeName = Routes.permissionRoute;
    }
    notifyListeners();
  }
}
