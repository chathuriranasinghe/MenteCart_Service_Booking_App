part of 'services_bloc.dart';

abstract class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  ServicesLoaded(this.services);
  final List<ServiceItem> services;
}

class ServicesFailure extends ServicesState {
  ServicesFailure(this.message);
  final String message;
}

class ServiceItem {
  const ServiceItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.duration,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String category;
  final String description;
  final String price;
  final String duration;
  final double rating;
  final int reviewCount;
  final String imageUrl;
}
