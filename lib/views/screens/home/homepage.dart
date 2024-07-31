import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:recycling_app/models/response/auth/auth_model.dart';
import 'package:recycling_app/views/routes/routes.dart';
import 'package:recycling_app/views/screens/home/widget/PieChart.dart';
import 'package:recycling_app/views/screens/home/widget/UserImagePicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:recycling_app/views/screens/home/widget/WeeklyFrequency.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final role = Provider.of<AuthModel>(context).role;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(role == 'admin' ? 'Estadísticas de capturas' : 'R.Residuos', style: TextStyle(fontSize: 19)),
            ElevatedButton(
              onPressed: () {
                // Call the logout method from AuthModel
                Provider.of<AuthModel>(context, listen: false).logout();
                // Then navigate to the login page
                Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
              },
              child: const Text('Salir'),
            ),
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
                  height: 5.h,
                ),
                if (role == 'resident') ...[
                UserImagePicker(),
                SizedBox(
                  height: 20.h,
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
                          const SizedBox(width: 10),
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
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Alinea los botones horizontalmente y distribuye el espacio de manera uniforme
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  showStatisticDialog(context);
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/statistic.svg',
                                  width: 40.0,
                                  height: 40.0,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  showWeeklyFrequencyDialog(context);
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/statistic-chart.svg',
                                  width: 30.0,
                                  height: 30.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ] else if (role == 'admin') ...[
                  FutureBuilder(
                    future: fetchScansAdmin(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (snapshot.data != null) {
                          Map<String, dynamic> data = snapshot.data!;
                          return Column(
                            children: [
                              SizedBox(height: 10),
                              Text('Comparación de tipos de residuos',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 400, // Ajusta este valor según tus necesidades
                                height: 360, // Ajusta este valor según tus necesidades
                                child: buildPieChart(data['counts']),
                              ),

                              Text('Frecuencia semanal de escaneos', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Container(
                                width: 200, // Ajusta este valor según tus necesidades
                                height: 200, // Ajusta este valor según tus necesidades
                                child: buildWeeklyFrequency(data['dailyCounts']),
                              ),
                            ],
                          );
                        } else {
                          return Text('Error: Data is null');
                        }
                      }
                    },
                  ),

              ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//AQUI SE TRAEN LOS DATOS DE LOS SCANEOS DEL USUARIO NO ADMIN
Future<Map<String, dynamic>> fetchScans(BuildContext context) async {
  final authModel = Provider.of<AuthModel>(context, listen: false);
  final url = 'https://servidor-recycling-s4lb.onrender.com/api/scans?limit=500';

  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Authorization': 'JWT ${authModel.token}',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> allScans = data['docs'];
    List<dynamic> userScans = allScans
        .where((scan) => scan['resident']['id'] == authModel.userId)
        .toList();

    Map<String, int> counts = {
      'residuos_aprovechables': 0,
      'residuos_organicos_aprovechables': 0,
      'residuos_no_aprovechables': 0,
    };

    Map<String, int> dailyCounts = {
      'Monday': 0,
      'Tuesday': 0,
      'Wednesday': 0,
      'Thursday': 0,
      'Friday': 0,
      'Saturday': 0,
      'Sunday': 0,
    };

    DateTime now = DateTime.now();
    DateTime startOfWeek =
        DateTime(now.year, now.month, now.day - now.weekday + 1);

    for (var scan in userScans) {
      String wasteType = scan['wasteType'];
      if (counts.containsKey(wasteType)) {
        counts[wasteType] = (counts[wasteType] ?? 0) + 1;
      }

      DateTime scanDate = DateTime.parse(scan['scanDate']);
      if (scanDate.isAfter(startOfWeek)) {
        String weekday = DateFormat('EEEE').format(scanDate);
        if (dailyCounts.containsKey(weekday)) {
          dailyCounts[weekday] = (dailyCounts[weekday] ?? 0) + 1;
        }
      }
    }

    print('Conteo de tipos de residuos: -------------------------------------------------- $counts');
    print('Conteo de escaneos por día de la semana: ------------------------------------------- $dailyCounts');

    return {'counts': counts, 'dailyCounts': dailyCounts};
  } else {
    throw Exception('Error al obtener los datos de los escaneos');
  }
}
// AQUI SE OBTIENEN LOS DATOS DEL ADMIN

Future<Map<String, dynamic>> fetchScansAdmin(BuildContext context) async {
  final authModel = Provider.of<AuthModel>(context, listen: false);
  final url = 'https://servidor-recycling-s4lb.onrender.com/api/scans?limit=500';

  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Authorization': 'JWT ${authModel.token}',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> allScans = data['docs'];

    Map<String, int> counts = {
      'residuos_aprovechables': 0,
      'residuos_organicos_aprovechables': 0,
      'residuos_no_aprovechables': 0,
    };

    Map<String, int> dailyCounts = {
      'Monday': 0,
      'Tuesday': 0,
      'Wednesday': 0,
      'Thursday': 0,
      'Friday': 0,
      'Saturday': 0,
      'Sunday': 0,
    };

    DateTime now = DateTime.now();
    DateTime startOfWeek =
    DateTime(now.year, now.month, now.day - now.weekday + 1);

    for (var scan in allScans) {
      String wasteType = scan['wasteType'];
      if (counts.containsKey(wasteType)) {
        counts[wasteType] = (counts[wasteType] ?? 0) + 1;
      }

      DateTime scanDate = DateTime.parse(scan['scanDate']);
      if (scanDate.isAfter(startOfWeek)) {
        String weekday = DateFormat('EEEE').format(scanDate);
        if (dailyCounts.containsKey(weekday)) {
          dailyCounts[weekday] = (dailyCounts[weekday] ?? 0) + 1;
        }
      }
    }

    print('Conteo de tipos de residuos: -------------------------------------------------- $counts');
    print('Conteo de escaneos por día de la semana: ------------------------------------------- $dailyCounts');

    return {'counts': counts, 'dailyCounts': dailyCounts};
  } else {
    throw Exception('Error al obtener los datos de los escaneos');
  }
}

//AQUI SE MUESTRA LA DONA ESTADÍSTICA

void showStatisticDialog(BuildContext context) async {
  try {
    Map<String, dynamic> data = await fetchScans(context);
    Map<String, int> counts = data['counts'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width *
                1, // Ajusta este valor según tus necesidades
            height: MediaQuery.of(context).size.height *
                0.7, // Ajusta este valor según tus necesidades

            child: AlertDialog(
              title: Text('Estadísticas'),
              content: buildPieChart(counts),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  } catch (e) {
    print('Error al obtener los datos de los escaneos: $e');
  }
}

// AQUI SE MUESTRA LA FRECUENCIA SEMANAL
void showWeeklyFrequencyDialog(BuildContext context) async {
  try {
    Map<String, dynamic> data = await fetchScans(context);
    Map<String, int> dailyCounts = data['dailyCounts'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // Adjust this value as needed
            height: MediaQuery.of(context).size.height * 0.6, // Adjust this value as needed
            child: AlertDialog(
              title: Text('Frecuencia Semanal'),
              content: buildWeeklyFrequency(dailyCounts),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  } catch (e) {
    print('Error al obtener los datos de los escaneos: $e');
  }
}
