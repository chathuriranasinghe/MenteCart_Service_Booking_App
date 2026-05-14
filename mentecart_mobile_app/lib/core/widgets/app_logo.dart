import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../constants/app_assets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(18),
      child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
    );
  }
}
