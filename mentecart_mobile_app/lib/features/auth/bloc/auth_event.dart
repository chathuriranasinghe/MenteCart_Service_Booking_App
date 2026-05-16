part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  AuthLoginRequested({required this.email, required this.password});
  final String email;
  final String password;
}

class AuthRegisterRequested extends AuthEvent {
  AuthRegisterRequested({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
}

class AuthLogoutRequested extends AuthEvent {}
