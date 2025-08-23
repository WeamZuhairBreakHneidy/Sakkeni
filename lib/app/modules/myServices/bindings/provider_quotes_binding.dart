import 'package:get/get.dart';
import '../controllers/provider_quotes_controller.dart';

class ProviderQuotesBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<ProviderQuotesController>(() => ProviderQuotesController());
  }
}
