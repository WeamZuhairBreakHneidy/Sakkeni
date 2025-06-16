import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:test1/app/modules/Onboarding%20Screens/views/onboarding1_view.dart';

import '../modules/Onboarding Screens/bindings/onboarding_binding.dart';
import '../modules/Onboarding Screens/views/onboarding_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/bindings/register_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/getstarted/views/getstarted_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static var INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.GETSTARTED,
      page: () => const GetstartedView(),
      binding: HomeBinding(),
    ), GetPage(
      name: _Paths.Onboarding,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    //Auth
    GetPage(name: _Paths.AUTH, page: () => AuthView(), binding: AuthBinding()),
    //Auth.Register
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
