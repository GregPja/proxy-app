import 'package:flutter/material.dart';
import 'package:proxyfoxyapp/profile/profile.dart';
import 'package:proxyfoxyapp/profile/profileService.dart';

import 'booking/bookingCalendarView.dart';

void main() => runApp(const ProxyFoxyApp());

class ProxyFoxyApp extends StatelessWidget {
  const ProxyFoxyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  final _profileService =
      ProfileService(); // horrible temporary workaround to have the user profile loaded on start up
  MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Proxy Foxy')),
        ),
        body: ListView(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              ),
              child: const Text("Manage Profile"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BookingCalendarView()),
              ),
              child: const Text("Book"),
            ),
          ],
        ));
  }
}
