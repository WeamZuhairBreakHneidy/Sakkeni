import 'package:get/get.dart';

import '../modules/PropertyDetails/bindings/property_details_binding.dart';
import '../modules/PropertyDetails/views/property_details_view.dart';
import '../modules/addproperty/bindings/add_property_binding.dart';
import '../modules/addproperty/views/add_main_information_view.dart';
import '../modules/addproperty/views/add_property_view.dart';
import '../modules/addproperty/views/apartment_for_rent_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/bindings/register_binding.dart';
import '../modules/auth/bindings/reset_password_binding.dart';
import '../modules/auth/bindings/update_profile_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/profile_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/reset_password_view.dart';
import '../modules/auth/views/update_profile_view.dart';
import '../modules/conversation/bindings/conversation_binding.dart';
import '../modules/conversation/views/conversation_view.dart';
import '../modules/customMap/bindings/custom_map_binding.dart';
import '../modules/customMap/views/custom_map_view.dart';
import '../modules/editService/bindings/edit_service_binding.dart';
import '../modules/editService/views/edit_service_view.dart';
import '../modules/favorite/bindings/favorite_binding.dart';
import '../modules/favorite/views/favorite_view.dart';

import '../modules/historyOptions/bindings/history_options_binding.dart';
import '../modules/historyOptions/views/history_options_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/myProperties/bindings/my_properties_binding.dart';
import '../modules/myProperties/views/my_properties_view.dart';
import '../modules/myServices/bindings/my_services_binding.dart';
import '../modules/myServices/bindings/my_services_binding.dart';
import '../modules/myServices/bindings/provider_quotes_binding.dart';
import '../modules/myServices/views/my_services_view.dart';
import '../modules/myServices/views/my_services_view.dart';
import '../modules/myServices/views/provider_quotes_view.dart';

import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/properties/bindings/properties_binding.dart';
import '../modules/properties/views/properties_view.dart';
import '../modules/serviceProviders/bindings/provider_details_binding.dart';
import '../modules/serviceProviders/bindings/service_provider_service_gallery_binding.dart';
import '../modules/serviceProviders/bindings/service_providers_binding.dart';
import '../modules/serviceProviders/controllers/service_provider_service_gallery_controller.dart';
import '../modules/serviceProviders/models/service_provider_service_gallrey.dart';
import '../modules/serviceProviders/views/service_provider_details_view.dart';
import '../modules/serviceProviders/views/service_provider_service_gallery_view.dart';
import '../modules/serviceProviders/views/service_providers_view.dart';
import '../modules/services/bindings/services_binding.dart';
import '../modules/services/views/services_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/upgradeToServiceProvider/bindings/upgrade_to_service_provider_binding.dart';
import '../modules/upgradeToServiceProvider/bindings/upgrade_to_service_provider_binding.dart';
import '../modules/upgradeToServiceProvider/views/upgrade_to_service_provider_view.dart';
import '../modules/upgradeToServiceProvider/views/upgrade_to_service_provider_view.dart';
import '../modules/upgradetoseller/bindings/upgradetoseller_binding.dart';
import '../modules/upgradetoseller/views/upgradetoseller_view.dart';
import '../modules/userQuotes/bindings/user_quotes_binding.dart';
import '../modules/userQuotes/views/user_quotes_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static var INITIAL = Routes.SPLASH;

  static final routes = [

    GetPage(
      name: _Paths.ONBOARDING,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
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
      name: Routes.MY_PROPERTIES,
      page: () => MyPropertiesView(),
      binding: MyPropertiesBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOM_MAP,
      page: () => CustomMapView(),
      binding: CustomMapBinding(),
    ),
    GetPage(
      name: _Paths.ADDPROPERTY,
      page: () => AddPropertyView(),
      binding: AddPropertyBinding(),
    ),
    GetPage(
      name: _Paths.ADDMAINPROPERTY,
      page: () => AddmaininformationVeiw(),
      binding: AddPropertyBinding(),
    ),
    GetPage(
      name: _Paths.ApartmentForRentView,
      page: () => ApartmentForRentView(),
      binding: AddPropertyBinding(),
    ),
    GetPage(
      name: _Paths.UPGRADETOSELLER,
      page: () => const UpgradeToSellerView(),
      binding: UpgradeToSellerBinding(),
    ),
    GetPage(
      name: _Paths.PROPERTY_DETAILS,
      page: () => PropertyDetailsView(),
      binding: PropertyDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_PROVIDERS,
      page: () => ServiceProvidersView(),
      binding: ServiceProvidersBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_DETAILS,
      page: () => ServiceProviderDetailsView(),
      binding: ServiceProviderDetailsBinding(), // <-- new binding
    ),
    GetPage(
      name: Routes.SERVICE_PROVIDER_GALLERY,
      page: () => ServiceProviderGalleryView(),
      binding: ServiceProviderServiceGalleryBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_QUOTES,
      page: () => ProviderQuotesView(),
      binding: ProviderQuotesBinding(),
    ),
    GetPage(
      name: _Paths.FAVORITE,
      page: () => FavoriteView(),
      binding: FavoriteBinding(),
      children: [],
    ),
    GetPage(
      name: _Paths.SERVICES,
      page: () => const ServicesView(),
      binding: ServicesBinding(),
    ),
    GetPage(
      name: _Paths.UPGRADE_TO_SERVICE_PROVIDER,
      page: () => UpgradeToServiceProviderView(),
      binding: UpgradeToServiceProviderBinding(),
    ),
    GetPage(
      name: _Paths.MY_SERVICES,
      page: () => MyServicesView(),
      binding: MyServicesBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY_OPTIONS,
      page: () => HistoryOptionsView(),
      binding: HistoryOptionsBinding(),
    ),
    GetPage(
      name: _Paths.GALLERY,
      page: () => ServiceProviderGalleryView(),
      binding: HistoryOptionsBinding(),
    ),
    GetPage(
      name: _Paths.USER_QUOTES,
      page: () => UserQuotesView(),
      binding: UserQuotesBinding(),
    ),
    GetPage(
      name: _Paths.CONVERSATION,
      page: () =>  ConversationsView(),
      binding: ConversationBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_SERVICE,
      page: () => EditServiceView(),
      binding: EditServiceBinding(),
    ),GetPage(
      name: _Paths.PAYMENT,
      page: () => PaymentView(),
      binding: PaymentBinding(),
    ),
  ];
}
