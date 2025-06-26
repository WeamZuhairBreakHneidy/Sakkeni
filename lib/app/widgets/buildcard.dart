
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';

import '../modules/getstarted/views/getstarted_view.dart';

class FlipController extends GetxController {
  final int itemCount;
  final Duration flipDuration;
  final Duration pageDuration;

  FlipController({
    required this.itemCount,
    required this.flipDuration,
    required this.pageDuration,
  });

  var currentPage = 0.obs;
  var isFront = true.obs;

  late Timer flipTimer;
  late Timer pageTimer;

  @override
  void onInit() {
    super.onInit();

    // تكرار التبديل بين وجه البطاقة الأمامي والخلفي
    flipTimer = Timer.periodic(flipDuration, (_) {
      isFront.value = !isFront.value;
    });

    // تغيير الصفحة تلقائيًا
    pageTimer = Timer.periodic(pageDuration, (_) {
      currentPage.value = (currentPage.value + 1) % itemCount;
      isFront.value = true;
    });
  }

  @override
  void onClose() {
    flipTimer.cancel();
    pageTimer.cancel();
    super.onClose();
  }
}

class HorizontalFlipSections extends StatelessWidget {
  final List<String> frontImages;
  final List<String>? backImages;
  final double height;
  final double viewportFraction;
  final Duration flipDuration;
  final Duration pageDuration;

  HorizontalFlipSections({
    super.key,
    required this.frontImages,
    this.backImages,
    required this.height,
    required this.viewportFraction,
    required this.flipDuration,
    required this.pageDuration,
  });


  final FlipController controller = Get.put(
    FlipController(
      itemCount: 6, // أو frontImages.length
      flipDuration: Duration(seconds: 2),
      pageDuration: Duration(seconds: 4),
    ),
  );

  late final PageController _pageController = PageController(
    viewportFraction: 0.4,
    initialPage: 0,
  );

  Widget buildCard(int index, bool isFront, BuildContext context) {
    bool isLastCard = index == frontImages.length - 1;

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 800),
      transitionBuilder: (child, animation) {
        final rotate = Tween(begin: 1.0, end: 0.0).animate(animation);
        return AnimatedBuilder(
          animation: rotate,
          child: child,
          builder: (context, child) {
            final isUnder = (ValueKey(isFront) != child?.key);
            var tilt = (animation.value - 0.5).abs() - 0.5;
            tilt *= isUnder ? -0.003 : 0.003;
            final value = isUnder ? min(rotate.value, 0.5) : rotate.value;

            return Transform(
              transform: Matrix4.rotationY(value * pi)
                ..setEntry(3, 0, tilt),
              alignment: Alignment.center,
              child: child,
            );
          },
        );
      },
      child: isFront
          ? Stack(
        children: [
          Card(
            key: ValueKey(true),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(frontImages[index], fit: BoxFit.cover),
          ),
          if (isLastCard)
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GetstartedView(),
                    ),
                  );
                },
              ),
            ),
        ],
      )
          : Card(
        key: ValueKey(false),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        clipBehavior: Clip.antiAlias,
        child: backImages != null && backImages!.length > index
            ? Image.asset(backImages![index], fit: BoxFit.cover)
            : Container(
          color: Colors.orangeAccent,
          child: const Center(
            child: Text(
              'مزيد من المعلومات',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // هذه الخطوة للإستماع للتغيير من الكنترولر بدون استخدام Obx مباشرة
    ever(controller.currentPage, (index) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    // واجهة المستخدم
    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: _pageController,
        itemCount: frontImages.length,
        itemBuilder: (context, index) {
          return Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: buildCard(index, controller.isFront.value, context),
            );
          });
        },
      ),
    );
  }
}
