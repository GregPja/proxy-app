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
          children: slots.map((slot) {
            final formatter = DateFormat("HH:mm");
            final start = formatter.format(slot.start.toLocal());
            final end = formatter.format(slot.end.toLocal());
            return ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewBooking(
                                gymName: gymName,
                                slot: slot,
                              )));
                },
                child: Text("$start - $end | ${slot.freeSpots} "));
          }).toList(),
        ));
  }
}
