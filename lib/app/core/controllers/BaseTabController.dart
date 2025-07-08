import 'package:get/get.dart';

class BaseTabController<T> extends GetxController {
  final RxInt selectedTab = 0.obs;
  late List<T> options;

  BaseTabController({required List<T> values}) {
    options = values;
  }

  void updateTabFromValue(T? value) {
    final index = options.indexOf(value as T);
    if (index != -1) {
      selectedTab.value = index;
    }
  }

  T get currentValue => options[selectedTab.value];
}
