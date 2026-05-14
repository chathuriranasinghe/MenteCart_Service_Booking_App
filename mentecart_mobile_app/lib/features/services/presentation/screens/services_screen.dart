import 'package:flutter/material.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../home/presentation/widgets/bottom_nav_bar.dart';
import '../widgets/service_filter_chip.dart';
import '../widgets/service_list_item.dart';
import '../widgets/service_listing_item.dart';
import '../widgets/services_header.dart';
import 'service_detail_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _selectedCategoryIndex = 0;
  int _currentNavIndex = 1;

  final List<String> _categories = const [
    'All',
    'Cleaning',
    'Plumbing',
    'Tutoring',
    'Beauty',
  ];

  final List<ServiceListingItem> _services = const [
    ServiceListingItem(
      title: 'Home Cleaning',
      category: 'Cleaning',
      description: 'Deep home cleaning by professionals',
      price: '₹699',
      duration: '60 min',
      rating: 4.6,
      reviewCount: 234,
      imageUrl:
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=600',
    ),
    ServiceListingItem(
      title: 'Plumbing Repair',
      category: 'Plumbing',
      description: 'Fix leaks, pipes and installations',
      price: '₹499',
      duration: '45 min',
      rating: 4.5,
      reviewCount: 180,
      imageUrl:
          'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?q=80&w=600',
    ),
    ServiceListingItem(
      title: 'Tutoring',
      category: 'Tutoring',
      description: '1-on-1 sessions for better learning',
      price: '₹399',
      duration: '60 min',
      rating: 4.7,
      reviewCount: 312,
      imageUrl:
          'https://images.unsplash.com/photo-1588072432836-e10032774350?q=80&w=600',
    ),
    ServiceListingItem(
      title: 'Beauty Appointment',
      category: 'Beauty',
      description: 'Salon and beauty care at your home',
      price: '₹799',
      duration: '90 min',
      rating: 4.4,
      reviewCount: 176,
      imageUrl:
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=600',
    ),
    ServiceListingItem(
      title: 'Office Cleaning',
      category: 'Cleaning',
      description: 'Professional cleaning for office spaces',
      price: '₹899',
      duration: '90 min',
      rating: 4.6,
      reviewCount: 128,
      imageUrl:
          'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?q=80&w=600',
    ),
  ];

  List<ServiceListingItem> get _filteredServices {
    final selected = _categories[_selectedCategoryIndex];
    if (selected == 'All') return _services;
    return _services.where((s) => s.category == selected).toList();
  }

  void _handleCategorySelected(int index) =>
      setState(() => _selectedCategoryIndex = index);

  void _handleFilterPressed() {}

  void _handleServiceTap(ServiceListingItem service) {
    Navigator.pushNamed(
      context,
      AppRoutes.serviceDetail,
      arguments: ServiceDetailArgs(
        title: service.title,
        description: service.description,
        price: service.price,
        duration: service.duration,
        rating: service.rating,
        reviewCount: service.reviewCount,
        imageUrl: service.imageUrl,
      ),
    );
  }

  void _handleNavItemSelected(int index) {
    if (index == _currentNavIndex) {
      return;
    }

    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
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
      _currentNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final services = _filteredServices;

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
                  ServicesHeader(onFilterPressed: _handleFilterPressed),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return ServiceFilterChip(
                          title: _categories[index],
                          isSelected: _selectedCategoryIndex == index,
                          onTap: () => _handleCategorySelected(index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                itemCount: services.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ServiceListItem(
                    title: service.title,
                    description: service.description,
                    price: service.price,
                    duration: service.duration,
                    rating: service.rating,
                    reviewCount: service.reviewCount,
                    imageUrl: service.imageUrl,
                    onTap: () => _handleServiceTap(service),
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
