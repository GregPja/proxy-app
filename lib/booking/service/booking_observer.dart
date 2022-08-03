import 'bookingService.dart';

abstract class IBookingObserver{
  void onBooking(Booking booking);
}