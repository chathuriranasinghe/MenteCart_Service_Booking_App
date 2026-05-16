import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/constants/app_categories.dart';
import '../../../../app/routes/app_routes.dart';
import '../../bloc/services_bloc.dart';
import '../../../home/presentation/widgets/bottom_nav_bar.dart';
import '../widgets/service_filter_chip.dart';
import '../widgets/service_list_item.dart';
import '../widgets/services_header.dart';
import 'service_detail_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key, this.initialCategory, this.initialSearch});
  final String? initialCategory;
  final String? initialSearch;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _selectedCategoryIndex = 0;
  int _currentNavIndex = 1;
  bool _showSearch = false;
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    ...appCategories.map((c) => c.title),
  ];

  @override
  void initState() {
    super.initState();
    final initial = widget.initialCategory;
    if (initial != null) {
      final idx = _categories.indexOf(initial);
      if (idx != -1) _selectedCategoryIndex = idx;
    }
    if (widget.initialSearch != null) {
      _showSearch = true;
      _searchController.text = widget.initialSearch!;
    }
    _fetch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetch() {
    final selected = _categories[_selectedCategoryIndex];
    context.read<ServicesBloc>().add(
      ServicesFetchRequested(
        category: selected == 'All' ? null : selected,
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
      ),
    );
  }

  void _handleCategorySelected(int index) {
    setState(() => _selectedCategoryIndex = index);
    _fetch();
  }

  void _handleSearchSubmit(String _) => _fetch();

  void _handleServiceTap(ServiceItem service) {
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
    );
  }

  void _handleNavItemSelected(int index) {
    if (index == _currentNavIndex) return;
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: Column(
                children: [
                  ServicesHeader(
                    onSearchPressed: () => setState(() {
                      _showSearch = !_showSearch;
                      if (!_showSearch) {
                        _searchController.clear();
                        _fetch();
                      }
                    }),
                  ),
                  if (_showSearch) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      autofocus: true,
                      onSubmitted: _handleSearchSubmit,
                      decoration: InputDecoration(
                        hintText: 'Search services...',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: Color(0xFF6B7280),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send_rounded, size: 18),
                          onPressed: _fetch,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) => ServiceFilterChip(
                        title: _categories[index],
                        isSelected: _selectedCategoryIndex == index,
                        onTap: () => _handleCategorySelected(index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ServicesBloc, ServicesState>(
                builder: (context, state) {
                  if (state is ServicesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ServicesLoaded) {
                    if (state.services.isEmpty) {
                      final category = _categories[_selectedCategoryIndex];
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.search_off_rounded,
                              size: 52,
                              color: Color(0xFFD1D5DB),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              category == 'All'
                                  ? 'No services available'
                                  : 'No services found in "$category"',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Try selecting a different category',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                      itemCount: state.services.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final service = state.services[index];
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
