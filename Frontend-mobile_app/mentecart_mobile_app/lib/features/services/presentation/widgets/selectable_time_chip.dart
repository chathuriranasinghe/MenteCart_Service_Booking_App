import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class SelectableTimeChip extends StatelessWidget {
  const SelectableTimeChip({
    super.key,
    required this.time,
    required this.isSelected,
    required this.onTap,
    this.isDisabled = false,
  });

  final String time;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDisabled
        ? const Color(0xFFF3F4F6)
        : isSelected
        ? AppColors.primary
        : Colors.white;
    final textColor = isDisabled
        ? const Color(0xFFD1D5DB)
        : isSelected
        ? Colors.white
        : const Color(0xFF111827);
    final borderColor = isDisabled
        ? const Color(0xFFE5E7EB)
        : isSelected
        ? AppColors.primary
        : const Color(0xFFE5E7EB);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
