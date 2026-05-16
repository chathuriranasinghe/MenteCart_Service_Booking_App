import 'package:flutter/material.dart';

class ServicesHeader extends StatelessWidget {
  const ServicesHeader({super.key, this.onSearchPressed});

  final VoidCallback? onSearchPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'All Services',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
          ),
        ),
        IconButton(
          onPressed: onSearchPressed,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
          icon: const Icon(Icons.search_rounded, color: Color(0xFF111827), size: 22),
        ),
      ],
    );
  }
}
