import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/properties-model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';
import '../models/favorite_model.dart';

enum FavoriteTypeEnum { rent, purchase, offplan }

abstract class FavoriteViewController extends GetxController {
  abstract final FavoriteTypeEnum type;

  final isLoading = false.obs;
  final favorites = <FavoriteDatum>[].obs; // بدل properties
  final favoriteModel = Rxn<FavoriteModel>(); // بدل PropertiesModel
  final currentPage = 1.obs;
  final hasMoreData = true.obs;

  final tokenService = TokenService();

  String get endpoint {
    switch (type) {
      case FavoriteTypeEnum.rent:
        return ApiEndpoints.favoriteRent;
      case FavoriteTypeEnum.purchase:
        return ApiEndpoints.favoritePurchase;
      case FavoriteTypeEnum.offplan:
        return ApiEndpoints.favoriteOffplan;
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchFavorites();
    });
    super.onInit();
  }

  Future<void> fetchFavorites({int page = 1, bool isLoadMore = false}) async {
    if (isLoading.value || !hasMoreData.value) return;

    isLoading.value = true;

    try {
      final response = await ApiService().getApi(url: '$endpoint?page=$page');
      final model = FavoriteModel.fromJson(response.body);
      favoriteModel.value = model;
      final fetchedData = model.data?.data ?? [];

      if (isLoadMore) {
        favorites.addAll(fetchedData);
      } else {
        favorites.value = fetchedData;
      }

      // pagination check
      hasMoreData.value = fetchedData.isNotEmpty;
      currentPage.value = page;
    } catch (e) {
      print("Error fetching favorites: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void loadNextPage() {
    if (!isLoading.value && hasMoreData.value) {
      fetchFavorites(page: currentPage.value + 1, isLoadMore: true);
    }
  }
}
