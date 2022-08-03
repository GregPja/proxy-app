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
  UserDetail userDetail = UserDetail();
  final _profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();

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
                setState(() => userDetail.firstName = value?.trim());
              }),
          _InputForm(
              label: "Last name",
              value: userDetail.lastName,
              updateFunction: (value) {
                setState(() => userDetail.lastName = value?.trim());
              }),
          _InputForm(
              label: "Email",
              value: userDetail.email,
              updateFunction: (value) {
                setState(() => userDetail.email = value?.trim());
              }),
          _InputForm(
              label: "Urban sport club ID",
              value: userDetail.urbanSportClubId,
              updateFunction: (value) {
                setState(() => userDetail.urbanSportClubId = value?.trim());
              }),
          _InputForm(
              label: "Date of birth (dd.mm.yyyy)",
              value: userDetail.dateOfBirth,
              updateFunction: (value) {
                setState(() => userDetail.dateOfBirth = value?.trim());
              },
              validation: (value) {
                final re = RegExp(r'\d{2}.\d{2}.\d{4}'); // yeah yeah, I should check if it's a Date time, it will come
                return re.stringMatch(value) == value
                    ? null
                    : "Birthday does not match the format, example: 14.02.1990";
              }),
          _InputForm(
              label: "Street name",
              value: userDetail.streetName,
              updateFunction: (value) {
                setState(() => userDetail.streetName = value?.trim());
              }),
          _InputForm(
              label: "City",
              value: userDetail.city,
              updateFunction: (value) {
                setState(() => userDetail.city = value?.trim());
              }),
          _InputForm(
            label: "Phone number",
            value: userDetail.phoneNumber,
            updateFunction: (value) {
              setState(() => userDetail.phoneNumber = value?.trim());
            },
            keyboardType: TextInputType.phone,
          ),
          _InputForm(
            label: "Postal code",
            value: userDetail.postalCode,
            updateFunction: (value) {
              setState(() => userDetail.postalCode = value?.trim());
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
              child: const Text('Update Profile'),
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
  final String? Function(String value)? validation;

  const _InputForm(
      {required this.label,
      required this.value,
      required this.updateFunction,
      Key? key,
      this.keyboardType,
      this.validation})
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
          return validation != null ? validation!(value) : null;
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
