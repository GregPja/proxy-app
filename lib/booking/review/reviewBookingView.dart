import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proxyfoxyapp/booking/bookingDto.dart';
import 'package:proxyfoxyapp/booking/review/reviewBookingInfo.dart';

import '../../profile/profile.dart';
import '../../profile/profileService.dart';
import 'package:http/http.dart' as http;

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
          BookingInfoView(
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

class BookingButton extends StatelessWidget {
  final String endpoint =
      "http://641a-5-145-176-14.ngrok.io/book/withUser"; //"https://b-proxy-foxy.herokuapp.com/book";
  final UserProfile userProfile;
  final SlotInfoDTO slot;
  final String gymName;

  const BookingButton(
      {Key? key,
      required this.userProfile,
      required this.slot,
      required this.gymName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: const Color.fromARGB(200, 255, 183, 0),
              duration: const Duration(minutes: 1),
              content: Row(
                children: const <Widget>[
                  CircularProgressIndicator(),
                  Text("  Booking...")
                ],
              )));
          http
              .post(Uri.parse(endpoint),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode({
                    'id': slot.id,
                    'user': userProfile.toMap(),
                    'place': gymName,
                    'start': slot.start.toIso8601String(),
                    'end': slot.end.toIso8601String()
                  }),
                  encoding: Encoding.getByName("utf-8"))
              .then((value) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            if (value.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Color.fromARGB(200, 0, 255, 13),
                content: Text("Booking completed!!!"),
              ));
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Color.fromARGB(200, 255, 0, 0),
                content: Text("Something went wrong :/"),
              ));
            }
          }).timeout(const Duration(seconds: 10), onTimeout: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Color.fromARGB(200, 255, 0, 0),
              content: Text("No aswer from the server :("),
            ));
          });
        },
        child: const Text("Book"));
  }
}

// ScaffoldMessenger.of(context).removeCurrentSnackBar())
//               .then((value) => Navigator.of(context)
//               .popUntil((route) => route.isFirst));
