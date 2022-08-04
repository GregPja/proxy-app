import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:proxyfoxyapp/booking/bookingDto.dart';
import 'package:proxyfoxyapp/booking/service/booking_observer.dart';
import 'package:proxyfoxyapp/profile/profileService.dart';

class BookingService {
  static BookingService? _instance;
  final String endpoint =
      "https://b-proxy-foxy.herokuapp.com/book/withUser";
  final List<Booking> _latestBookings;
  final List<IBookingObserver> _observers = List.empty(growable: true);

  BookingService(this._latestBookings);

  static Future<BookingService> get instance async {
    if (_instance == null) {
      await _bookingFile.then((bookingFile) {
        if (bookingFile.existsSync()) {
          _instance = BookingService(
              (jsonDecode(bookingFile.readAsStringSync()) as List)
                  .map((e) => Booking.fromJson(e))
                  .toList(growable: true));
        } else {
          _instance = BookingService(List.empty(growable: true));
        }
      });
    }
    return _instance!;
  }

  static Future<File> get _bookingFile async {
    final path = (await (getApplicationDocumentsDirectory())).path;
    return File('$path/bookings.json');
  }

  Future<bool> book(
      SlotInfoDTO slot, String gymName, UserProfile userProfile) async {
    final result = await http.post(Uri.parse(endpoint),
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
        encoding: Encoding.getByName("utf-8"));
    if (result.statusCode == 200) {
      _addNewBooking(Booking(DateTime.now(), slot.start, slot.end, gymName));
      return true;
    }
    return false;
  }

  void _addNewBooking(Booking booking) {
    _latestBookings.add(booking);
    _latestBookings.sort(
      (a, b) => a.from.compareTo(b.from),
    );
    for (var element in _observers) {
      element.onBooking(booking);
    }
    _bookingFile.then((value) => value.writeAsString(
        jsonEncode(_latestBookings.map((e) => e.toMap()).toList())));
  }

  List<Booking> upcomingBookings() {
    return _latestBookings
        .where((element) => DateTime.now().compareTo(element.from) < 1)
        .take(3)
        .toList();
  }

  void register(IBookingObserver observer) => _observers.add(observer);

  void remove(IBookingObserver observer) => _observers.remove(observer);
}

class Booking {
  final DateTime bookingTime;
  final DateTime from;
  final DateTime to;
  final String gymName;

  Booking(this.bookingTime, this.from, this.to, this.gymName);

  factory Booking.fromJson(Map<dynamic, dynamic> json) => Booking(
      DateTime.parse(json['bookingTime']),
      DateTime.parse(json['from']),
      DateTime.parse(json['to']),
      json['gymName']);

  Map<String, String> toMap() {
    return {
      'bookingTime': bookingTime.toUtc().toIso8601String(),
      'from': from.toUtc().toIso8601String(),
      'to': to.toUtc().toIso8601String(),
      'gymName': gymName
    };
  }

  static Map<String, dynamic> toJson(Booking value) => value.toMap();
}
