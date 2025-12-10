import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      if (categoryController.categoryList == null) {
        return const CategoryShimmer();
      } else if (categoryController.categoryList!.isEmpty) {
        return const SizedBox();
      } else {
        // Determine crossAxisCount based on device type
        int crossAxisCount = ResponsiveHelper.isDesktop(context)
            ? 10
            : ResponsiveHelper.isTab(context)
                ? 6
                : 4;

        return Center(
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleWidget(
                    textDecoration: TextDecoration.underline,
                    title: 'all_categories'.tr,
                    onTap: null,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categoryController.categoryList!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: Dimensions.paddingSizeSmall,
                      mainAxisSpacing: Dimensions.paddingSizeSmall,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final category = categoryController.categoryList![index];

                      return TextHover(builder: (hovered) {
                        return Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: ResponsiveHelper.isDesktop(context)
                                      ? 100
                                      : ResponsiveHelper.isTab(context)
                                          ? 80
                                          : 60,
                                  width: ResponsiveHelper.isDesktop(context)
                                      ? 100
                                      : ResponsiveHelper.isTab(context)
                                          ? 80
                                          : 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    color: Theme.of(context).cardColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    child: CustomImage(
                                      image: category.imageFullPath ?? "",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    category.name ?? "",
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: hovered
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.color ??
                                              (Get.find<ThemeController>()
                                                      .darkTheme
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.color),
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Positioned.fill(
                              child: RippleButton(
                                onTap: () {
                                  print("""
object:
  id: ${category.id},
  name: ${category.name},
  index: $index
""");

                                  Get.toNamed(
                                    RouteHelper.getCategoryProductRoute(
                                      category.id!,
                                      category.name!,
                                      index.toString(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}

class CategoryShimmer extends StatelessWidget {
  final bool? fromHomeScreen;

  const CategoryShimmer({super.key, this.fromHomeScreen = true});

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = ResponsiveHelper.isDesktop(context)
        ? 10
        : ResponsiveHelper.isTab(context)
            ? 6
            : 4;

    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: Column(
          children: [
            if (fromHomeScreen!)
              const SizedBox(height: Dimensions.paddingSizeLarge),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: fromHomeScreen! ? 8 : crossAxisCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: Dimensions.paddingSizeSmall,
                mainAxisSpacing: Dimensions.paddingSizeSmall,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                        height: 12,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: ResponsiveHelper.isDesktop(context)
                  ? 0
                  : Dimensions.paddingSizeLarge,
            ),
          ],
        ),
      ),
    );
  }
}
