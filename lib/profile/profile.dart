import 'package:flutter/material.dart';
import 'package:proxyfoxyapp/profile/profileForm.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: const Center(
        child: ProfileForm(),
      ),
    );
  }
}
