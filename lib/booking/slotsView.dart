import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proxyfoxyapp/booking/bookingDto.dart';
import 'package:proxyfoxyapp/booking/review/reviewBookingView.dart';
import 'package:proxyfoxyapp/profile/profileService.dart';

class SlotsView extends StatelessWidget {
  final List<SlotInfoDTO> slots;
  final DateTime choseDate;
  final String gymName;

  const SlotsView(
      {required this.slots,
      required this.choseDate,
      required this.gymName,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$gymName - ${DateFormat("E dd MMM").format(choseDate)}"),
        ),
        body: ListView(
          children: slots.map((e) {
            final formatter = DateFormat("HH:mm");
            final start = formatter.format(e.start.toLocal());
            final end = formatter.format(e.end.toLocal());
            return ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewBooking(
                              gymName: gymName,
                              from: e.start.toLocal(),
                              to: e.end.toLocal(),
                              )));
                },
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //       backgroundColor: Color.fromARGB(200, 26, 255, 0),
                //       duration: Duration(minutes: 1),
                //       content: Row(
                //         children: <Widget>[
                //           CircularProgressIndicator(),
                //           Text("  Booking...")
                //         ],
                //       )));
                //   Future.delayed(Duration(seconds: 5), () {})
                //       .whenComplete(() =>
                //           ScaffoldMessenger.of(context).removeCurrentSnackBar())
                //       .then((value) => Navigator.of(context)
                //           .popUntil((route) => route.isFirst));
                // },
                child: Text("$start - $end | ${e.freeSpots} "));
          }).toList(),
        ));
  }
}
