import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../bookings/data/booking_repository.dart';

/// Arguments passed to this screen via Navigator.pushNamed.
class PayhereWebViewArgs {
  const PayhereWebViewArgs({
    required this.checkoutUrl,
    required this.merchantId,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.hash,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
  });

  final String checkoutUrl;
  final String merchantId;
  final String orderId;
  final String amount;
  final String currency;
  final String hash;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
}

class PayhereWebViewScreen extends StatefulWidget {
  const PayhereWebViewScreen({super.key, required this.args});

  final PayhereWebViewArgs args;

  @override
  State<PayhereWebViewScreen> createState() => _PayhereWebViewScreenState();
}

class _PayhereWebViewScreenState extends State<PayhereWebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _resultHandled = false;

  // PayHere sandbox return/cancel/notify URLs — these are intercepted in the
  // WebView; the backend webhook handles the real notification separately.
  static const _returnUrl = 'https://mentecart.app/payment/return';
  static const _cancelUrl = 'https://mentecart.app/payment/cancel';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _loading = false),
          onNavigationRequest: _handleNavigation,
        ),
      )
      ..loadHtmlString(_buildCheckoutHtml());
  }

  NavigationDecision _handleNavigation(NavigationRequest request) {
    final url = request.url;
    if (url.startsWith(_returnUrl)) {
      _onPaymentReturn();
      return NavigationDecision.prevent;
    }
    if (url.startsWith(_cancelUrl)) {
      _onPaymentCancel();
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  /// PayHere redirects to return_url on success. We poll the booking until
  /// it transitions to confirmed/failed (webhook may arrive slightly after).
  Future<void> _onPaymentReturn() async {
    if (_resultHandled) return;
    _resultHandled = true;

    setState(() => _loading = true);

    const maxAttempts = 10;
    const delay = Duration(seconds: 2);

    for (var i = 0; i < maxAttempts; i++) {
      await Future<void>.delayed(delay);
      try {
        final bookings = await BookingRepository.getBookings();
        final match = bookings.firstWhere(
          (b) => b['bookingNumber'] == widget.args.orderId,
          orElse: () => null,
        );
        if (match != null) {
          final status = match['bookingStatus'] as String;
          if (status == 'confirmed') {
            _popWithResult(_PaymentResult.success);
            return;
          }
          if (status == 'failed' || status == 'cancelled') {
            _popWithResult(_PaymentResult.failed);
            return;
          }
        }
      } catch (_) {}
    }

    // Timed out — treat as pending; user can check bookings screen.
    _popWithResult(_PaymentResult.pending);
  }

  void _onPaymentCancel() {
    if (_resultHandled) return;
    _resultHandled = true;
    _popWithResult(_PaymentResult.cancelled);
  }

  void _popWithResult(_PaymentResult result) {
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  /// Builds a self-submitting HTML form that POSTs to the PayHere sandbox.
  String _buildCheckoutHtml() {
    final a = widget.args;
    final nameParts = a.customerName.trim().split(' ');
    final firstName = nameParts.first.isEmpty ? 'Customer' : nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : 'User';

    String field(String name, String value) =>
        '<input type="hidden" name="$name" value="${_esc(value)}">';

    return '''<!DOCTYPE html>
<html>
<head><meta name="viewport" content="width=device-width,initial-scale=1"></head>
<body onload="document.forms[0].submit()">
<form method="POST" action="${_esc(a.checkoutUrl)}">
  ${field('merchant_id', a.merchantId)}
  ${field('return_url', _returnUrl)}
  ${field('cancel_url', _cancelUrl)}
  ${field('notify_url', _notifyUrl())}
  ${field('order_id', a.orderId)}
  ${field('items', 'MenteCart Booking ${a.orderId}')}
  ${field('currency', a.currency)}
  ${field('amount', a.amount)}
  ${field('first_name', firstName)}
  ${field('last_name', lastName)}
  ${field('email', a.customerEmail.isEmpty ? 'customer@mentecart.app' : a.customerEmail)}
  ${field('phone', a.customerPhone)}
  ${field('address', 'Colombo')}
  ${field('city', 'Colombo')}
  ${field('country', 'Sri Lanka')}
  ${field('hash', a.hash)}
</form>
</body>
</html>''';
  }

  String _notifyUrl() {
    // For sandbox testing, PayHere validates notify_url against your registered
    // domain/app. Use your registered domain here, not a local IP.
    // PayHere sandbox does not actually POST to this URL during testing.
    return 'https://mentecart.app/api/v1/payhere/webhook';
  }

  String _esc(String v) => v
      .replaceAll('&', '&amp;')
      .replaceAll('"', '&quot;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Color(0xFF111827)),
          onPressed: _onPaymentCancel,
        ),
        title: const Text(
          'Secure Payment',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            const ColoredBox(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text(
                      'Connecting to PayHere…',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum _PaymentResult { success, failed, cancelled, pending }
