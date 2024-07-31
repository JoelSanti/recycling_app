import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recycling_app/constants/app_constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


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
    final response = await http.get(Uri.parse('$API_URL/calendars?limit=500'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> recolecciones = jsonData['docs'];

      List<Event> events = [];
      for (var recoleccion in recolecciones) {
        DateTime date = DateTime.parse(recoleccion['fecha']);
        String title = 'Reciclaje';
        String location = 'Ubicación desconocida'; // Actualiza esto si la API proporciona información de ubicación
        String sector = recoleccion['id_sector']['nombre_sector'];
        String startTime = recoleccion['hora_inicio'];
        String endTime = recoleccion['hora_fin'];
        events.add(Event(date, title, location, sector, startTime, endTime));
      }

      return events;
    } else {
      throw Exception('Failed to load events from API');
    }
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Calendario de recolección' , style: TextStyle(fontSize: 19)),
            Image.asset('assets/images/logo_huanuco.png', height: 25),
          ],
        ),
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
                            color: Colors.red,
                            width: 5.0,
                          ),
                          top: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          right: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
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