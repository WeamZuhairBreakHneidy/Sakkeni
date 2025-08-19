import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/widgets/properties_tab.dart';
import '../../../core/theme/colors.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/property_card.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/favorite_offplan_controller.dart';
import '../controllers/favorite_purchase_controller.dart';
import '../controllers/favorite_rent_controller.dart';
import '../../../data/models/properties-model.dart';
import '../controllers/favorite_tab_contoller.dart';

class FavoriteView extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final tabController = Get.put(FavoriteTabController(), permanent: true);
  late final dynamic _controller;
  final FavoriteController favController = Get.put(FavoriteController());

  FavoriteView({super.key}) {
    _controller = getControllerForCurrentRoute();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        _controller.loadNextPage();
      }
    });
  }

  dynamic getControllerForCurrentRoute() {
    final typeParam = Get.parameters['type'] ?? 'rent';
    switch (typeParam) {
      case 'rent':
        return Get.find<FavoriteRentController>();
      case 'purchase':
        return Get.find<FavoritePurchaseController>();
      case 'offplan':
        return Get.find<FavoriteOffPlanController>();
      default:
        return Get.find<FavoriteRentController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabController.updateTabFromType(Get.parameters['type']);
    });
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            color: Theme.of(context).colorScheme.background,
            padding: EdgeInsets.only(
              top: 50.h,
              left: 20.w,
              right: 20.w,
              bottom: 15.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Text(
                    "Favorite Properties",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                10.verticalSpace,
                Divider(height: 1.h, color: Colors.grey),
                20.verticalSpace,
                TabSelector(
                  controller: tabController,
                  tabs: ['For Rent', 'For Sale', 'Off plan'],
                  onTabSelected: (index) {
                    final route = switch (index) {
                      0 => '${Routes.FAVORITEVIEW}?type=rent',
                      1 => '${Routes.FAVORITEVIEW}?type=purchase',
                      2 => '${Routes.FAVORITEVIEW}?type=offplan',
                      _ => '${Routes.FAVORITEVIEW}?type=rent',
                    };
                    Get.offNamed(route);
                  },
                ),
              ],
            ),
          ),

          // Main Container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Obx(() {
                final favs = _controller.favorites;
                final isLoading = _controller.isLoading.value;
                final hasMoreData = _controller.hasMoreData.value;

                if (favs.isEmpty && isLoading) {
                  return Center(
                    child: SizedBox(
                      width: 75,
                      height: 75,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballRotateChase,
                        colors: [AppColors.primary],
                        strokeWidth: 1,
                      ),
                    ),
                  );
                }
                if (favs.isEmpty && !isLoading) {
                  return const Center(child: Text("No properties found."));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    _controller.currentPage.value = 1;
                    _controller.hasMoreData.value = true;
                    _controller.favorites.clear();
                    await _controller.fetchFavorites(
                      page: 1,
                      isLoadMore: false,
                    );
                  },
                  child: ListView.builder(
                    itemCount: favs.length + (hasMoreData ? 1 : 0),
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index < favs.length) {
                        final Datum? property = favs[index].property;

                        if (property == null) {
                          print('Warning: null property at index $index');
                          return const SizedBox.shrink();
                        }

                        final String imageUrl;
                        String? imagePath = property.coverImage?.imagePath;
                        if (imagePath != null && imagePath.isNotEmpty) {
                          imageUrl = "${ApiService().baseUrl}/$imagePath";
                        } else {
                          imageUrl = 'https://via.placeholder.com/150';
                        }

                        final location =
                            "${property.location?.country?.name ?? ''}, ${property.location?.city?.name ?? ''}";
                        final lease =
                            property.rent?.leasePeriod.toString() ?? '';
                        final propertyType = property.propertyType?.name ?? '';
                        final subType =
                            property
                                .residential
                                ?.residentialPropertyType
                                ?.name ??
                            property.commercial?.commercialPropertyType?.name ??
                            '';

                        return SizedBox(
                          child: PropertyCard(
                            imageUrl: imageUrl,
                            leasePeriod: lease,
                            location: location,
                            propertyType: propertyType,
                            subType: subType,
                            onTap: () {
                              Get.toNamed(
                                Routes.PROPERTY_DETAILS,
                                arguments: property.id,
                              );
                            },
                            onDelete: () {
                              print(property.id);
                              favController.removePropertyFromFavorite(
                                property.id,
                              );
                            },
                          ),
                        );
                      } else {
                        return Obx(
                          () =>
                              _controller.isLoading.value &&
                                      _controller.hasMoreData.value
                                  ? const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                  : const SizedBox(),
                        );
                      }
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
