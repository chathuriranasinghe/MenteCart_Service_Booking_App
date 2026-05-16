part of 'bookings_bloc.dart';

abstract class BookingsState {}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  BookingsLoaded(this.bookings);
  final List<BookingItemData> bookings;
}

class BookingsActionFailure extends BookingsState {
  BookingsActionFailure(this.message, this.previousBookings);
  final String message;
  final List<BookingItemData> previousBookings;
}

enum BookingStatus { upcoming, completed, cancelled }

class BookingItemData {
  const BookingItemData({
    required this.id,
    required this.backendId,
    required this.title,
    required this.dateTime,
    required this.price,
    required this.status,
    required this.imageUrl,
  });

  final String id;
  final String backendId;
  final String title;
  final String dateTime;
  final String price;
  final BookingStatus status;
  final String imageUrl;
}
