import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/bookings/bloc/bookings_bloc.dart';
import '../../features/bookings/presentation/screens/booking_detail_screen.dart';
import '../../features/bookings/presentation/screens/bookings_screen.dart';
import '../../features/cart/bloc/cart_bloc.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/checkout/presentation/screens/payhere/payhere_webview_screen.dart';
import '../../features/home/presentation/screens/categories_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/privacy_policy_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/terms_screen.dart';
import '../../features/services/bloc/services_bloc.dart';
import '../../features/services/presentation/screens/services_screen_args.dart';
import '../../features/services/presentation/screens/service_detail_screen.dart';
import '../../features/services/presentation/screens/services_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  const RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (_) => AuthBloc(), child: const LoginScreen()),
        );

      case AppRoutes.signUp:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (_) => AuthBloc(), child: const SignUpScreen()),
        );

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.services:
        final args = settings.arguments;
        String? category;
        String? search;
        if (args is String) category = args;
        if (args is ServicesScreenArgs) {
          category = args.category;
          search = args.search;
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ServicesBloc(),
            child: ServicesScreen(initialCategory: category, initialSearch: search),
          ),
        );

      case AppRoutes.serviceDetail:
        final args = settings.arguments;
        if (args is ServiceDetailArgs) {
          return MaterialPageRoute(builder: (_) => ServiceDetailScreen(args: args));
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (_) => ServicesBloc(), child: const ServicesScreen()),
        );

      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case AppRoutes.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());

      case AppRoutes.payhereWebView:
        final args = settings.arguments as PayhereWebViewArgs;
        return MaterialPageRoute(
          builder: (_) => PayhereWebViewScreen(args: args),
          fullscreenDialog: true,
        );

      case AppRoutes.bookings:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (_) => BookingsBloc(), child: const BookingsScreen()),
        );

      case AppRoutes.bookingDetail:
        final id = settings.arguments as String?;
        if (id != null) {
          return MaterialPageRoute(builder: (_) => BookingDetailScreen(bookingId: id));
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (_) => BookingsBloc(), child: const BookingsScreen()),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case AppRoutes.categories:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());

      case AppRoutes.terms:
        return MaterialPageRoute(builder: (_) => const TermsScreen());

      case AppRoutes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
