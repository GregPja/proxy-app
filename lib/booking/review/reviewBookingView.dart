import 'package:flutter/material.dart';
import 'package:proxyfoxyapp/booking/bookingDto.dart';
import 'package:proxyfoxyapp/booking/service/bookingService.dart';
import 'package:proxyfoxyapp/booking/review/reviewBookingInfo.dart';

import '../../animation/animation.dart';
import '../../profile/profile.dart';
import '../../profile/profileService.dart';

class ReviewBooking extends StatelessWidget {
  final String gymName;
  final SlotInfoDTO slot;

  const ReviewBooking({Key? key, required this.gymName, required this.slot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review your booking"),
      ),
      body: ListView(
        children: [
          BookingReviewInfoView(
              gymName: gymName,
              from: slot.start.toLocal(),
              to: slot.end.toLocal()),
          BookingOrProfileButton(
            slot: slot,
            gymName: gymName,
          ),
        ],
      ),
    );
  }
}

class BookingOrProfileButton extends StatefulWidget {
  final SlotInfoDTO slot;
  final String gymName;

  const BookingOrProfileButton(
      {Key? key, required this.slot, required this.gymName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => BookingOrProfileButtonState();
}

class BookingOrProfileButtonState extends State<BookingOrProfileButton> {
  final ProfileService profileService = ProfileService();
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = profileService.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, top: 20, bottom: 40),
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: userProfile != null
            ? BookingButton(
                userProfile: userProfile!,
                slot: widget.slot,
                gymName: widget.gymName)
            : Column(
                children: [
                  const Text(
                      "Looks like you don't have a profile, and it's required for booking"),
                  ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Profile()),
                        );
                        setState(() {
                          userProfile = profileService.getProfile();
                        });
                      },
                      child: const Text("Create your profile!"))
                ],
              ));
  }
}

class BookingButton extends StatefulWidget {
  final bookingService = BookingService.instance;
  final UserProfile userProfile;
  final SlotInfoDTO slot;
  final String gymName;

  BookingButton(
      {Key? key,
      required this.userProfile,
      required this.slot,
      required this.gymName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => BookingButtonState();
}

class BookingButtonState extends State<BookingButton> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = true;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: !isActive
            ? null
            : () async {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: const Color.fromARGB(200, 255, 183, 0),
                    duration: const Duration(minutes: 2),
                    content: Row(
                      children: const <Widget>[
                        AnimatedClimber(),
                        Text("  Booking...")
                      ],
                    )));
                setState(() {
                  isActive = false;
                });
                (await widget
                        .bookingService) // TODO damn I need to find a wayyy better solution here too
                    .book(widget.slot, widget.gymName, widget.userProfile)
                    .then((value) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  if (value) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Color.fromARGB(200, 0, 255, 13),
                      content: Text("Booking completed!!!"),
                    ));
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  } else {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Color.fromARGB(200, 255, 0, 0),
                      content: Text("Something went wrong :/"),
                    ));
                    setState(() {
                      isActive = true;
                    });
                  }
                }).timeout(const Duration(seconds: 10), onTimeout: () {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Color.fromARGB(200, 255, 0, 0),
                    content: Text("No answer from the server :("),
                  ));
                });
              },
        child: const Text("Book"));
  }
}
