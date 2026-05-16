import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../bloc/cart_bloc.dart';
import '../../../home/presentation/widgets/bottom_nav_bar.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_price_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const int _platformFee = 50;
  static const int _discount = 100;

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(CartFetchRequested());
  }

  String _formatCurrency(int value) => 'Rs. $value';

  int _total(int subTotal) {
    final amount = subTotal + _platformFee - _discount;
    return amount < 0 ? 0 : amount;
  }

  void _handleNavItemSelected(int index) {
    if (index == 0) { Navigator.pushReplacementNamed(context, AppRoutes.home); return; }
    if (index == 1) { Navigator.pushReplacementNamed(context, AppRoutes.services); return; }
    if (index == 3) { Navigator.pushReplacementNamed(context, AppRoutes.bookings); return; }
    if (index == 4) { Navigator.pushReplacementNamed(context, AppRoutes.profile); return; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      bottomNavigationBar: HomeBottomNavBar(currentIndex: 2, onItemSelected: _handleNavItemSelected),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('My Cart', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.services),
                    style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.zero, minimumSize: const Size(0, 34), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: const Text('+ Add Services', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<CartBloc, CartState>(
                listener: (context, state) {
                  if (state is CartActionFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is CartLoaded) {
                    if (state.items.isEmpty) return _EmptyCartView();
                    final subTotal = state.subTotal;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                      child: Column(
                        children: [
                          ListView.separated(
                            itemCount: state.items.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = state.items[index];
                              return CartItemCard(
                                title: item.title,
                                dateTime: item.dateTime,
                                price: _formatCurrency(item.totalPrice),
                                quantity: item.quantity,
                                imageUrl: item.imageUrl,
                                onIncrement: () => context.read<CartBloc>().add(CartItemIncrementRequested(item.id, item.quantity)),
                                onDecrement: () => context.read<CartBloc>().add(CartItemDecrementRequested(item.id, item.quantity)),
                                onDelete: () => context.read<CartBloc>().add(CartItemRemoveRequested(item.id)),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE5E7EB))),
                            child: CartPriceSummary(
                              subTotal: _formatCurrency(subTotal),
                              platformFee: _formatCurrency(_platformFee),
                              discount: '- ${_formatCurrency(_discount)}',
                              total: _formatCurrency(_total(subTotal)),
                            ),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.checkout),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                              child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                            ),
                          ),
                        ],
                      ),
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

class _EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96, height: 96,
              decoration: BoxDecoration(color: AppColors.primary.withAlpha(18), borderRadius: BorderRadius.circular(30)),
              child: const Icon(Icons.shopping_cart_outlined, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text('Your cart is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
            const SizedBox(height: 8),
            const Text('Add services to your cart and book them easily.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, height: 1.45, color: Color(0xFF6B7280))),
          ],
        ),
      ),
    );
  }
}
