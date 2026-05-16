import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                      'Privacy Policy',
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
                    title: '1. Information We Collect',
                    body:
                        'We collect information you provide when registering, such as your name, email address, and phone number. We also collect usage data, device information, and location data when you use our services.',
                  ),
                  _Section(
                    title: '2. How We Use Your Information',
                    body:
                        'Your information is used to process bookings, personalise your experience, send service updates and notifications, and improve our platform. We do not sell your personal data to third parties.',
                  ),
                  _Section(
                    title: '3. Data Sharing',
                    body:
                        'We may share your information with service providers who assist in delivering bookings. All third parties are required to handle your data securely and in accordance with applicable privacy laws.',
                  ),
                  _Section(
                    title: '4. Data Security',
                    body:
                        'We implement industry-standard security measures including encryption and secure storage to protect your personal information from unauthorised access, disclosure, or misuse.',
                  ),
                  _Section(
                    title: '5. Cookies & Tracking',
                    body:
                        'Our app may use analytics tools to understand usage patterns and improve performance. No personally identifiable information is shared with analytics providers beyond what is necessary.',
                  ),
                  _Section(
                    title: '6. Your Rights',
                    body:
                        'You have the right to access, correct, or delete your personal data at any time. You may also withdraw consent for data processing by contacting us or deleting your account through the app.',
                  ),
                  _Section(
                    title: '7. Retention',
                    body:
                        'We retain your data for as long as your account is active or as needed to provide services. Upon account deletion, your data will be removed within 30 days, except where retention is required by law.',
                  ),
                  _Section(
                    title: '8. Changes to This Policy',
                    body:
                        'We may update this Privacy Policy from time to time. We will notify you of significant changes via the app or email. Continued use of MenteCart after changes constitutes acceptance.',
                  ),
                  _Section(
                    title: '9. Contact Us',
                    body:
                        'For any privacy-related questions or requests, please contact our Data Protection team at privacy@mentecart.com.',
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
