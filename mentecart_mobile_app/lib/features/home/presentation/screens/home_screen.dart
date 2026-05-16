import 'package:flutter/material.dart';
import 'package:mentecart_mobile_app/core/services/auth_storage.dart';
import 'package:mentecart_mobile_app/features/services/presentation/screens/service_detail_screen.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/favorites_storage.dart';
import '../../../../features/services/data/service_repository.dart';
import '../../../../features/services/presentation/screens/services_screen_args.dart';
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
  List<_ServiceItem> _services = [];
  List<_ServiceItem> _favoriteServices = [];
  Set<String> _favoriteIds = {};
  bool _isLoading = true;
  String _userName = '';

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

  @override
  void initState() {
    super.initState();
    _loadServices();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await AuthStorage.getName();
    if (mounted) setState(() => _userName = name ?? '');
  }

  Future<void> _loadServices() async {
    setState(() => _isLoading = true);
    try {
      final favIds = await FavoritesStorage.getIds();
      final favIdSet = favIds.toSet();

      final data = await ServiceRepository.getServices(limit: 2);
      final list = data['services'] as List<dynamic>;
      final items = list.map((s) => _ServiceItem(
            id: s['id'] as String,
            title: s['title'] as String,
            description: s['description'] as String,
            price: 'Rs. ${s['price']}',
            duration: '${s['duration']} min',
            rating: (s['rating'] ?? 4.5).toDouble(),
            reviewCount: (s['reviewCount'] ?? 0) as int,
            imageUrl: s['image'] as String,
          )).toList();

      List<_ServiceItem> favItems = [];
      if (favIdSet.isNotEmpty) {
        final favData = await ServiceRepository.getServices(limit: 50);
        final allList = favData['services'] as List<dynamic>;
        favItems = allList
            .where((s) => favIdSet.contains(s['id'] as String))
            .map((s) => _ServiceItem(
                  id: s['id'] as String,
                  title: s['title'] as String,
                  description: s['description'] as String,
                  price: 'Rs. ${s['price']}',
                  duration: '${s['duration']} min',
                  rating: (s['rating'] ?? 4.5).toDouble(),
                  reviewCount: (s['reviewCount'] ?? 0) as int,
                  imageUrl: s['image'] as String,
                ))
            .toList();
      }

      setState(() {
        _services = items;
        _favoriteServices = favItems;
        _favoriteIds = favIdSet;
      });
    } catch (_) {
      // keep empty list on error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite(String id) async {
    await FavoritesStorage.toggle(id);
    final updatedIds = await FavoritesStorage.getIds();
    final updatedSet = updatedIds.toSet();

    // rebuild favorites list from already-loaded services
    final allLoaded = [..._services, ..._favoriteServices];
    final seen = <String>{};
    final unique = allLoaded.where((s) => seen.add(s.id)).toList();
    final newFavItems = unique.where((s) => updatedSet.contains(s.id)).toList();

    setState(() {
      _favoriteIds = updatedSet;
      _favoriteServices = newFavItems;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    Navigator.pushNamed(
      context,
      AppRoutes.services,
      arguments: ServicesScreenArgs(search: q),
    );
  }

void _handleNavItemSelected(int index) {
    if (index == _currentIndex) return;

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

    setState(() => _currentIndex = index);
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
              HomeHeader(userName: _userName),
              const SizedBox(height: 24),
              HomeSearchBar(
                controller: _searchController,
                onSubmitted: _handleSearch,
              ),
              const SizedBox(height: 24),
              _SectionTitle(
                title: 'Categories',
                onViewAllPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.categories),
              ),
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
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.services,
                        arguments: category.title,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              _SectionTitle(
                title: 'Featured Services',
                onViewAllPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.services),
              ),
              const SizedBox(height: 14),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      itemCount: _services.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                          isFavorite: _favoriteIds.contains(service.id),
                          onFavoriteToggle: () => _toggleFavorite(service.id),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.serviceDetail,
                              arguments: ServiceDetailArgs(
                                id: service.id,
                                title: service.title,
                                description: service.description,
                                price: service.price,
                                duration: service.duration,
                                rating: service.rating,
                                reviewCount: service.reviewCount,
                                imageUrl: service.imageUrl,
                              ),
                            ).then((_) => _loadServices());
                          },
                        );
                      },
                    ),
              const SizedBox(height: 24),
              _SectionTitle(
                title: 'Favorite Services',
                onViewAllPressed: () {},
              ),
              const SizedBox(height: 14),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_favoriteServices.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.favorite_border_rounded,
                          size: 36, color: Color(0xFFD1D5DB)),
                      SizedBox(height: 10),
                      Text(
                        'No favorite services selected yet',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                )
              else
                GridView.builder(
                  itemCount: _favoriteServices.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 230,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    final service = _favoriteServices[index];
                    return ServiceCard(
                      title: service.title,
                      description: service.description,
                      price: service.price,
                      imageUrl: service.imageUrl,
                      isFavorite: true,
                      onFavoriteToggle: () => _toggleFavorite(service.id),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.serviceDetail,
                          arguments: ServiceDetailArgs(
                            id: service.id,
                            title: service.title,
                            description: service.description,
                            price: service.price,
                            duration: service.duration,
                            rating: service.rating,
                            reviewCount: service.reviewCount,
                            imageUrl: service.imageUrl,
                          ),
                        ).then((_) => _loadServices());
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
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String description;
  final String price;
  final String duration;
  final double rating;
  final int reviewCount;
  final String imageUrl;
}
