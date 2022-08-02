import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingReviewInfoView extends StatelessWidget {
  final String gymName;
  final DateTime from;
  final DateTime to;

  const BookingReviewInfoView(
      {required this.gymName, required this.from, required this.to, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          margin: const EdgeInsets.only(left: 10.0, top: 20.0),
          child: const Text.rich(TextSpan(
              text: "Your Booking: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)))),
      Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          padding: const EdgeInsets.only(left: 10, top: 20, bottom: 40),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.blueGrey))),
          child: SlotInfo(gymName: gymName, from: from, to: to))
    ]);
  }
}

class SlotInfo extends StatelessWidget {
  const SlotInfo({
    Key? key,
    required this.gymName,
    required this.from,
    required this.to,
  }) : super(key: key);

  final String gymName;
  final DateTime from;
  final DateTime to;

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat("HH:mm");
    return Container(
        padding: const EdgeInsets.only(left: 20),
        decoration: const BoxDecoration(
            border: Border(
                left: BorderSide(
                    width: 4, color: Color.fromARGB(88, 88, 201, 255)))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text.rich(TextSpan(children: [
            const TextSpan(
                text: "Gym: ", style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: gymName),
          ])),
          Text.rich(TextSpan(children: [
            const TextSpan(
                text: "From: ", style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: dateFormatter.format(from)),
          ])),
          Text.rich(TextSpan(children: [
            const TextSpan(
                text: "To: ", style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: dateFormatter.format(to)),
          ])),
        ]));
  }
}
