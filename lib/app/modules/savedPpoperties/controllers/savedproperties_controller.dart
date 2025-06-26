import 'package:get/get.dart';

class SavedPropertiesController extends GetxController {
  var savedProperties = <int, bool>{}.obs;

  void toggleSaved(int id) {
    savedProperties[id] = !(savedProperties[id] ?? false);
  }

  bool isSaved(int id) {
    return savedProperties[id] ?? false;
  }
}
