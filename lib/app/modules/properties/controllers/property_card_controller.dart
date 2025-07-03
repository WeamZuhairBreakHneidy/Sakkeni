import 'package:get/get.dart';
import '../../../data/models/properties-model.dart';
import '../../../data/services/api_service.dart';

class PropertyCardController extends GetxController {
  final Datum property;

  PropertyCardController(this.property);

  String get imageUrl {
    final path = property.coverImage?.imagePath ?? '';
    return "${ApiService().baseUrl}/$path";
  }

  num get price {
    if (property.rent?.price != null) {
      return property.rent!.price!;
    } else if (property.purchase?.price != null) {
      return property.purchase!.price!;
    } else if (property.offplan?.overallPayment != null) {
      return property.offplan!.overallPayment!;
    }
    return 0;
  }

  bool get isRent => property.rent?.price != null;

  Object get leasePeriod => property.rent?.leasePeriod ?? 0;

  String get location {
    final country = property.location?.country?.name ?? '';
    final city = property.location?.city?.name ?? '';
    return "$country, $city";
  }

  String get propertyType => property.propertyType?.name ?? '';

  String get residentialType => property.residential?.residentialPropertyType?.name ?? '';

  String get commercialType => property.commercial?.commercialPropertyType?.name ?? '';

  String get subType {
    if (property.residential != null) return residentialType;
    if (property.commercial != null) return commercialType;
    return '';
  }
}
