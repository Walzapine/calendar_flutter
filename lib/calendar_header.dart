import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime displayedMonth;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const CalendarHeader({
    super.key,
    required this.displayedMonth,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

   
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onPrevMonth,  // ← kein setState mehr!
        ),
        Text(
          "${displayedMonth.year} - ${displayedMonth.month.toString().padLeft(2, '0')}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 190, 151, 206),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: onNextMonth,  // ← kein setState mehr!
        ),
      ],
    );
  }
}

  class WeekdayHeader extends StatelessWidget {
  const WeekdayHeader({super.key});

  final List<String> weekdays = const ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 74, 151, 195),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}