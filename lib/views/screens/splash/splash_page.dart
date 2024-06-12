import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recycling_app/views/screens/splash/splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _controller = SplashController(Permission.locationWhenInUse);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.checkPermission();
    });

    _controller.addListener(() {
      if (_controller.routeName != null) {
        Navigator.pushReplacementNamed(context, _controller.routeName!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
