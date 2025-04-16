// device_utils.dart
import 'package:get/get.dart';

class DeviceUtils {
  static bool isPhone() => Get.width < 600;
  static bool isTablet() => Get.width >= 600 && Get.width < 1024;
}
