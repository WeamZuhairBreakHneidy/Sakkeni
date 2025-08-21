import 'package:get/get.dart';

import '../controllers/history_options_controller.dart';

class HistoryOptionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryOptionsController>(
      () => HistoryOptionsController(),
    );
  }
}
