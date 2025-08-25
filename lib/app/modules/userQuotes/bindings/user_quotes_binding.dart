import 'package:get/get.dart';

import '../controllers/user_quotes_controller.dart';

class UserQuotesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserQuotesController>(
      () => UserQuotesController(),
    );
  }
}
