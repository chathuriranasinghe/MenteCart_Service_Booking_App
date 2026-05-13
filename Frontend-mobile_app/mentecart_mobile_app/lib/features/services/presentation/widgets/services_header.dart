import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class ServicesHeader extends StatelessWidget {
  const ServicesHeader({super.key, required this.onFilterPressed});

  final VoidCallback onFilterPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'All Services',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
        ),

        IconButton(
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
          icon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF111827),
            size: 22,
          ),
        ),

        const SizedBox(width: 10),

        IconButton(
          onPressed: onFilterPressed,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
          icon: const Icon(
            Icons.tune_rounded,
            color: AppColors.primary,
            size: 22,
          ),
        ),
      ],
    );
  }
}
