part of 'bookings_bloc.dart';

abstract class BookingsEvent {}

class BookingsFetchRequested extends BookingsEvent {}

class BookingCancelRequested extends BookingsEvent {
  BookingCancelRequested(this.bookingId);
  final String bookingId;
}
