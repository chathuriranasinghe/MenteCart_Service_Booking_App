import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/booking_repository.dart';

class BookingDetailScreen extends StatefulWidget {
  const BookingDetailScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  Map<String, dynamic>? _booking;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await BookingRepository.getBookingById(widget.bookingId);
      if (mounted) setState(() => _booking = data);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF111827)),
        ),
        title: const Text('Booking Detail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _booking == null
              ? const Center(child: Text('Booking not found'))
              : _BookingDetailBody(booking: _booking!),
    );
  }
}

class _BookingDetailBody extends StatelessWidget {
  const _BookingDetailBody({required this.booking});
  final Map<String, dynamic> booking;

  @override
  Widget build(BuildContext context) {
    final items = booking['items'] as List<dynamic>;
    final statusHistory = booking['statusHistory'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(children: [
            _InfoRow(label: 'Booking #', value: booking['bookingNumber'] as String),
            _InfoRow(label: 'Status', value: (booking['bookingStatus'] as String).toUpperCase()),
            _InfoRow(label: 'Payment', value: booking['paymentMethod'] as String),
            _InfoRow(label: 'Total', value: 'Rs. ${booking['totalAmount']}'),
          ]),
          const SizedBox(height: 20),
          const _SectionTitle(title: 'Services'),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _InfoCard(children: [
                  _InfoRow(label: 'Service', value: item['title'] as String),
                  _InfoRow(label: 'Date', value: item['selectedDate'] as String),
                  _InfoRow(label: 'Time', value: item['selectedTime'] as String),
                  _InfoRow(label: 'Qty', value: '${item['quantity']}'),
                  _InfoRow(label: 'Price', value: 'Rs. ${item['total']}'),
                ]),
              )),
          if (statusHistory.isNotEmpty) ...[
            const SizedBox(height: 20),
            const _SectionTitle(title: 'Status History'),
            const SizedBox(height: 10),
            _InfoCard(
              children: statusHistory.map<Widget>((h) => _InfoRow(
                    label: (h['status'] as String).toUpperCase(),
                    value: h['changedAt'] as String,
                  )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w600))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF111827), fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF111827)));
  }
}
