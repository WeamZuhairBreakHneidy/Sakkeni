import '../../../core/controllers/BaseTabController.dart';

class HistoryTabController extends BaseTabController<String> {
  HistoryTabController()
      : super(values: ['rent', 'purchase', 'offplan']);
}
