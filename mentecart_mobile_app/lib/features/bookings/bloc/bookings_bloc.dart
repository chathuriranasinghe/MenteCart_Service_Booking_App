import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/booking_repository.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  BookingsBloc() : super(BookingsInitial()) {
    on<BookingsFetchRequested>(_onFetch);
    on<BookingCancelRequested>(_onCancel);
  }

  Future<void> _onFetch(
    BookingsFetchRequested event,
    Emitter<BookingsState> emit,
  ) async {
    emit(BookingsLoading());
    try {
      final list = await BookingRepository.getBookings();
      emit(BookingsLoaded(_parseBookings(list)));
    } catch (_) {
      emit(BookingsLoaded([]));
    }
  }

  Future<void> _onCancel(
    BookingCancelRequested event,
    Emitter<BookingsState> emit,
  ) async {
    final current = state is BookingsLoaded
        ? (state as BookingsLoaded).bookings
        : <BookingItemData>[];
    try {
      await BookingRepository.cancelBooking(event.bookingId);
      add(BookingsFetchRequested());
    } on DioException catch (e) {
      emit(
        BookingsActionFailure(
          e.response?.data?['message'] ?? 'Failed to cancel booking',
          current,
        ),
      );
      emit(BookingsLoaded(current));
    }
  }

  List<BookingItemData> _parseBookings(List<dynamic> list) {
    return list.map((b) {
      final items = b['items'] as List<dynamic>;
      final first = items.isNotEmpty ? items.first : null;
      return BookingItemData(
        id: b['bookingNumber'] as String,
        backendId: b['id'] as String,
        title: first?['title'] as String? ?? 'Booking',
        dateTime: first != null
            ? '${first['selectedDate']}, ${first['selectedTime']}'
            : '',
        price: 'Rs. ${b['totalAmount']}',
        status: _parseStatus(b['bookingStatus'] as String),
        imageUrl: first?['image'] as String? ?? '',
      );
    }).toList();
  }

  BookingStatus _parseStatus(String s) {
    switch (s) {
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
      case 'failed':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.upcoming;
    }
  }
}
