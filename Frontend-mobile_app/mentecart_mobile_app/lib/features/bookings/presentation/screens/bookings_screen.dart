import 'package:flutter/material.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../home/presentation/widgets/bottom_nav_bar.dart';
import '../widgets/booking_card.dart';
import '../widgets/booking_status_chip.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _currentNavIndex = 3;
  int _selectedStatusIndex = 0;

  final List<String> _statusTabs = const ['Upcoming', 'Completed', 'Cancelled'];

  final List<_BookingItem> _bookings = const [
    _BookingItem(
      id: 'BK-1001',
      title: 'Home Cleaning',
      dateTime: '20 May 2025, 11.00 AM',
      address: 'No 25, Lake Road, Colombo 03',
      price: '₹699',
      status: BookingStatus.upcoming,
      imageUrl:
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=600',
    ),
    _BookingItem(
      id: 'BK-1002',
      title: 'Plumbing Repair',
      dateTime: '21 May 2025, 02.00 PM',
      address: 'No 25, Lake Road, Colombo 03',
      price: '₹499',
      status: BookingStatus.upcoming,
      imageUrl:
          'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?q=80&w=600',
    ),
    _BookingItem(
      id: 'BK-0988',
      title: 'Tutoring',
      dateTime: '12 May 2025, 06.00 PM',
      address: 'No 25, Lake Road, Colombo 03',
      price: '₹399',
      status: BookingStatus.completed,
      imageUrl:
          'https://images.unsplash.com/photo-1588072432836-e10032774350?q=80&w=600',
    ),
    _BookingItem(
      id: 'BK-0975',
      title: 'Beauty Appointment',
      dateTime: '08 May 2025, 04.00 PM',
      address: 'No 25, Lake Road, Colombo 03',
      price: '₹799',
      status: BookingStatus.completed,
      imageUrl:
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=600',
    ),
    _BookingItem(
      id: 'BK-0960',
      title: 'Office Cleaning',
      dateTime: '04 May 2025, 10.00 AM',
      address: 'Office Building, Colombo 01',
      price: '₹899',
      status: BookingStatus.cancelled,
      imageUrl:
          'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?q=80&w=600',
    ),
  ];

  List<_BookingItem> get _filteredBookings {
    final selectedStatus = _statusFromIndex(_selectedStatusIndex);

    return _bookings
        .where((booking) => booking.status == selectedStatus)
        .toList();
  }

  BookingStatus _statusFromIndex(int index) {
    switch (index) {
      case 0:
        return BookingStatus.upcoming;
      case 1:
        return BookingStatus.completed;
      case 2:
        return BookingStatus.cancelled;
      default:
        return BookingStatus.upcoming;
    }
  }

  void _handleStatusSelected(int index) {
    setState(() {
      _selectedStatusIndex = index;
    });
  }

  void _handleBookingTap(_BookingItem booking) {
    // TODO: Navigate to booking details screen.
  }

  void _handlePrimaryAction(_BookingItem booking) {
    switch (booking.status) {
      case BookingStatus.upcoming:
        // TODO: Track booking.
        break;
      case BookingStatus.completed:
      case BookingStatus.cancelled:
        // TODO: Rebook service.
        break;
    }
  }

  void _handleSecondaryAction(_BookingItem booking) {
    switch (booking.status) {
      case BookingStatus.upcoming:
        // TODO: Cancel booking.
        break;
      case BookingStatus.completed:
        // TODO: Add review.
        break;
      case BookingStatus.cancelled:
        // TODO: View booking details.
        break;
    }
  }

  void _handleSearchPressed() {
    // TODO: Add booking search.
  }

  void _handleNavItemSelected(int index) {
    if (index == _currentNavIndex) {
      return;
    }

    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      return;
    }

    if (index == 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.services);
      return;
    }

    if (index == 2) {
      Navigator.pushReplacementNamed(context, AppRoutes.cart);
      return;
    }

    setState(() {
      _currentNavIndex = index;
    });

    // TODO: Add profile navigation after creating profile screen.
  }

  @override
  Widget build(BuildContext context) {
    final bookings = _filteredBookings;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentNavIndex,
        onItemSelected: _handleNavItemSelected,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: Column(
                children: [
                  _BookingsHeader(onSearchPressed: _handleSearchPressed),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _statusTabs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return BookingStatusChip(
                          title: _statusTabs[index],
                          isSelected: _selectedStatusIndex == index,
                          onTap: () => _handleStatusSelected(index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: bookings.isEmpty
                  ? const _EmptyBookingsView()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                      itemCount: bookings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final booking = bookings[index];

                        return BookingCard(
                          title: booking.title,
                          bookingId: booking.id,
                          dateTime: booking.dateTime,
                          address: booking.address,
                          price: booking.price,
                          status: booking.status,
                          imageUrl: booking.imageUrl,
                          onTap: () => _handleBookingTap(booking),
                          onPrimaryAction: () => _handlePrimaryAction(booking),
                          onSecondaryAction: () =>
                              _handleSecondaryAction(booking),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingsHeader extends StatelessWidget {
  const _BookingsHeader({required this.onSearchPressed});

  final VoidCallback onSearchPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'My Bookings',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
        ),
        IconButton(
          onPressed: onSearchPressed,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
          icon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF111827),
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _EmptyBookingsView extends StatelessWidget {
  const _EmptyBookingsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(18),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.calendar_month_outlined,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No bookings found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your service bookings will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingItem {
  const _BookingItem({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.address,
    required this.price,
    required this.status,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String dateTime;
  final String address;
  final String price;
  final BookingStatus status;
  final String imageUrl;
}
