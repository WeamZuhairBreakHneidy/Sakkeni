import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';

class FavoriteController extends GetxController {
  var favoriteStatus = <num, bool>{}.obs;
  var loadingStatus = <num, bool>{}.obs; // لكل property
  final TokenService _tokenService = TokenService();
  final _storage = GetStorage();
  final _favKey = 'favorite_status';

  @override
  void onInit() {
    super.onInit();
    final stored = _storage.read<Map<dynamic, dynamic>>(_favKey);
    if (stored != null) {
      favoriteStatus.value = stored.map(
            (key, value) => MapEntry(num.parse(key.toString()), value as bool),
      );
    }
  }

  Future<void> addPropertyToFavorite(num propertyId) async {
    loadingStatus[propertyId] = true;
    try {
      final token = await _tokenService.token;
      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().getApi(
        url: '${ApiEndpoints.addToFavorite}/$propertyId',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        favoriteStatus[propertyId] = true;
        _saveFavorites();
        Get.snackbar(
          'Success',
          response.body['message'] ?? 'Property added to favorite successfully',
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to add property to favorite. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      loadingStatus[propertyId] = false;
    }
  }

  Future<void> removePropertyFromFavorite(num propertyId) async {
    loadingStatus[propertyId] = true;
    try {
      final token = await _tokenService.token;
      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().getApi(
        url: '${ApiEndpoints.removeFromFavorite}/$propertyId',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        favoriteStatus[propertyId] = false;
        _saveFavorites();
        Get.snackbar(
          'Success',
          response.body['message'] ??
              'Property removed from favorite successfully',
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to remove property from favorite. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      loadingStatus[propertyId] = false;
    }
  }

  void _saveFavorites() {
    final Map<String, bool> toStore = favoriteStatus.map(
          (key, value) => MapEntry(key.toString(), value),
    );
    _storage.write(_favKey, toStore);
  }
}
