import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:recycling_app/constants/app_constants.dart';

class NotificationItem {
  NotificationItem({
    required this.title,
    required this.description,
    required this.date,
  });

  String title;
  String description;
  DateTime date;
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationItem>> _notifications;
  int _daysBefore = 3;
  String _selectedSector = '';
  late Future<List<dynamic>> _sectorsFuture;
  List<dynamic> _sectors = [];

  @override
  void initState() {
    super.initState();
    _sectorsFuture = loadSectors();
    _notifications = generateNotifications();
  }

  Future<List<dynamic>> loadSectors() async {
    final response = await http
        .get(Uri.parse('$API_URL/sectors?limit=500'));
    print("Response: ${response.body}");
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      _sectors = jsonData['docs'];
      if (_sectors.isNotEmpty) {
        _selectedSector = _sectors[0]
            ['id']; // Set _selectedSector to the id of the first sector
      }
      return _sectors;
    } else {
      throw Exception('Failed to load sectors from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Notificaciones', style: TextStyle(fontSize: 19)),
            Image.asset('assets/images/logo_huanuco.png', height: 25),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _daysBefore = int.parse(value);
                  _notifications = generateNotifications();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Cuantos días antes debería de informar:',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FutureBuilder<List<dynamic>>(
              future: _sectorsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedSector,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSector = newValue!;
                          _notifications = generateNotifications();
                        });
                      },
                      items: snapshot.data!
                          .map<DropdownMenuItem<String>>((sector) {
                        return DropdownMenuItem<String>(
                          value: sector['id'],
                          child: Text('Sector ${sector['nombre_sector']}'),
                        );
                      }).toList(),
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<NotificationItem>>(
              future: _notifications,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data![index].title),
                          subtitle: Text(snapshot.data![index].description),
                          trailing:
                              Text(formatDateTime(snapshot.data![index].date)),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<NotificationItem>> generateNotifications() async {
    final response = await http.get(Uri.parse('$API_URL/calendars?limit=500'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> recolecciones = jsonData['docs'];

      List<NotificationItem> notifications = [];

      for (var recoleccion in recolecciones) {
        if (recoleccion['id_sector']['id'] == _selectedSector) {
          DateTime date = DateTime.parse(recoleccion['fecha']);
          var now = DateTime.now();
          var difference = now.difference(date);

          if (difference.inDays.abs() <= _daysBefore) {
            String sectorName = recoleccion['id_sector']['nombre_sector'];

            String title = 'Recolección en el Sector $sectorName';
            DateTime parsedDate = DateTime.parse(recoleccion['fecha']);
            DateFormat newFormat = DateFormat('dd/MM/yyyy');
            String formattedDate = newFormat.format(parsedDate);

            String description = 'La recolección será el $formattedDate de ${recoleccion['hora_inicio']} a ${recoleccion['hora_fin']}';

            notifications.add(NotificationItem(title: title, description: description, date: date));
          }
        }
      }

      return notifications;
    } else {
      throw Exception('Failed to load notifications from API');
    }
  }

  String formatDateTime(DateTime dt) {
    var now = DateTime.now();
    var difference = now.difference(dt);

    if (difference.inDays.abs() < 30) {
      return "${difference.inDays.abs()} días";
    } else {
      return "${dt.day}/${dt.month}/${dt.year}";
    }
  }
}
