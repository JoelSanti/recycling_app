import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:recycling_app/views/common/custom_outline_btn.dart';

import 'package:recycling_app/views/common/exports.dart';
import 'package:recycling_app/views/routes/routes.dart';



class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: hieght,
        color: Color(kLightBlue.value),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Image.asset("assets/images/page3.png"),
            const SizedBox(
              height: 30,
            ),
            Text("Contribuye al Planeta",
                textAlign: TextAlign.center,
                style: appStyle(28, Color(kLight.value), FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(8.0.h),
              child: Text(
                  'Únete al movimiento de reciclaje responsable y ayuda a reducir la contaminación mediante la correcta separación de tus residuos.',
                  textAlign: TextAlign.center,
                  style: appStyle(12, Color(kLight.value), FontWeight.normal)),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomOutlineBtn(
                onTap: () {
                  Get.toNamed(Routes.mainScreenRoute);
                },
                hieght: hieght * 0.05,
                width: width * 0.8,
                text: 'Continuar',
                color: Color(kLight.value)),
          ],
        ),
      ),
    );
  }
}
