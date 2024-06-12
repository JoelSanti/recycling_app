import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recycling_app/constants/app_constants.dart';
import 'package:recycling_app/views/common/exports.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: hieght,
        color: Color(kDarkPurple.value),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Image.asset("assets/images/page1.png"),
            const SizedBox(
              height: 40,
            ),
            Column(
              children: [
                Text("Clasifica tus Residuos con una Foto",
                    textAlign: TextAlign.center,
                    style: appStyle(28, Color(kLight.value), FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                      "Sube una fotografía de tus residuos y nuestra aplicación los reconocerá y clasificará automáticamente para un reciclaje adecuado.",
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
