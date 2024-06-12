import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recycling_app/constants/app_constants.dart';
import 'package:recycling_app/views/common/exports.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: hieght,
        color: Color(kDarkBlue.value),
        child: Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            Padding(
                padding: EdgeInsets.all(25.0.h),
                child: Image.asset("assets/images/page2.png")),
            const SizedBox(
              height: 40,
            ),
            Column(
              children: [
                Text("Ubica tus Puntos de Reciclaje",
                    textAlign: TextAlign.center,
                    style: appStyle(28, Color(kLight.value), FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                      "Descubre fácilmente los puntos de reciclaje más cercanos a tu ubicación en el mapa integrado y sus horarios de recolección.",
                      textAlign: TextAlign.center,
                      style:
                          appStyle(12, Color(kLight.value), FontWeight.normal)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
