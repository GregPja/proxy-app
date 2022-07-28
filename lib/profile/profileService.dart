import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:proxyfoxyapp/profile/profileForm.dart';

class ProfileService {
  UserProfile? _currentProfile;
  static final ProfileService _instance = ProfileService._internal();

  factory ProfileService() {
    return _instance;
  }

  ProfileService._internal() {
    _userProfileFile.then((file) {
      if (file.existsSync()) {
        _currentProfile =
            UserProfile.fromJson(jsonDecode(file.readAsStringSync()));
      }
    });
  }

  Future<File> get _userProfileFile async {
    final path = (await (getApplicationDocumentsDirectory())).path;
    return File('$path/userProfile.json');
  }

  void updateProfile(UserDetail updated) {
    _currentProfile = UserProfile(
        firstName: updated.firstName!,
        lastName: updated.lastName!,
        email: updated.email!,
        urbanSportClubId: updated.urbanSportClubId!,
        dateOfBirth: updated.dateOfBirth!,
        streetName: updated.streetName!,
        city: updated.city!,
        phoneNumber: updated.phoneNumber!,
        postalCode: updated.postalCode!);
    _userProfileFile.then((file) {
      if (!file.existsSync()) {
        file.create(recursive: true);
      }
      file.writeAsString(_currentProfile!.toJsonString());
    });
  }

  UserProfile? getProfile() {
    return _currentProfile;
  }
}

class UserProfile {
  String firstName;
  String lastName;
  String email;
  String urbanSportClubId;
  String dateOfBirth;
  String streetName;
  String city;
  String phoneNumber;
  String postalCode;

  UserProfile(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.urbanSportClubId,
      required this.dateOfBirth,
      required this.streetName,
      required this.city,
      required this.phoneNumber,
      required this.postalCode});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      urbanSportClubId: json['urbanSportClubId'],
      dateOfBirth: json['dateOfBirth'],
      streetName: json['streetName'],
      city: json['city'],
      phoneNumber: json['phoneNumber'],
      postalCode: json['postalCode'],
    );
  }

  String toJsonString() {
    return jsonEncode({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "urbanSportClubId": urbanSportClubId,
      "dateOfBirth": dateOfBirth,
      "streetName": streetName,
      "city": city,
      "phoneNumber": phoneNumber,
      "postalCode": postalCode,
    });
  }
}
