import '../../../core/controllers/BaseTabController.dart';

class SellTypeController extends BaseTabController {

  SellTypeController()
      : super(values: ['rent', 'purchase', 'offplan']);


  @override
  void updateTabFromType(String? type) {
    switch (type) {
      case 'rent':
        selectedTab.value = 0;
        break;
      case 'purchase':
        selectedTab.value = 1;
        break;
      case 'offplan':
        selectedTab.value = 2;
        break;
      default:
        selectedTab.value = 0;
    }
  }


}
