import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF111827)),
                  ),
                  const Expanded(
                    child: Text(
                      'Terms & Conditions',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
                children: const [
                  _LastUpdated(date: 'January 1, 2025'),
                  SizedBox(height: 20),
                  _Section(
                    title: '1. Acceptance of Terms',
                    body:
                        'By accessing or using MenteCart, you agree to be bound by these Terms & Conditions. If you do not agree to any part of these terms, you may not use our services.',
                  ),
                  _Section(
                    title: '2. Use of Services',
                    body:
                        'MenteCart provides a platform to browse, book, and manage home and personal services. You agree to use the platform only for lawful purposes and in a manner that does not infringe the rights of others.',
                  ),
                  _Section(
                    title: '3. Account Registration',
                    body:
                        'You must create an account to book services. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
                  ),
                  _Section(
                    title: '4. Bookings & Payments',
                    body:
                        'All bookings are subject to availability. Payments must be completed at the time of booking or upon arrival as selected. MenteCart reserves the right to cancel bookings in cases of fraud or policy violations.',
                  ),
                  _Section(
                    title: '5. Cancellations & Refunds',
                    body:
                        'You may cancel a booking before the scheduled time. Refund eligibility depends on the cancellation policy applicable to the specific service. Please review the service details before booking.',
                  ),
                  _Section(
                    title: '6. Limitation of Liability',
                    body:
                        'MenteCart is not liable for any indirect, incidental, or consequential damages arising from the use of our platform or services provided by third-party professionals.',
                  ),
                  _Section(
                    title: '7. Changes to Terms',
                    body:
                        'We reserve the right to update these Terms & Conditions at any time. Continued use of the app after changes constitutes your acceptance of the revised terms.',
                  ),
                  _Section(
                    title: '8. Contact Us',
                    body:
                        'If you have any questions about these Terms & Conditions, please contact us at support@mentecart.com.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastUpdated extends StatelessWidget {
  const _LastUpdated({required this.date});
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            'Last updated: $date',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(fontSize: 13, height: 1.6, color: Color(0xFF4B5563), fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
