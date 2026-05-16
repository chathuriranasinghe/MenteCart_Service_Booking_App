import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/favorites_storage.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../home/presentation/widgets/bottom_nav_bar.dart';
import '../../data/profile_repository.dart';
import '../../../bookings/data/booking_repository.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 4;
  String _name = '';
  String _email = '';
  String _phone = '';
  int _totalBookings = 0;
  int _completedBookings = 0;
  int _savedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final results = await Future.wait([
        ProfileRepository.getProfile(),
        BookingRepository.getBookings(),
        FavoritesStorage.getIds(),
      ]);
      final data = results[0] as Map<String, dynamic>;
      final bookings = results[1] as List<dynamic>;
      final favIds = results[2] as List<String>;
      if (mounted) {
        setState(() {
          _name = data['fullName'] as String? ?? '';
          _email = data['email'] as String? ?? '';
          _phone = data['phoneNumber'] as String? ?? '';
          _totalBookings = bookings.length;
          _completedBookings = bookings
              .where((b) => b['status'] == 'completed')
              .length;
          _savedCount = favIds.length;
        });
      }
    } catch (_) {}
  }

  void _handleEditProfile() => _showEditProfileSheet();

  void _handleMenuTap(String menu) {
    if (menu == 'terms') {
      Navigator.pushNamed(context, AppRoutes.terms);
    } else if (menu == 'privacy') {
      Navigator.pushNamed(context, AppRoutes.privacyPolicy);
    } else if (menu == 'personal_information') {
      _showEditProfileSheet();
    } else {
      _showComingSoon(_menuLabel(menu));
    }
  }

  String _menuLabel(String menu) {
    switch (menu) {
      case 'saved_addresses': return 'Saved Addresses';
      case 'payment_methods': return 'Payment Methods';
      case 'notifications': return 'Notifications';
      case 'security': return 'Security';
      case 'help_support': return 'Help & Support';
      default: return menu;
    }
  }

  void _showComingSoon(String feature) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(14),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.construction_rounded, color: AppColors.primary, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              feature,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 8),
            const Text(
              'This feature is coming soon. We are working hard to bring it to you.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Got it', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileSheet() {
    final nameController = TextEditingController(text: _name);
    final phoneController = TextEditingController(text: _phone);
    bool isSaving = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24,
              MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
              ),
              const SizedBox(height: 20),
              _ProfileField(label: 'Full Name', controller: nameController, icon: Icons.person_outline_rounded),
              const SizedBox(height: 14),
              _ProfileField(label: 'Phone Number', controller: phoneController, icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
              const SizedBox(height: 6),
              Text(
                'Email cannot be changed.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isSaving ? null : () async {
                    setSheetState(() => isSaving = true);
                    try {
                      final data = await ProfileRepository.updateProfile(
                        fullName: nameController.text.trim(),
                        phoneNumber: phoneController.text.trim(),
                      );
                      if (mounted) {
                        setState(() {
                          _name = data['fullName'] as String? ?? _name;
                          _phone = data['phoneNumber'] as String? ?? _phone;
                        });
                        Navigator.pop(ctx);
                      }
                    } on DioException catch (e) {
                      final msg = e.response?.data?['message'] ?? 'Update failed';
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(msg.toString())),
                        );
                      }
                    } finally {
                      setSheetState(() => isSaving = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: const Color(0xFFB8C7F5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: isSaving
                      ? const SizedBox(width: 22, height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                      : const Text('Save Changes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              onPressed: () async {
                Navigator.pop(context);
                await AuthRepository.logout();
                if (!context.mounted) return;
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
                name: _name,
                email: _email,
                phoneNumber: _phone,
                totalBookings: _totalBookings,
                completedBookings: _completedBookings,
                savedCount: _savedCount,
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
    return const Text(
      'Profile',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: Color(0xFF111827),
      ),
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

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
