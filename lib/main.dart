import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarApp(),
    );
  }
}

class CalendarApp extends StatefulWidget {
  const CalendarApp({super.key});

  @override
  State<CalendarApp> createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {
  DateTime _displayedMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<dynamic> _holidays = []; // kommt später

    @override
    void initState() {
      super.initState();
      _loadHolidays();//
    }

Future<void> _loadHolidays() async {
  final year = _displayedMonth.year;
  final url = Uri.parse(
    'https://openholidaysapi.org/PublicHolidays'
    '?countryIsoCode=DE'
    '&languageIsoCode=DE'
    '&validFrom=$year-01-01'
    '&validTo=$year-12-31'
  );

  final response = await http.get(url);  // ← das hatte gefehlt!

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    setState(() {
      _holidays = data;
    });
  }
}  

  final List<String> weekdays = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];
  
  Widget _buildDayInfo() {
    
    String weekdayName = weekdays[_selectedDay.weekday - 1];
    return Column(
      children: [
        Text("Ausgewähltes Datum: ${_selectedDay.day}.${_selectedDay.month}.${_selectedDay.year}"),
        Text("Wochentag: $weekdayName"),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
            });
          },
        ),
        Text("${_displayedMonth.year} - ${_displayedMonth.month.toString().padLeft(2, '0')}"),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            setState(() {
              _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
            });
          },
        ),
      ],
    );
  }


  Widget _buildCalendar() {
    int firstWeekday = DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday - 1;
    int daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;

    List<Widget> cells = [];
    for (int i = 0; i < 42; i++) {
      int dayNumber = i - firstWeekday + 1;

      if (i < firstWeekday || dayNumber > daysInMonth) {
        cells.add(Container());
      } else {
        DateTime cellDate = DateTime(_displayedMonth.year, _displayedMonth.month, dayNumber);
        bool isToday = cellDate.day == DateTime.now().day &&
                       cellDate.month == DateTime.now().month &&
                       cellDate.year == DateTime.now().year;
        bool isSaturday = cellDate.weekday == 6;
        bool isSunday = cellDate.weekday == 7;

        Color backgroundColor;
        if (isToday) {
          backgroundColor = const Color.fromARGB(255, 160, 127, 154);
        } else if (isSaturday) {
          backgroundColor = const Color.fromARGB(255, 209, 88, 203);
        } else if (isSunday) {
          backgroundColor = const Color.fromARGB(255, 132, 38, 187);
        } else {
          backgroundColor = Colors.white;
        }

        cells.add(
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = cellDate;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(100),),
                child: Center(
                child: Text(dayNumber.toString())),
            ),
          ),
        );
      }
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: cells,
    );
  }

  Widget _buildInfoBox() {
    return Container(); // kommt später
  }

  Widget _buildHistoricalEvents() {
    return Container(); // kommt später
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDayInfo(),
            _buildCalendarHeader(),
            _buildCalendar(),
            _buildInfoBox(),
            _buildHistoricalEvents(),
          ],
        ),
      ),
    );
  }
}