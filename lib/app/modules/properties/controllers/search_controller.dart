import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';

class PropertiesSearchController extends GetxController {
  final isSearching = false.obs;
  final searchResults = <Map<String, dynamic>>[].obs;
  final searchTextController = TextEditingController();

  final tokenService = TokenService();

  Future<void> searchProperties(String query) async {
    try {
      final token = await tokenService.token;

      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().postApi(
        url: ApiEndpoints.searchProperties,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: {"query": query},
      );

      if (response.statusCode == 200) {
        final body = response.body;
        final dataList = body['data']?['data'] ?? [];
        searchResults.assignAll(List<Map<String, dynamic>>.from(dataList));
        isSearching.value = true;
      } else {
        Get.snackbar('Error', 'Search failed: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void clearSearch() {
    searchTextController.clear();
    searchResults.clear();
    isSearching.value = false;
  }
}
