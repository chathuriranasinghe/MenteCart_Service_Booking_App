import 'package:flutter/material.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../home/presentation/widgets/bottom_nav_bar.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_price_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _currentNavIndex = 2;

  final List<_CartItem> _cartItems = [
    _CartItem(
      id: '1',
      title: 'Home Cleaning',
      dateTime: '20 May 2025, 11.00 AM',
      unitPrice: 699,
      quantity: 1,
      imageUrl:
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=600',
    ),
    _CartItem(
      id: '2',
      title: 'Plumbing Repair',
      dateTime: '21 May 2025, 02.00 PM',
      unitPrice: 499,
      quantity: 1,
      imageUrl:
          'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?q=80&w=600',
    ),
    _CartItem(
      id: '3',
      title: 'Tutoring',
      dateTime: '22 May 2025, 06.00 PM',
      unitPrice: 399,
      quantity: 2,
      imageUrl:
          'https://images.unsplash.com/photo-1588072432836-e10032774350?q=80&w=600',
    ),
    _CartItem(
      id: '4',
      title: 'Beauty Appointment',
      dateTime: '23 May 2025, 04.00 PM',
      unitPrice: 799,
      quantity: 1,
      imageUrl:
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=600',
    ),
  ];

  int get _subTotal {
    return _cartItems.fold(0, (total, item) => total + item.totalPrice);
  }

  int get _platformFee {
    if (_cartItems.isEmpty) {
      return 0;
    }

    return 50;
  }

  int get _discount {
    if (_cartItems.isEmpty) {
      return 0;
    }

    return 100;
  }

  int get _total {
    final amount = _subTotal + _platformFee - _discount;

    if (amount < 0) {
      return 0;
    }

    return amount;
  }

  String _formatCurrency(int value) {
    return '₹$value';
  }

  void _incrementQuantity(String id) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.id == id);

      if (index == -1) {
        return;
      }

      final item = _cartItems[index];

      _cartItems[index] = item.copyWith(quantity: item.quantity + 1);
    });
  }

  void _decrementQuantity(String id) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.id == id);

      if (index == -1) {
        return;
      }

      final item = _cartItems[index];

      if (item.quantity <= 1) {
        return;
      }

      _cartItems[index] = item.copyWith(quantity: item.quantity - 1);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == id);
    });
  }

  void _handleAddServices() {
    Navigator.pushReplacementNamed(context, AppRoutes.services);
  }

  void _handleCheckout() {
    if (_cartItems.isEmpty) {
      return;
    }

    // TODO: Navigate to checkout screen after creating checkout page.
  }

  void _handleNavItemSelected(int index) {
    if (index == _currentNavIndex) {
      return;
    }

    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      return;
    }

    if (index == 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.services);
      return;
    }

    setState(() {
      _currentNavIndex = index;
    });

    // TODO: Add navigation for Bookings and Profile after creating those screens.
  }

  @override
  Widget build(BuildContext context) {
    final isCartEmpty = _cartItems.isEmpty;

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
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: _CartHeader(onAddServices: _handleAddServices),
            ),

            Expanded(
              child: isCartEmpty
                  ? const _EmptyCartView()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                      child: Column(
                        children: [
                          ListView.separated(
                            itemCount: _cartItems.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, __) {
                              return const SizedBox(height: 12);
                            },
                            itemBuilder: (context, index) {
                              final item = _cartItems[index];

                              return CartItemCard(
                                title: item.title,
                                dateTime: item.dateTime,
                                price: _formatCurrency(item.totalPrice),
                                quantity: item.quantity,
                                imageUrl: item.imageUrl,
                                onIncrement: () => _incrementQuantity(item.id),
                                onDecrement: () => _decrementQuantity(item.id),
                                onDelete: () => _deleteItem(item.id),
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: CartPriceSummary(
                              subTotal: _formatCurrency(_subTotal),
                              platformFee: _formatCurrency(_platformFee),
                              discount: '- ${_formatCurrency(_discount)}',
                              total: _formatCurrency(_total),
                            ),
                          ),

                          const SizedBox(height: 22),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _handleCheckout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Proceed to Checkout',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.onAddServices});

  final VoidCallback onAddServices;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'My Cart',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
        ),
        TextButton(
          onPressed: onAddServices,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 34),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            '+ Add Services',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(18),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add services to your cart and book them easily.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItem {
  const _CartItem({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.unitPrice,
    required this.quantity,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String dateTime;
  final int unitPrice;
  final int quantity;
  final String imageUrl;

  int get totalPrice => unitPrice * quantity;

  _CartItem copyWith({
    String? id,
    String? title,
    String? dateTime,
    int? unitPrice,
    int? quantity,
    String? imageUrl,
  }) {
    return _CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
