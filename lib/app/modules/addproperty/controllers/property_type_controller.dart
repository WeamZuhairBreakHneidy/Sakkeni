import '../../../core/controllers/BaseTabController.dart';

class PropertyTypeController extends BaseTabController {

  PropertyTypeController()
      : super(values: ['Apartment', 'villa', 'office']);


  @override
  void updateTabFromType(String? type) {
    switch (type) {
      case 'Apartment':
        selectedTab.value = 0;
        break;
      case 'villa':
        selectedTab.value = 1;
        break;
      case 'office':
        selectedTab.value = 2;
        break;
      default:
        selectedTab.value = 0;
    }
  }


}
