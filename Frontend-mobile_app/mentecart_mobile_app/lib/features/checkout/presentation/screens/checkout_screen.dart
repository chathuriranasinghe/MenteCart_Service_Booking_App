import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../widgets/checkout_address_card.dart';
import '../widgets/checkout_payment_method_card.dart';
import '../widgets/checkout_summary_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentIndex = 0;
  bool _isProcessing = false;

  final List<_PaymentMethod> _paymentMethods = const [
    _PaymentMethod(
      title: 'Credit / Debit Card',
      subtitle: 'Pay securely using Visa or Mastercard',
      icon: Icons.credit_card_rounded,
    ),
    _PaymentMethod(
      title: 'Online Banking',
      subtitle: 'Pay using your bank account',
      icon: Icons.account_balance_rounded,
    ),
    _PaymentMethod(
      title: 'Cash on Service',
      subtitle: 'Pay after the service is completed',
      icon: Icons.payments_outlined,
    ),
  ];

  void _handlePaymentSelected(int index) {
    setState(() {
      _selectedPaymentIndex = index;
    });
  }

  void _handleAddressChange() {
    // TODO: Navigate to address selection screen.
  }

  Future<void> _handleConfirmPayment() async {
    if (_isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    _showPaymentSuccessDialog();
  }

  void _showPaymentSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFFDF5),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 48,
                    color: Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Booking Confirmed',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your service booking has been placed successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String get _selectedPaymentTitle {
    return _paymentMethods[_selectedPaymentIndex].title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      bottomNavigationBar: _CheckoutBottomBar(
        total: '₹2,646',
        isProcessing: _isProcessing,
        onConfirmPressed: _handleConfirmPayment,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _CheckoutHeader(onBackPressed: () => Navigator.pop(context)),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckoutAddressCard(
                      title: 'Home',
                      address: 'No 25, Lake Road, Colombo 03, Sri Lanka',
                      phone: '+94 77 123 4567',
                      onChangePressed: _handleAddressChange,
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(title: 'Booking Summary'),

                    const SizedBox(height: 12),

                    const _BookingItemCard(
                      title: 'Home Cleaning',
                      dateTime: '20 May 2025, 11.00 AM',
                      quantity: 1,
                      price: '₹699',
                    ),

                    const SizedBox(height: 10),

                    const _BookingItemCard(
                      title: 'Plumbing Repair',
                      dateTime: '21 May 2025, 02.00 PM',
                      quantity: 1,
                      price: '₹499',
                    ),

                    const SizedBox(height: 10),

                    const _BookingItemCard(
                      title: 'Tutoring',
                      dateTime: '22 May 2025, 06.00 PM',
                      quantity: 2,
                      price: '₹798',
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(title: 'Payment Method'),

                    const SizedBox(height: 12),

                    ListView.separated(
                      itemCount: _paymentMethods.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) {
                        return const SizedBox(height: 12);
                      },
                      itemBuilder: (context, index) {
                        final method = _paymentMethods[index];

                        return CheckoutPaymentMethodCard(
                          title: method.title,
                          subtitle: method.subtitle,
                          icon: method.icon,
                          isSelected: _selectedPaymentIndex == index,
                          onTap: () => _handlePaymentSelected(index),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(title: 'Payment Summary'),

                    const SizedBox(height: 12),

                    const CheckoutSummaryCard(
                      subTotal: '₹2,795',
                      platformFee: '₹50',
                      discount: '- ₹199',
                      total: '₹2,646',
                    ),

                    const SizedBox(height: 14),

                    _SecurePaymentNote(paymentMethod: _selectedPaymentTitle),

                    const SizedBox(height: 96),
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

class _CheckoutHeader extends StatelessWidget {
  const _CheckoutHeader({required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackPressed,
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Color(0xFF111827),
            ),
          ),
          const Expanded(
            child: Text(
              'Checkout',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _BookingItemCard extends StatelessWidget {
  const _BookingItemCard({
    required this.title,
    required this.dateTime,
    required this.quantity,
    required this.price,
  });

  final String title;
  final String dateTime;
  final int quantity;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.home_repair_service_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title x$quantity',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateTime,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurePaymentNote extends StatelessWidget {
  const _SecurePaymentNote({required this.paymentMethod});

  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'You selected $paymentMethod. Your booking details are securely processed.',
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutBottomBar extends StatelessWidget {
  const _CheckoutBottomBar({
    required this.total,
    required this.isProcessing,
    required this.onConfirmPressed,
  });

  final String total;
  final bool isProcessing;
  final VoidCallback onConfirmPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            SizedBox(
              width: 105,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    total,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: isProcessing ? null : onConfirmPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: const Color(0xFFB8C7F5),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isProcessing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Confirm Payment',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
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

class _PaymentMethod {
  const _PaymentMethod({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
