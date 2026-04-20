import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'calendar_header.dart';
import 'calendar_grid.dart';
import 'historical_events.dart';

class CalendarApp extends StatefulWidget {
  const CalendarApp({super.key});

  @override
  State<CalendarApp> createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {
  DateTime _displayedMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<dynamic> _holidays = [];
  List<dynamic> _historicalEvents = [];

  @override
  void initState() {
    super.initState();
    _loadHolidays();
    _loadHistoricalEvents();
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
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _holidays = data;
      });
    }
  }

  Future<void> _loadHistoricalEvents() async {
    final month = _selectedDay.month;
    final day = _selectedDay.day;
    final url = Uri.parse(
      'https://en.wikipedia.org/api/rest_v1/feed/onthisday/events/$month/$day'
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _historicalEvents = data['events'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DayInfo(
                    selectedDay: _selectedDay,
                    holidays: _holidays,
                  ),
                  CalendarHeader(
                    displayedMonth: _displayedMonth,
                    onPrevMonth: () {
                      final prevMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
                      final oldYear = _displayedMonth.year;
                      setState(() { _displayedMonth = prevMonth; });
                      if (prevMonth.year != oldYear) _loadHolidays();
                    },
                    onNextMonth: () {
                      final nextMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
                      final oldYear = _displayedMonth.year;
                      setState(() { _displayedMonth = nextMonth; });
                      if (nextMonth.year != oldYear) _loadHolidays();
                    },
                  ),
                  WeekdayHeader(),
                  CalendarGrid(
                    displayedMonth: _displayedMonth,
                    onDaySelected: (date) {
                      setState(() { _selectedDay = date; });
                      _loadHistoricalEvents();
                    },
                  ),
                  HistoricalEvents(events: _historicalEvents),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}