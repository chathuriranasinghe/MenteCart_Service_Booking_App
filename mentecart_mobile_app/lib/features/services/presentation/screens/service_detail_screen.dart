import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../cart/data/cart_repository.dart';
import '../../../../core/services/favorites_storage.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/compact_calendar.dart';
import '../widgets/section_title.dart';
import '../widgets/selectable_time_chip.dart';
import '../widgets/service_cover_image.dart';
import '../widgets/service_detail_bottom_bar.dart';
import '../widgets/service_info_chip.dart';
import '../widgets/service_title_section.dart';

class ServiceDetailArgs {
  const ServiceDetailArgs({
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

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({super.key, required this.args});

  final ServiceDetailArgs args;

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  DateTime _selectedDate = DateTime.now();
  int _selectedTimeIndex = -1;
  bool _isAddingToCart = false;
  bool _isFavorite = false;

  final List<String> _allTimes = const [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
  ];

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  bool _isTimePast(String time) {
    final now = DateTime.now();
    final isToday = _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
    if (!isToday) return false;

    final parts = time.split(RegExp(r'[:.\s]+'));
    if (parts.length < 3) return false;
    int hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final period = parts[2].toUpperCase();
    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    return DateTime(now.year, now.month, now.day, hour, minute).isBefore(now);
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedTimeIndex = -1;
    });
  }

  void _handleTimeSelected(int index) =>
      setState(() => _selectedTimeIndex = index);

  Future<void> _handleAddToCart() async {
    if (_selectedTimeIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time')),
      );
      return;
    }

    setState(() => _isAddingToCart = true);
    try {
      await CartRepository.addItem(
        serviceId: widget.args.id,
        selectedDate: _dateKey(_selectedDate),
        selectedTime: _allTimes[_selectedTimeIndex],
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.args.title} added to cart'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'View Cart',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
        ),
      );
    } on DioException catch (e) {
      if (!mounted) return;
      final msg = e.response?.data?['message'] ?? 'Failed to add to cart';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg.toString())));
    } finally {
      if (mounted) setState(() => _isAddingToCart = false);
    }
  }

  void _handleViewCart() => Navigator.pushNamed(context, AppRoutes.cart);

  @override
  void initState() {
    super.initState();
    FavoritesStorage.isFavorite(widget.args.id).then(
      (v) { if (mounted) setState(() => _isFavorite = v); },
    );
  }

  Future<void> _handleFavorite() async {
    await FavoritesStorage.toggle(widget.args.id);
    if (mounted) setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      bottomNavigationBar: ServiceDetailBottomBar(
        price: args.price,
        onViewCartPressed: _handleViewCart,
        onAddToCartPressed: _isAddingToCart ? () {} : _handleAddToCart,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 310,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: CircleIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: CircleIconButton(
                  icon: _isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  onTap: _handleFavorite,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ServiceCoverImage(imageUrl: args.imageUrl),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -22, 0),
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ServiceTitleSection(args: args),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ServiceInfoChip(
                          icon: Icons.schedule_rounded,
                          title: args.duration,
                          subtitle: 'Duration',
                        ),
                        const SizedBox(width: 10),
                        const ServiceInfoChip(
                          icon: Icons.home_repair_service_rounded,
                          title: 'Professional',
                          subtitle: 'Equipment',
                        ),
                        const SizedBox(width: 10),
                        const ServiceInfoChip(
                          icon: Icons.verified_user_rounded,
                          title: 'Verified',
                          subtitle: 'Experts',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'About service'),
                    const SizedBox(height: 10),
                    Text(
                      args.description,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.55,
                        color: Color(0xFF4B5563),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SectionTitle(title: 'Select Date'),
                    const SizedBox(height: 8),
                    CompactCalendar(
                      selectedDate: _selectedDate,
                      firstDate: DateTime(today.year, today.month, today.day),
                      lastDate:
                          DateTime(today.year + 1, today.month, today.day),
                      onDateSelected: _handleDateSelected,
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'Available Time Slots'),
                    const SizedBox(height: 14),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.2,
                      ),
                      itemCount: _allTimes.length,
                      itemBuilder: (context, index) {
                        final time = _allTimes[index];
                        final isDisabled = _isTimePast(time);
                        return SelectableTimeChip(
                          time: time,
                          isSelected: _selectedTimeIndex == index,
                          isDisabled: isDisabled,
                          onTap: isDisabled
                              ? () {}
                              : () => _handleTimeSelected(index),
                        );
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
