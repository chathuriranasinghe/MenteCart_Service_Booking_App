class ServiceListingItem {
  const ServiceListingItem({
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
