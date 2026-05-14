import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class CartPriceSummary extends StatelessWidget {
  const CartPriceSummary({
    super.key,
    required this.subTotal,
    required this.platformFee,
    required this.discount,
    required this.total,
  });

  final String subTotal;
  final String platformFee;
  final String discount;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SummaryRow(label: 'Sub Total', value: subTotal),
        const SizedBox(height: 12),
        _SummaryRow(label: 'Platform Fee', value: platformFee),
        const SizedBox(height: 12),
        _SummaryRow(
          label: 'Discount',
          value: discount,
          valueColor: const Color(0xFF16A34A),
        ),
        const SizedBox(height: 14),
        const Divider(color: Color(0xFFE5E7EB), thickness: 1),
        const SizedBox(height: 14),
        _SummaryRow(
          label: 'Total',
          value: total,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
          ),
          valueStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.labelStyle,
    this.valueStyle,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style:
                labelStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
          ),
        ),
        Text(
          value,
          style:
              valueStyle ??
              TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: valueColor ?? const Color(0xFF111827),
              ),
        ),
      ],
    );
  }
}
