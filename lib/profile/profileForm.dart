import 'package:flutter/material.dart';
import 'package:proxyfoxyapp/profile/profileService.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<ProfileForm> {
  final _profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();
  UserDetail userDetail = UserDetail();

  @override
  void initState() {
    super.initState();
    var storedProfile = _profileService.getProfile();
    if (storedProfile != null) {
      userDetail.firstName = storedProfile.firstName;
      userDetail.lastName = storedProfile.lastName;
      userDetail.email = storedProfile.email;
      userDetail.urbanSportClubId = storedProfile.urbanSportClubId;
      userDetail.dateOfBirth = storedProfile.dateOfBirth;
      userDetail.streetName = storedProfile.streetName;
      userDetail.city = storedProfile.city;
      userDetail.phoneNumber = storedProfile.phoneNumber;
      userDetail.postalCode = storedProfile.postalCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(children: <Widget>[
          _InputForm(
              label: "First name",
              value: userDetail.firstName,
              updateFunction: (value) {
                setState(() => userDetail.firstName = value);
              }),
          _InputForm(
              label: "Last name",
              value: userDetail.lastName,
              updateFunction: (value) {
                setState(() => userDetail.lastName = value);
              }),
          _InputForm(
              label: "Email",
              value: userDetail.email,
              updateFunction: (value) {
                setState(() => userDetail.email = value);
              }),
          _InputForm(
              label: "Urban sport club ID",
              value: userDetail.urbanSportClubId,
              updateFunction: (value) {
                setState(() => userDetail.urbanSportClubId = value);
              }),
          _InputForm(
              label: "Date of birth (dd.mm.yyyy)",
              value: userDetail.dateOfBirth,
              updateFunction: (value) {
                setState(() => userDetail.dateOfBirth = value);
              }),
          _InputForm(
              label: "Street name",
              value: userDetail.streetName,
              updateFunction: (value) {
                setState(() => userDetail.streetName = value);
              }),
          _InputForm(
              label: "City",
              value: userDetail.city,
              updateFunction: (value) {
                setState(() => userDetail.city = value);
              }),
          _InputForm(
            label: "Phone number",
            value: userDetail.phoneNumber,
            updateFunction: (value) {
              setState(() => userDetail.phoneNumber = value);
            },
            keyboardType: TextInputType.phone,
          ),
          _InputForm(
            label: "Postal code",
            value: userDetail.postalCode,
            updateFunction: (value) {
              setState(() => userDetail.postalCode = value);
            },
            keyboardType: TextInputType.phone,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Color.fromARGB(200, 26, 255, 0),
                        content: Text('Profile updated!')),
                  );
                  _formKey.currentState!.save();
                  _profileService.updateProfile(userDetail);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Color.fromARGB(200, 235, 64, 52),
                        content: Text('Some data is missing')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ]));
  }
}

class _InputForm extends StatelessWidget {
  final String label;
  final TextInputType? keyboardType;
  final void Function(String?) updateFunction;
  final String? value;

  const _InputForm(
      {required this.label,
      required this.value,
      required this.updateFunction,
      Key? key,
      this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please fill this entry';
          }
          return null;
        },
        onChanged: (String? value) {
          updateFunction(value);
        },
        onSaved: (String? value) {
          updateFunction(value);
        },
        initialValue: value,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}

class UserDetail {
  String? firstName;
  String? lastName;
  String? email;
  String? urbanSportClubId;
  String? dateOfBirth;
  String? streetName;
  String? city;
  String? phoneNumber;
  String? postalCode;

  UserDetail(
      {this.firstName,
      this.lastName,
      this.email,
      this.urbanSportClubId,
      this.dateOfBirth,
      this.streetName,
      this.city,
      this.phoneNumber,
      this.postalCode});
}
