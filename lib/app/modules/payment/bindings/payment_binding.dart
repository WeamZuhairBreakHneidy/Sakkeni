import 'package:get/get.dart';
import 'package:test1/app/modules/upgradeToServiceProvider/controllers/subscription_plan_controller.dart';

import '../controllers/payment_properties_controller.dart';
import '../controllers/payment_service_provider_controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentServiceProviderController>(
      () => PaymentServiceProviderController(),
    );
    Get.lazyPut<PaymentPropertiesController>(
      () => PaymentPropertiesController(),
    ); Get.lazyPut<SubscriptionPlanController>(
      () => SubscriptionPlanController(),
    );
  }
}
