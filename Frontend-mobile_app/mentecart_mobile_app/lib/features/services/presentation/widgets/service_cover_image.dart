import 'package:flutter/material.dart';
import 'package:mentecart_mobile_app/app/theme/app_colors.dart';

class ServiceCoverImage extends StatelessWidget {
  const ServiceCoverImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              color: const Color(0xFFEFF3FF),
              child: const Center(
                child: Icon(
                  Icons.home_repair_service_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withAlpha(80),
                Colors.transparent,
                Colors.black.withAlpha(30),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
