import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proxyfoxyapp/booking/bookingDto.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import 'boulderingPlaces.dart';

class BookingCalendarView extends StatefulWidget {
  const BookingCalendarView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeCalendarPageState();
}

class _HomeCalendarPageState extends State<BookingCalendarView> {
  late CalendarController _controller;

  Future<Map<String, List<SlotInfoDTO>>> _getDataByDate(DateTime time) async {
    var url = 'https://b-proxy-foxy.herokuapp.com/book?from='
        '${time.add(const Duration(hours: -12)).toIso8601String()}&'
        'to=${time.add(const Duration(hours: 11)).toIso8601String()}';
    var result = await http.get(Uri.parse(url));
    return (jsonDecode(result.body) as Map<String, dynamic>).map(
        (name, slots) => MapEntry(
            name,
            (slots as List<dynamic>)
                .map((slot) => SlotInfoDTO.fromJson(slot))
                .toList()));
  }

  Future<void> _displayPlacesForDate(DateTime time) async {
    var slots = await _getDataByDate(time);
    if (!mounted) return;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BoulderingPlaces(slots, time)));
  }

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick your date'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              initialCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                  todayColor: Colors.blue,
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(22.0),
                ),
                formatButtonTextStyle: const TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (DateTime date, events, somethingElse) {
                _displayPlacesForDate(date);
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      date.day.toString(),
                      style: const TextStyle(color: Colors.white),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      date.day.toString(),
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
              calendarController: _controller,
            )
          ],
        ),
      ),
    );
  }
}
