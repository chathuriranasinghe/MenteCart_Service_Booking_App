import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../bloc/bookings_bloc.dart';
import '../../../home/presentation/widgets/bottom_nav_bar.dart';
import '../widgets/booking_card.dart';
import '../widgets/booking_status_chip.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedStatusIndex = 0;
  String _searchQuery = '';
  final List<String> _statusTabs = const ['Upcoming', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    context.read<BookingsBloc>().add(BookingsFetchRequested());
  }

  BookingStatus _statusFromIndex(int index) {
    switch (index) {
      case 1: return BookingStatus.completed;
      case 2: return BookingStatus.cancelled;
      default: return BookingStatus.upcoming;
    }
  }

  List<BookingItemData> _filtered(List<BookingItemData> bookings) {
    final byStatus = bookings.where((b) => b.status == _statusFromIndex(_selectedStatusIndex));
    if (_searchQuery.isEmpty) return byStatus.toList();
    final q = _searchQuery.toLowerCase();
    return byStatus.where((b) =>
      b.title.toLowerCase().contains(q) ||
      b.id.toLowerCase().contains(q)
    ).toList();
  }

  void _showSearchDialog() {
    showDialog<String>(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController(text: _searchQuery);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Search Bookings', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Booking # or service name...',
              hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6366F1))),
            ),
            onSubmitted: (v) => Navigator.pop(ctx, v),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, ''),
              child: const Text('Clear', style: TextStyle(color: Color(0xFF6B7280))),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Search'),
            ),
          ],
        );
      },
    ).then((query) {
      if (query != null) setState(() => _searchQuery = query.trim());
    });
  }

  void _handleNavItemSelected(int index) {
    if (index == 0) { Navigator.pushReplacementNamed(context, AppRoutes.home); return; }
    if (index == 1) { Navigator.pushReplacementNamed(context, AppRoutes.services); return; }
    if (index == 2) { Navigator.pushReplacementNamed(context, AppRoutes.cart); return; }
    if (index == 4) { Navigator.pushReplacementNamed(context, AppRoutes.profile); return; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      bottomNavigationBar: HomeBottomNavBar(currentIndex: 3, onItemSelected: _handleNavItemSelected),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('My Bookings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            onPressed: _showSearchDialog,
                            style: IconButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Color(0xFFE5E7EB)))),
                            icon: const Icon(Icons.search_rounded, color: Color(0xFF111827), size: 22),
                          ),
                          if (_searchQuery.isNotEmpty)
                            Positioned(
                              right: 6, top: 6,
                              child: Container(
                                width: 8, height: 8,
                                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _statusTabs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) => BookingStatusChip(
                        title: _statusTabs[index],
                        isSelected: _selectedStatusIndex == index,
                        onTap: () => setState(() => _selectedStatusIndex = index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocConsumer<BookingsBloc, BookingsState>(
                listener: (context, state) {
                  if (state is BookingsActionFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  if (state is BookingsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is BookingsLoaded) {
                    final filtered = _filtered(state.bookings);
                    if (filtered.isEmpty) return _EmptyBookingsView();
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final booking = filtered[index];
                        return BookingCard(
                          title: booking.title,
                          bookingId: booking.id,
                          dateTime: booking.dateTime,
                          address: '',
                          price: booking.price,
                          status: booking.status,
                          imageUrl: booking.imageUrl,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.bookingDetail, arguments: booking.backendId),
                          onPrimaryAction: () {},
                          onSecondaryAction: () {
                            if (booking.status != BookingStatus.upcoming) return;
                            context.read<BookingsBloc>().add(BookingCancelRequested(booking.backendId));
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBookingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96, height: 96,
              decoration: BoxDecoration(color: AppColors.primary.withAlpha(18), borderRadius: BorderRadius.circular(30)),
              child: const Icon(Icons.calendar_month_outlined, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text('No bookings found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
            const SizedBox(height: 8),
            const Text('Your service bookings will appear here.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, height: 1.45, color: Color(0xFF6B7280))),
          ],
        ),
      ),
    );
  }
}
