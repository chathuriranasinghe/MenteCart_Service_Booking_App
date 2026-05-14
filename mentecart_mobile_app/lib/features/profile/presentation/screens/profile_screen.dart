import 'package:flutter/material.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../home/presentation/widgets/bottom_nav_bar.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 4;

  void _handleEditProfile() {}

  void _handleMenuTap(String menu) {}

  void _handleLogout() {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: const Text(
            'Are you sure you want to logout from your account?',
            style: TextStyle(height: 1.4, color: Color(0xFF4B5563)),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6B7280),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleNavItemSelected(int index) {
    if (index == _currentNavIndex) return;

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
    if (index == 3) {
      Navigator.pushReplacementNamed(context, AppRoutes.bookings);
      return;
    }

    setState(() => _currentNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentNavIndex,
        onItemSelected: _handleNavItemSelected,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProfileHeader(),

              const SizedBox(height: 20),

              ProfileHeaderCard(
                name: 'John Doe',
                email: 'john.doe@email.com',
                phoneNumber: '+94 77 123 4567',
                onEditPressed: _handleEditProfile,
              ),

              const SizedBox(height: 24),

              const _SectionTitle(title: 'Account'),

              const SizedBox(height: 12),

              _MenuGroup(
                children: [
                  ProfileMenuItem(
                    title: 'Personal Information',
                    subtitle: 'Update your name, email and phone number',
                    icon: Icons.person_outline_rounded,
                    onTap: () => _handleMenuTap('personal_information'),
                  ),
                  ProfileMenuItem(
                    title: 'Saved Addresses',
                    subtitle: 'Manage your service locations',
                    icon: Icons.location_on_outlined,
                    onTap: () => _handleMenuTap('saved_addresses'),
                  ),
                  ProfileMenuItem(
                    title: 'Payment Methods',
                    subtitle: 'Cards, banking and payment preferences',
                    icon: Icons.credit_card_rounded,
                    onTap: () => _handleMenuTap('payment_methods'),
                    showDivider: false,
                  ),
                ],
              ),

              const SizedBox(height: 22),

              const _SectionTitle(title: 'Preferences'),

              const SizedBox(height: 12),

              _MenuGroup(
                children: [
                  ProfileMenuItem(
                    title: 'Notifications',
                    subtitle: 'Booking alerts and app updates',
                    icon: Icons.notifications_none_rounded,
                    onTap: () => _handleMenuTap('notifications'),
                  ),
                  ProfileMenuItem(
                    title: 'Security',
                    subtitle: 'Password and account security',
                    icon: Icons.lock_outline_rounded,
                    onTap: () => _handleMenuTap('security'),
                  ),
                  ProfileMenuItem(
                    title: 'Help & Support',
                    subtitle: 'FAQs, contact support and feedback',
                    icon: Icons.support_agent_rounded,
                    onTap: () => _handleMenuTap('help_support'),
                    showDivider: false,
                  ),
                ],
              ),

              const SizedBox(height: 22),

              const _SectionTitle(title: 'More'),

              const SizedBox(height: 12),

              _MenuGroup(
                children: [
                  ProfileMenuItem(
                    title: 'Terms & Conditions',
                    subtitle: 'Read app usage terms',
                    icon: Icons.description_outlined,
                    onTap: () => _handleMenuTap('terms'),
                  ),
                  ProfileMenuItem(
                    title: 'Privacy Policy',
                    subtitle: 'View privacy and data policy',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () => _handleMenuTap('privacy'),
                  ),
                  ProfileMenuItem(
                    title: 'Logout',
                    subtitle: 'Sign out from your account',
                    icon: Icons.logout_rounded,
                    isDanger: true,
                    onTap: _handleLogout,
                    showDivider: false,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              const Center(
                child: Text(
                  'MenteCart v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Profile',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
          icon: const Icon(
            Icons.settings_outlined,
            color: Color(0xFF111827),
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w900,
        color: Color(0xFF111827),
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(children: children),
      ),
    );
  }
}
