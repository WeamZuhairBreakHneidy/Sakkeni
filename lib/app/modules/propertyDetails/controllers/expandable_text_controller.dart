import 'package:get/get.dart';

class ExpandableTextController extends GetxController {
  final isExpanded = false.obs;

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }
}