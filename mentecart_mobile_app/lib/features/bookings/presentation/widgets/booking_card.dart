import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../bloc/bookings_bloc.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.title,
    required this.bookingId,
    required this.dateTime,
    required this.address,
    required this.price,
    required this.status,
    required this.imageUrl,
    required this.onTap,
    required this.onPrimaryAction,
    required this.onSecondaryAction,
  });

  final String title;
  final String bookingId;
  final String dateTime;
  final String address;
  final String price;
  final BookingStatus status;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback onPrimaryAction;
  final VoidCallback onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    final statusStyle = _BookingStatusStyle.fromStatus(status);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imageUrl,
                      width: 82,
                      height: 86,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          width: 82,
                          height: 86,
                          color: const Color(0xFFEFF3FF),
                          child: const Icon(
                            Icons.home_repair_service_rounded,
                            color: AppColors.primary,
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: statusStyle.backgroundColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                statusStyle.title,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: statusStyle.textColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 5),

                        Text(
                          bookingId,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),

                        const SizedBox(height: 10),

                        _BookingInfoRow(
                          icon: Icons.schedule_rounded,
                          text: dateTime,
                        ),

                        const SizedBox(height: 6),

                        _BookingInfoRow(
                          icon: Icons.location_on_outlined,
                          text: address,
                        ),

                        const SizedBox(height: 10),

                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onSecondaryAction,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _secondaryButtonText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPrimaryAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _primaryButtonText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _primaryButtonText {
    switch (status) {
      case BookingStatus.upcoming:
        return 'Track';
      case BookingStatus.completed:
        return 'Book Again';
      case BookingStatus.cancelled:
        return 'Rebook';
    }
  }

  String get _secondaryButtonText {
    switch (status) {
      case BookingStatus.upcoming:
        return 'Cancel';
      case BookingStatus.completed:
        return 'Review';
      case BookingStatus.cancelled:
        return 'Details';
    }
  }
}

class _BookingInfoRow extends StatelessWidget {
  const _BookingInfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF6B7280)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }
}

class _BookingStatusStyle {
  const _BookingStatusStyle({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
  });

  final String title;
  final Color backgroundColor;
  final Color textColor;

  factory _BookingStatusStyle.fromStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return const _BookingStatusStyle(
          title: 'Upcoming',
          backgroundColor: Color(0xFFEFF3FF),
          textColor: AppColors.primary,
        );

      case BookingStatus.completed:
        return const _BookingStatusStyle(
          title: 'Completed',
          backgroundColor: Color(0xFFEFFDF5),
          textColor: Color(0xFF16A34A),
        );

      case BookingStatus.cancelled:
        return const _BookingStatusStyle(
          title: 'Cancelled',
          backgroundColor: Color(0xFFFEF2F2),
          textColor: Color(0xFFDC2626),
        );
    }
  }
}
