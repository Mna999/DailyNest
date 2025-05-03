import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitCalendar extends StatefulWidget {
  final String habitId;

  const HabitCalendar({super.key, required this.habitId});

  @override
  State<HabitCalendar> createState() => _HabitCalendarState();
}

class _HabitCalendarState extends State<HabitCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Set<DateTime> _recordedDays = {};

  @override
  void initState() {
    super.initState();
    _loadRecordedDates();
  }

  Future<void> _loadRecordedDates() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('habits')
        .doc(widget.habitId)
        .collection('completion_dates')
        .get();

    setState(() {
      _recordedDays.addAll(
        snapshot.docs.map((doc) => (doc['date'] as Timestamp).toDate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2050, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: CalendarStyle(
        // White text for all days
        defaultTextStyle: const TextStyle(color: Colors.white),
        weekendTextStyle: const TextStyle(color: Colors.white),
        holidayTextStyle: const TextStyle(color: Colors.white),
        outsideTextStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        disabledTextStyle: TextStyle(color: Colors.white.withOpacity(0.3)),

        // Cell decorations
        todayDecoration: BoxDecoration(
          color: Colors.orange.shade400,
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        markerDecoration: const BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        markerSize: 6,
        markerMargin: const EdgeInsets.symmetric(horizontal: 1),
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        formatButtonDecoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
        ),
        formatButtonTextStyle: const TextStyle(color: Colors.white),
        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: const TextStyle(color: Colors.white),
        weekendStyle: const TextStyle(color: Colors.white),
      ),
      daysOfWeekHeight: 30,
      rowHeight: 42,
      eventLoader: (day) {
        return _recordedDays.any((recordedDay) => isSameDay(recordedDay, day))
            ? [1]
            : [];
      },
    );
  }
}
