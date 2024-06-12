import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recycling_app/views/routes/routes.dart';
import 'package:recycling_app/views/screens/permissions/request_permission_controller.dart';
// Importa la pantalla del mapa

class RequestPermission extends StatefulWidget {
  const RequestPermission({super.key});

  @override
  State<RequestPermission> createState() => _RequestPermissionState();
}

class _RequestPermissionState extends State<RequestPermission>
    with WidgetsBindingObserver {
  final _controller = RequestPermissionController(Permission.locationWhenInUse);
  late StreamSubscription<PermissionStatus> _subscription;
  bool _fromSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = _controller.onStatusChange.listen((status) {
      switch (status) {
        case PermissionStatus.granted:
          goToHome();
          break;

        case PermissionStatus.permanentlyDenied:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                      title: const Text('Location Permission'),
                      content: const Text(
                          'Location Permission is required to use the app'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            _fromSettings = await openAppSettings();
                          },
                          child: const Text('go to settings'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ]));

          break;
          case PermissionStatus.denied:
        break;
        case PermissionStatus.restricted:
          break;
        case PermissionStatus.limited:
          break;
        case PermissionStatus.provisional:
          break;
      }
      // if (status == PermissionStatus.granted) {
      //   Navigator.pushReplacementNamed(context, Routes.locationRoute);
      // }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.request();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.resumed && _fromSettings == true) {
      final status = await _controller.check();
      if (status == PermissionStatus.granted) {
        goToHome();
      }
    }
    _fromSettings = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  void goToHome() {
    Navigator.pushReplacementNamed(context, Routes.mainScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: ElevatedButton(
                    child: const Text('Allow'),
                    onPressed: () {
                      _controller.request();
                    }))));
  }
}
