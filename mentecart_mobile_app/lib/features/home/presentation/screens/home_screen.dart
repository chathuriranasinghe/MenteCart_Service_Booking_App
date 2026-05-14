import 'package:flutter/material.dart';
import 'package:mentecart_mobile_app/features/services/presentation/screens/service_detail_screen.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/category_card.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/service_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  int _currentIndex = 0;

  final List<_CategoryItem> _categories = const [
    _CategoryItem(
      title: 'Cleaning',
      icon: Icons.cleaning_services_rounded,
      color: Color(0xFFEFF3FF),
    ),
    _CategoryItem(
      title: 'Plumbing',
      icon: Icons.plumbing_rounded,
      color: Color(0xFFEAF8FF),
    ),
    _CategoryItem(
      title: 'Tutoring',
      icon: Icons.menu_book_rounded,
      color: Color(0xFFEFFBF1),
    ),
    _CategoryItem(
      title: 'Beauty',
      icon: Icons.spa_rounded,
      color: Color(0xFFFFEFF5),
    ),
  ];

  final List<_ServiceItem> _services = const [
    _ServiceItem(
      title: 'Home Cleaning',
      description: 'Professional home cleaning service',
      price: '₹699',
      imageUrl:
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=600',
    ),
    _ServiceItem(
      title: 'Plumbing Repair',
      description: 'Fix leaks, pipes and installations',
      price: '₹499',
      imageUrl:
          'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?q=80&w=600',
    ),
    _ServiceItem(
      title: 'Tutoring',
      description: 'Expert tutors for all subjects',
      price: '₹399',
      imageUrl:
          'https://images.unsplash.com/photo-1588072432836-e10032774350?q=80&w=600',
    ),
    _ServiceItem(
      title: 'Beauty Appointment',
      description: 'Salon and beauty care at home',
      price: '₹799',
      imageUrl:
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=600',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleFilterPressed() {
    // TODO: Open filter bottom sheet.
  }

  void _handleNavItemSelected(int index) {
    if (index == _currentIndex) {
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

    if (index == 4) {
      Navigator.pushReplacementNamed(context, AppRoutes.profile);
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentIndex,
        onItemSelected: _handleNavItemSelected,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),

              const SizedBox(height: 24),

              HomeSearchBar(
                controller: _searchController,
                onFilterPressed: _handleFilterPressed,
              ),

              const SizedBox(height: 24),

              _SectionTitle(title: 'Categories', onViewAllPressed: () {}),

              const SizedBox(height: 14),

              SizedBox(
                height: 98,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final category = _categories[index];

                    return CategoryCard(
                      title: category.title,
                      icon: category.icon,
                      backgroundColor: category.color,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              _SectionTitle(
                title: 'Featured Services',
                onViewAllPressed: () {},
              ),

              const SizedBox(height: 14),

              GridView.builder(
                itemCount: _services.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 230,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemBuilder: (context, index) {
                  final service = _services[index];

                  return ServiceCard(
                    title: service.title,
                    description: service.description,
                    price: service.price,
                    imageUrl: service.imageUrl,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.serviceDetail,
                        arguments: ServiceDetailArgs(
                          title: service.title,
                          description: service.description,
                          price: service.price,
                          duration: '60 min',
                          rating: 4.6,
                          reviewCount: 234,
                          imageUrl: service.imageUrl,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.onViewAllPressed});

  final String title;
  final VoidCallback onViewAllPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
        ),
        TextButton(
          onPressed: onViewAllPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'View all',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _CategoryItem {
  const _CategoryItem({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;
}

class _ServiceItem {
  const _ServiceItem({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  final String title;
  final String description;
  final String price;
  final String imageUrl;
}
