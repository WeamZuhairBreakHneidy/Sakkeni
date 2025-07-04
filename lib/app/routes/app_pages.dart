import 'package:get/get.dart';
import 'package:test1/app/modules/addproperty/views/addmaininformation_veiw.dart';

import '../modules/addproperty/bindings/addproperty_binding.dart';
import '../modules/addproperty/views/addproperty_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/bindings/register_binding.dart';
import '../modules/auth/bindings/reset_password_binding.dart';
import '../modules/auth/bindings/update_profile_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/profile_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/reset_password_view.dart';
import '../modules/auth/views/update_profile_view.dart';
import '../modules/getstarted/views/getstarted_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/properties/bindings/properties_binding.dart';
import '../modules/properties/views/properties_view.dart';
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
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () =>  HomeView(),
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
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.PropertiesUnifiedView,
      page: () => PropertiesUnifiedView(),
      binding: PropertiesBinding(),
    ),

    GetPage(
      name: Routes.UPDATEPROFILE,
      page: () => UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: Routes.RESETPASSWORD,
      page: () => ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: Routes.VIEWHISTORY,
      page: () => HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.ADDPROPERTY,
      page: () =>  AddPropertyView(),
      binding: AddpropertyBinding(),
    ),  GetPage(
      name: _Paths.ADDMAINPROPERTY,
      page: () =>  AddmaininformationVeiw(),
      binding: AddpropertyBinding(),
    ),
  ];
}
