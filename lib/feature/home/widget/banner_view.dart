import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class BannerView extends StatelessWidget {
  const BannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(
      builder: (bannerController) {
        if (bannerController.banners != null &&
            bannerController.banners!.isEmpty) {
          return const SizedBox();
        }
        // Choose your aspect ratio (e.g., 16:6 for banners)
        return Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
          child: AspectRatio(
            aspectRatio: 14 / 6,
            child: bannerController.banners != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      CarouselSlider.builder(
                        options: CarouselOptions(
                          enableInfiniteScroll:
                              bannerController.banners!.length > 1,
                          autoPlay: true,
                          enlargeCenterPage: false,
                          viewportFraction: .94,
                          disableCenter: true,
                          autoPlayInterval: const Duration(seconds: 7),
                          onPageChanged: (index, reason) {
                            bannerController.setCurrentIndex(index, true);
                          },
                        ),
                        itemCount: bannerController.banners!.length,
                        itemBuilder: (context, index, _) {
                          BannerModel bannerModel =
                              bannerController.banners![index];
                          return InkWell(
                            onTap: () {
                              String link = bannerModel.redirectLink ?? '';
                              String id = bannerModel.category?.id ?? '';
                              String name = bannerModel.category?.name ?? "";
                              bannerController.navigateFromBanner(
                                bannerModel.resourceType!,
                                id,
                                link,
                                bannerModel.resourceId ?? '',
                                categoryName: name,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                  child: CustomImage(
                                    image: bannerController.banners?[index]
                                            .bannerImageFullPath ??
                                        "",
                                    fit: BoxFit.cover,
                                    placeholder: Images.placeholder,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (bannerController.banners!.length > 1)
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.center,
                            child: AnimatedSmoothIndicator(
                              activeIndex: bannerController.currentIndex!,
                              count: bannerController.banners!.length,
                              effect: ExpandingDotsEffect(
                                dotHeight: 7,
                                dotWidth: 7,
                                spacing: 5,
                                activeDotColor:
                                    Theme.of(context).colorScheme.primary,
                                dotColor: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                : Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    color: Colors.grey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: Get.isDarkMode
                            ? null
                            : [
                                BoxShadow(
                                    color: Colors.grey[200]!,
                                    blurRadius: 5,
                                    spreadRadius: 1)
                              ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
