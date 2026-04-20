import 'package:flutter/material.dart';

class DayInfo extends StatelessWidget {
  final DateTime selectedDay;
  final List<dynamic> holidays;

  const DayInfo({
    super.key,
    required this.selectedDay,
    required this.holidays,
  });

  final List<String> weekdays = const ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];

  @override
  Widget build(BuildContext context) {
    String holidayName = '';
    for (var holiday in holidays) {
      final date = DateTime.parse(holiday['startDate']);
      if (date.day == selectedDay.day &&
          date.month == selectedDay.month &&
          date.year == selectedDay.year) {
        holidayName = holiday['name'][0]['text'];
        break;
      }
    }
    String weekdayName = weekdays[selectedDay.weekday - 1];
    return Column(
      children: [
        Text("Ausgewähltes Datum: ${selectedDay.day}.${selectedDay.month}.${selectedDay.year}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 74, 151, 195))),
        Text("Wochentag: $weekdayName",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 35, 116, 163))),
        Text(holidayName.isEmpty ? 'Kein Feiertag' : '🎉 $holidayName',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 169, 108, 197))),
      ],
    );
  }
}

class HistoricalEvents extends StatelessWidget {
  final List<dynamic> events;

  const HistoricalEvents({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Historische Ereignisse",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 74, 151, 195))),
        ...events.take(5).map((event) {
          return Text("${event['year']}: ${event['text']}",
            style: TextStyle(fontSize: 16,
              color: const Color.fromARGB(255, 168, 108, 192)));
        }).toList(),
      ],
    );
  }
}