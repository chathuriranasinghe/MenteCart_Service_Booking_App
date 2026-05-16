import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/service_repository.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  ServicesBloc() : super(ServicesInitial()) {
    on<ServicesFetchRequested>(_onFetch);
  }

  Future<void> _onFetch(ServicesFetchRequested event, Emitter<ServicesState> emit) async {
    emit(ServicesLoading());
    try {
      final data = await ServiceRepository.getServices(
        category: event.category,
        search: event.search,
      );
      final list = data['services'] as List<dynamic>;
      final items = list.map((s) => ServiceItem(
            id: s['id'] as String,
            title: s['title'] as String,
            category: s['category'] as String,
            description: s['description'] as String,
            price: 'Rs. ${s['price']}',
            duration: '${s['duration']} min',
            rating: (s['rating'] ?? 4.5).toDouble(),
            reviewCount: (s['reviewCount'] ?? 0) as int,
            imageUrl: s['image'] as String,
          )).toList();
      emit(ServicesLoaded(items));
    } catch (_) {
      emit(ServicesFailure('Failed to load services'));
    }
  }
}
