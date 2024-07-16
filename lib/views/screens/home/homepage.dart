import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recycling_app/views/screens/home/widget/UserImagePicker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('R.Residuos ', style: TextStyle(fontSize: 19)),
            Image.asset('assets/images/logo_huanuco.png', height: 25),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),

                UserImagePicker(),
                SizedBox(
                  height: 40.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text('Residuos Aprovechables'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: Colors.green[100], // Color verde pastel
                          ),
                          SizedBox(width: 10),
                          Text('Residuos Orgánicos Aprovechables'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: Colors.red[100], // Color rojo pastel
                          ),
                          SizedBox(width: 10),
                          Text('Residuos No Aprovechables'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
