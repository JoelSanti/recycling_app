import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

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
  int _selectedSector = 1;
  late Future<List<dynamic>> _sectorsFuture;
  List<dynamic> _sectors = [];

  @override
  void initState() {
    super.initState();
    _sectorsFuture = loadSectors();
    _notifications = generateNotifications();
  }

  Future<List<dynamic>> loadSectors() async {
    String jsonString = await rootBundle.loadString('assets/data/my_data_points_calendary.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    _sectors = jsonData['Sectores'];
    return _sectors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                    return DropdownButton<int>(
                      isExpanded: true,
                      value: _selectedSector,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedSector = newValue!;
                          _notifications = generateNotifications();
                        });
                      },
                      items: snapshot.data!.map<DropdownMenuItem<int>>((sector) {
                        return DropdownMenuItem<int>(
                          value: sector['id_sector'],
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
                          trailing: Text(formatDateTime(snapshot.data![index].date)),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<NotificationItem>> generateNotifications() async {
    String jsonString = await rootBundle.loadString('assets/data/my_data_points_calendary.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    List<NotificationItem> notifications = [];

    for (var recoleccion in jsonData['Calendario_Recoleccion']) {
      if (recoleccion['id_sector'] == _selectedSector) {
        DateTime date = DateTime.parse(recoleccion['fecha']);
        var now = DateTime.now();
        var difference = now.difference(date);

        if (difference.inDays.abs() <= _daysBefore) {
          // Get the sector name from the _sectors list
          var sector = _sectors.firstWhere((sector) => sector['id_sector'] == _selectedSector);
          String sectorName = sector['nombre_sector'];

          String title = 'Recolección en Sector $sectorName';
          // Parse the original date string to a DateTime object
          DateTime parsedDate = DateTime.parse(recoleccion['fecha']);

// Create a new DateFormat for the desired format (day, month, year)
          DateFormat newFormat = DateFormat('dd/MM/yyyy');

// Use the new DateFormat to format the parsed date
          String formattedDate = newFormat.format(parsedDate);

          String description = 'La recolección será el $formattedDate de ${recoleccion['hora_inicio']} a ${recoleccion['hora_fin']}';

          notifications.add(NotificationItem(title: title, description: description, date: date));
        }
      }
    }

    return notifications;
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