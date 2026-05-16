import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../bookings/data/booking_repository.dart';
import '../../../cart/bloc/cart_bloc.dart';
import '../../../cart/data/cart_repository.dart';
import '../../../profile/data/profile_repository.dart';
import '../../data/payhere_repository.dart';
import '../screens/payhere/payhere_webview_screen.dart';
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
  Map<String, dynamic>? _cart;

  String _addressTitle = 'Home';
  String _addressLine = 'No 25, Lake Road, Colombo 03, Sri Lanka';
  String _addressPhone = '+94 77 123 4567';

  final List<_PaymentMethod> _paymentMethods = const [
    _PaymentMethod(
      title: 'Credit / Debit Card',
      apiValue: 'card',
      subtitle: 'Pay securely using Visa or Mastercard',
      icon: Icons.credit_card_rounded,
    ),
    _PaymentMethod(
      title: 'Online Banking',
      apiValue: 'pay_on_arrival',
      subtitle: 'Pay using your bank account',
      icon: Icons.account_balance_rounded,
    ),
    _PaymentMethod(
      title: 'Cash on Service',
      apiValue: 'cash',
      subtitle: 'Pay after the service is completed',
      icon: Icons.payments_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadCart();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    try {
      final data = await ProfileRepository.getProfile();
      final addr = data['address'] as Map<String, dynamic>?;
      if (addr != null && mounted) {
        setState(() {
          _addressTitle = addr['label'] as String? ?? _addressTitle;
          _addressLine = addr['line'] as String? ?? _addressLine;
          _addressPhone = addr['phone'] as String? ?? _addressPhone;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadCart() async {
    try {
      final data = await CartRepository.getCart();
      if (mounted) setState(() => _cart = data);
    } catch (_) {}
  }

  void _handlePaymentSelected(int index) {
    setState(() {
      _selectedPaymentIndex = index;
    });
  }

  void _handleAddressChange() {
    final titleController = TextEditingController(text: _addressTitle);
    final addressController = TextEditingController(text: _addressLine);
    final phoneController = TextEditingController(text: _addressPhone);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          MediaQuery.of(ctx).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Edit Service Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 20),
            _AddressField(
              label: 'Label (e.g. Home, Office)',
              controller: titleController,
              icon: Icons.label_outline_rounded,
            ),
            const SizedBox(height: 14),
            _AddressField(
              label: 'Full Address',
              controller: addressController,
              icon: Icons.location_on_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 14),
            _AddressField(
              label: 'Phone Number',
              controller: phoneController,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (titleController.text.trim().isEmpty ||
                      addressController.text.trim().isEmpty ||
                      phoneController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields'),
                      ),
                    );
                    return;
                  }
                  try {
                    await ProfileRepository.updateProfile(
                      address: {
                        'label': titleController.text.trim(),
                        'line': addressController.text.trim(),
                        'phone': phoneController.text.trim(),
                      },
                    );
                    if (mounted) {
                      setState(() {
                        _addressTitle = titleController.text.trim();
                        _addressLine = addressController.text.trim();
                        _addressPhone = phoneController.text.trim();
                      });
                      Navigator.pop(ctx);
                    }
                  } on DioException catch (e) {
                    final msg =
                        e.response?.data?['message'] ??
                        'Failed to save address';
                    if (mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(msg.toString())));
                    }
                  }
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
                  'Save Address',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleConfirmPayment() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      final booking = await BookingRepository.checkout(
        _paymentMethods[_selectedPaymentIndex].apiValue,
      );
      if (!mounted) return;
      context.read<CartBloc>().add(CartFetchRequested());

      if (_paymentMethods[_selectedPaymentIndex].apiValue == 'card') {
        await _launchPayhereWebView(booking['bookingNumber'] as String);
      } else {
        _showPaymentSuccessDialog();
      }
    } on DioException catch (e) {
      if (!mounted) return;
      final msg = e.response?.data?['message'] ?? 'Checkout failed';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg.toString())));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _launchPayhereWebView(String bookingNumber) async {
    try {
      final params = await PayhereRepository.getCheckoutParams(bookingNumber);
      if (!mounted) return;

      final result = await Navigator.pushNamed(
        context,
        AppRoutes.payhereWebView,
        arguments: PayhereWebViewArgs(
          checkoutUrl: params['checkoutUrl'] as String,
          merchantId: params['merchantId'] as String,
          orderId: params['orderId'] as String,
          amount: params['amount'] as String,
          currency: params['currency'] as String,
          hash: params['hash'] as String,
          customerName: _addressTitle,
          customerEmail: '',
          customerPhone: _addressPhone,
        ),
      );

      if (!mounted) return;
      if (result == null || result.toString().contains('cancelled')) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment was cancelled.')));
      } else if (result.toString().contains('failed')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment failed. Please try again.')),
        );
      } else {
        // success or pending — navigate to bookings
        _showPaymentSuccessDialog();
      }
    } on DioException catch (e) {
      if (!mounted) return;
      final msg = e.response?.data?['message'] ?? 'Failed to load payment';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg.toString())));
    }
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
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.bookings,
                        (r) => false,
                      );
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

  String get _selectedPaymentTitle =>
      _paymentMethods[_selectedPaymentIndex].title;

  String _formatCurrency(num value) => 'Rs. ${value.toInt()}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      bottomNavigationBar: _CheckoutBottomBar(
        total: _cart != null
            ? _formatCurrency((_cart!['subTotal'] as num) + 50 - 100)
            : '—',
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
                      title: _addressTitle,
                      address: _addressLine,
                      phone: _addressPhone,
                      onChangePressed: _handleAddressChange,
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(title: 'Booking Summary'),

                    const SizedBox(height: 12),

                    if (_cart != null)
                      ...(_cart!['items'] as List<dynamic>).map(
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _BookingItemCard(
                            title: i['title'] as String,
                            dateTime:
                                '${i['selectedDate']}, ${i['selectedTime']}',
                            quantity: (i['quantity'] as num).toInt(),
                            price: _formatCurrency(i['total'] as num),
                          ),
                        ),
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

                    CheckoutSummaryCard(
                      subTotal: _cart != null
                          ? _formatCurrency(_cart!['subTotal'] as num)
                          : '—',
                      platformFee: 'Rs. 50',
                      discount: '- Rs. 100',
                      total: _cart != null
                          ? _formatCurrency(
                              (_cart!['subTotal'] as num) + 50 - 100,
                            )
                          : '—',
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
                mainAxisSize: MainAxisSize.min,
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
    required this.apiValue,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String apiValue;
  final String subtitle;
  final IconData icon;
}

class _AddressField extends StatelessWidget {
  const _AddressField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
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
