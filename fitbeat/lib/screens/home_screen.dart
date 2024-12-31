// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import './start_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primary = Color.fromARGB(255, 0, 64, 221);
  final Color secondary = Color.fromARGB(255, 116, 109, 240);
  final Color third = Color.fromARGB(255, 126, 202, 237);
  final Color fourth = Color.fromARGB(255, 213, 184, 247);

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final DateTime _firstDay = DateTime.now().subtract(Duration(days: 365));
  final DateTime _lastDay = DateTime.now().add(Duration(days: 365));

  Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
  }

  void _loadEvents() {
    // Example events - replace with your actual data source
    _events = {
      DateTime.now().subtract(Duration(days: 2)): [Event('Running', 5.2)],
      DateTime.now().subtract(Duration(days: 1)): [Event('Weightlifting', 7.8)],
      DateTime.now(): [Event('Yoga', 3.5)],
    };
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Normalize the date to compare only year, month, and day
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  void _addWorkout(DateTime day) {
    // TO DO: ADD FUNCTION TO START_SCREEN TO CMAKE EVENT HAPPEN
  }

  void _showEventDetails(Event event) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(event.title),
        message: Text('Intensity: ${event.intensity.toStringAsFixed(1)}/10'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // Add edit functionality here
            },
            child: Text('Edit Workout'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _events[_selectedDay!]?.remove(event);
                if (_events[_selectedDay!]?.isEmpty ?? false) {
                  _events.remove(_selectedDay!);
                }
              });
              Navigator.pop(context);
            },
            isDestructiveAction: true,
            child: Text('Delete Workout'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildCalendarAnalytics(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'Gym Rizzler',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarAnalytics() {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
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
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              markersMaxCount: 3,
              markerDecoration: BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: primary.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Workouts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          ..._getEventsForDay(_selectedDay ?? _focusedDay)
              .map(
                (event) => GestureDetector(
                  onTap: () => _showEventDetails(event),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          event.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Intensity: ${event.intensity.toStringAsFixed(1)}',
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          if (_getEventsForDay(_selectedDay ?? _focusedDay).isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'No workouts scheduled for this day',
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  SizedBox(height: 8),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _addWorkout(_selectedDay ?? _focusedDay),
                    child: Text('Plan a Workout'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class Event {
  final String title;
  final double intensity;

  Event(this.title, this.intensity);
}
