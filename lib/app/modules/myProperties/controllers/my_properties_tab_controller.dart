import '../../../core/controllers/BaseTabController.dart';

class MyPropertiesTabController extends BaseTabController<String> {
  MyPropertiesTabController()
      : super(values: ['rent', 'purchase', 'offplan']);
}
