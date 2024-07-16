import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:recycling_app/controllers/map_provider.dart';

import 'package:recycling_app/controllers/onboarding_provider.dart';

import 'package:recycling_app/controllers/zoom_provider.dart';
import 'package:recycling_app/views/routes/pages.dart';
import 'package:recycling_app/views/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';

//TODO: Hook the app to firebase using firebase cli
void main() async {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => OnBoardNotifier()),
    ChangeNotifierProvider(create: (context) => ZoomNotifier()),
    ChangeNotifierProvider(create: (context) => MapNotifier()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const[
               Locale('es', ''), // Español
            ],
            debugShowCheckedModeBanner: false,
            title: 'EcoHuánuco',
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.green,
            ),
            initialRoute: Routes.splashRoute,
            routes: appRoutes(),
          );
        });
  }
}
