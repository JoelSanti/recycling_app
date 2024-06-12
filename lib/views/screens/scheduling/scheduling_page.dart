import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'package:flutter/services.dart';

class Event {
  final DateTime date;
  final String title;
  final String location;
  final String sector;
  final String startTime;
  final String endTime;

  Event(this.date, this.title, this.location, this.sector, this.startTime, this.endTime);
}
class EventMarker {
  final Event event;
  final Color color;

  EventMarker(this.event, this.color);
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class SchedulingPage extends StatefulWidget {
  const SchedulingPage({Key? key}) : super(key: key);

  @override
  State<SchedulingPage> createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Event> _events = [];

  Map<DateTime, List<Event>> _eventsMap = {};

  final _sectorColors = {
    'Sector 1': Colors.red,
    'Sector 2': Colors.green,
    // Añade más sectores y colores aquí...
  };

  List<DateTime> _markedDays = [];

  Future<List<Event>> loadEvents() async {
    String jsonString = await rootBundle.loadString('assets/data/my_data_points_calendary.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    List<Event> events = [];
    for (var recoleccion in jsonData['Calendario_Recoleccion']) {
      DateTime date = DateTime.parse(recoleccion['fecha']);
      String title = 'Reciclaje';
      String location = jsonData['Puntos_Reciclaje'].firstWhere((punto) => punto['id_punto'] == recoleccion['id_sector'])['nombre_punto'];
      String sector = jsonData['Sectores'].firstWhere((sector) => sector['id_sector'] == recoleccion['id_sector'])['nombre_sector'];
      String startTime = recoleccion['hora_inicio'] ?? 'No se proporcionó la hora de inicio';
      String endTime = recoleccion['hora_fin'] ?? 'No se proporcionó la hora de finalización';
      events.add(Event(date, title, location, sector, startTime, endTime));
    }

    return events;
  }

  @override
  void initState() {
    super.initState();
    loadEvents().then((loadedEvents) {
      setState(() {
        _events = loadedEvents;
        _eventsMap = _events.fold<LinkedHashMap<DateTime, List<Event>>>(
          LinkedHashMap<DateTime, List<Event>>(
            equals: isSameDay,
            hashCode: getHashCode,
          ),
              (map, event) {
            map.putIfAbsent(event.date, () => []).add(event);
            return map;
          },
        );
        _markedDays = _eventsMap.keys.toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de recolección'),
      ),
      body: Center(
        child: Column(
          children: [
            TableCalendar<EventMarker>(
              locale: Localizations.localeOf(context).toLanguageTag(),
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: (day) {
                return _eventsMap[day]?.map((event) => EventMarker(event, _sectorColors[event.sector ?? 'No sector'] ?? Colors.transparent))?.toList() ?? [];
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _markedDays.length,
                itemBuilder: (context, index) {
                  final day = _markedDays[index];
                  final events = _eventsMap[day];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Colors.red, // Cambia esto al color que quieras para el borde izquierdo
                            width: 5.0, // Cambia esto al ancho que quieras para el borde izquierdo
                          ),
                          top: BorderSide(
                            color: Colors.grey, // Cambia esto al color que quieras para el resto de los bordes
                            width: 1.0, // Cambia esto al ancho que quieras para el resto de los bordes
                          ),
                          right: BorderSide(
                            color: Colors.grey, // Cambia esto al color que quieras para el resto de los bordes
                            width: 1.0, // Cambia esto al ancho que quieras para el resto de los bordes
                          ),
                          bottom: BorderSide(
                            color: Colors.grey, // Cambia esto al color que quieras para el resto de los bordes
                            width: 1.0, // Cambia esto al ancho que quieras para el resto de los bordes
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text('${day.day}/${day.month}/${day.year} '),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: events?.map((event) => Text('Sector: ${event.sector} \nHora de inicio: ${event.startTime} \nHora de finalización: ${event.endTime}'))?.toList() ?? [],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}