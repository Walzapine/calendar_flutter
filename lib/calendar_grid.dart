
import 'package:flutter/material.dart';


class CalendarGrid extends StatelessWidget {
  final DateTime displayedMonth;
  final Function(DateTime) onDaySelected;

  const CalendarGrid({
    super.key,
    required this.displayedMonth,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    int firstWeekday = DateTime(displayedMonth.year, displayedMonth.month, 1).weekday - 1;
    int daysInMonth = DateTime(displayedMonth.year, displayedMonth.month + 1, 0).day;

    List<Widget> cells = [];
    for (int i = 0; i < 42; i++) {
      int dayNumber = i - firstWeekday + 1;

      if (i < firstWeekday || dayNumber > daysInMonth) {
        cells.add(Container());
      } else {
        DateTime cellDate = DateTime(displayedMonth.year, displayedMonth.month, dayNumber);
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
            onTap: () => onDaySelected(cellDate),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(child: Text(dayNumber.toString())),
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
}