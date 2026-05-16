part of 'services_bloc.dart';

abstract class ServicesEvent {}

class ServicesFetchRequested extends ServicesEvent {
  ServicesFetchRequested({this.category, this.search});
  final String? category;
  final String? search;
}
