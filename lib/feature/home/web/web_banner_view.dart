import 'package:demandium/feature/home/web/web_banner_shimmer.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class WebBannerView extends GetView<BannerController> {
  final PageController _pageController = PageController();

  WebBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLtr = Get.find<LocalizationController>().isLtr;

    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: GetBuilder<BannerController>(
          builder: (bannerController) {
            if (bannerController.banners != null &&
                bannerController.banners!.isEmpty) {
              return const SizedBox();
            } else {
              return Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: bannerController.banners != null
                      ? bannerController.banners!.length == 1
                          ? _singleBanner(bannerController, 0)
                          : _multiBanner(bannerController, isLtr)
                      : const WebBannerShimmer(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Single banner widget
  Widget _singleBanner(BannerController controller, int index) {
    return InkWell(
      onTap: () => _onBannerTap(controller.banners![index], controller),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        child: AspectRatio(
          aspectRatio: 19 / 8,
          child: CustomImage(
            image: '${controller.banners![index].bannerImageFullPath}',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Multi-banner PageView
  Widget _multiBanner(BannerController controller, bool isLtr) {
    final int totalPages = (controller.banners!.length / 2).ceil();

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        PageView.builder(
          onPageChanged: (int index) => controller.setCurrentIndex(index, true),
          controller: _pageController,
          itemCount: totalPages,
          itemBuilder: (context, pageIndex) {
            int index1 = pageIndex * 2;
            int index2 = (pageIndex * 2) + 1;
            bool hasSecond = index2 < controller.banners!.length;

            return Row(
              children: [
                Expanded(child: _singleBanner(controller, index1)),
                const SizedBox(width: Dimensions.paddingSizeLarge),
                Expanded(
                  child: hasSecond
                      ? _singleBanner(controller, index2)
                      : (controller.banners!.length > 2
                          ? _singleBanner(controller, 0)
                          : const SizedBox()),
                ),
              ],
            );
          },
        ),
        // Left Arrow
        if (controller.currentIndex != 0)
          Positioned(
            left: Dimensions.paddingSizeExtraLarge,
            child: _navigationButton(
              isLeft: true,
              onTap: () => _pageController.previousPage(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut),
              isLtr: isLtr,
            ),
          ),
        // Right Arrow
        if (controller.currentIndex != totalPages - 1)
          Positioned(
            right: Dimensions.paddingSizeExtraLarge,
            child: _navigationButton(
              isLeft: false,
              onTap: () => _pageController.nextPage(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut),
              isLtr: isLtr,
            ),
          ),
      ],
    );
  }

  // Navigation arrow button
  Widget _navigationButton(
      {required bool isLeft,
      required VoidCallback onTap,
      required bool isLtr}) {
    final dark = Get.find<ThemeController>().darkTheme
        ? ThemeData.dark()
        : ThemeData.light();

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white70.withOpacity(0.6),
          boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
        ),
        child: Icon(
          isLeft ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
          color: dark.cardColor,
          size: Dimensions.webArrowSize,
        ),
      ),
    );
  }

  void _onBannerTap(BannerModel banner, BannerController controller) {
    String link = banner.redirectLink ?? '';
    String id = banner.category?.id ?? '';
    String name = banner.category?.name ?? '';

    controller.navigateFromBanner(
      banner.resourceType!,
      id,
      link,
      banner.resourceId ?? '',
      categoryName: name,
    );
  }
}
