import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proxyfoxyapp/booking/service/bookingService.dart';

import '../booking/review/reviewBookingInfo.dart';
import '../booking/service/booking_observer.dart';

class UpcomingBookingView extends StatefulWidget {
  final BookingService bookingService;

  const UpcomingBookingView({Key? key, required this.bookingService})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UpcomingBookingViewState();
  }
}

class UpcomingBookingViewState extends State<UpcomingBookingView>
    implements IBookingObserver {
  late List<Booking> latest;

  @override
  void initState() {
    super.initState();
    latest = widget.bookingService.upcomingBookings();
    widget.bookingService.register(this);
  }

  @override
  Widget build(BuildContext context) {
    return latest.isNotEmpty
        ? UpcomingBookingInfo(latest: latest)
        : const SizedBox.shrink();
  }

  @override
  void onBooking(Booking booking) {
    setState(() {
      latest = widget.bookingService.upcomingBookings();
    });
  }

  @override
  void dispose() {
    widget.bookingService.remove(this);
    super.dispose();
  }
}

class UpcomingBookingInfo extends StatelessWidget {
  final List<Booking> latest;

  const UpcomingBookingInfo({required this.latest, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          margin: const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 10),
          child: const Text.rich(TextSpan(
              text: "Upcoming: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)))),
      ...latest
          .map((e) =>
              UpcomingSlotDetails(from: e.from, to: e.to, gymName: e.gymName))
          .toList()
    ]);
  }
}

class UpcomingSlotDetails extends StatelessWidget {
  final String gymName;
  final DateTime from;
  final DateTime to;

  const UpcomingSlotDetails({
    Key? key,
    required this.gymName,
    required this.from,
    required this.to,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        padding: const EdgeInsets.only(left: 10, top: 20, bottom: 40),
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.blueGrey))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text.rich(TextSpan(children: [
            const TextSpan(
                text: "Date: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            TextSpan(
                text: DateFormat("dd.MM.yyyy").format(from),
                style: TextStyle(fontSize: 17)),
          ])),
          Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 10.0),
              child: SlotInfo(gymName: gymName, from: from, to: to))
        ]));
  }
}
