import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:test1/app/modules/auth/bindings/register_binding.dart';

import 'package:test1/app/modules/auth/views/register_view.dart';

import '../modules/auth/bindings/auth_binding.dart';

import '../modules/auth/views/auth_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static var INITIAL = FirebaseAuth.instance.currentUser == null ? Routes.AUTH : Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    //Auth
    GetPage(
      name: _Paths.AUTH,
      page: () =>  AuthView(),
      binding: AuthBinding(),
    ),
    //Auth.Register
    GetPage(
      name: Routes.REGISTER,
      page: () =>  RegisterView(),
      binding: RegisterBinding()
    ),



  ];
}
