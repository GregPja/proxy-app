import 'package:flutter/material.dart';
import 'package:proxyfoxyapp/booking/review/reviewBookingInfo.dart';

import '../../profile/profile.dart';
import '../../profile/profileService.dart';

class ReviewBooking extends StatelessWidget {
  final String gymName;
  final DateTime from;
  final DateTime to;

  const ReviewBooking(
      {required this.gymName, required this.from, required this.to, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review your booking"),
      ),
      body: ListView(
        children: [
          BookingInfoView(gymName: gymName, from: from, to: to),
          const BookingOrProfileButton(),
        ],
      ),
    );
  }
}

class BookingOrProfileButton extends StatefulWidget {
  const BookingOrProfileButton({Key? key}) : super(key: key);

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
            ? ElevatedButton(onPressed: () => {




        }, child: const Text("Book"))
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
