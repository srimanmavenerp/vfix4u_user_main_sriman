// import 'package:get/get.dart';
// import 'package:Vfix4u/utils/core_export.dart';
//
// class ServiceWidgetHorizontal extends StatelessWidget {
//   final List<Service> serviceList;
//   final int index;
//   final num? discountAmount;
//   final String? discountAmountType;
//   final bool showIsFavoriteButton;
//   final GlobalKey<CustomShakingWidgetState>? signInShakeKey;
//
//   const ServiceWidgetHorizontal({
//     super.key,
//     required this.serviceList,
//     required this.index,
//     required this.discountAmount,
//     required this.discountAmountType,
//     this.showIsFavoriteButton = true,
//     this.signInShakeKey,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     double lowestPrice = 0.0;
//     if (serviceList[index].variationsAppFormat!.zoneWiseVariations != null) {
//       lowestPrice = serviceList[index]
//           .variationsAppFormat!
//           .zoneWiseVariations![0]
//           .price!
//           .toDouble();
//       for (var i = 0;
//           i <
//               serviceList[index]
//                   .variationsAppFormat!
//                   .zoneWiseVariations!
//                   .length;
//           i++) {
//         if (serviceList[index]
//                 .variationsAppFormat!
//                 .zoneWiseVariations![i]
//                 .price! <
//             lowestPrice) {
//           lowestPrice = serviceList[index]
//               .variationsAppFormat!
//               .zoneWiseVariations![i]
//               .price!
//               .toDouble();
//         }
//       }
//     }
//     Discount discountModel =
//         PriceConverter.discountCalculation(serviceList[index]);
//
//     final double minPurchase =
//         PriceConverter.getMinPurchase(serviceList[index]);
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//           horizontal: Dimensions.paddingSizeEight,
//           vertical: Dimensions.paddingSizeExtraSmall),
//       child: GetBuilder<ServiceController>(builder: (serviceController) {
//         return OnHover(
//           isItem: true,
//           child: Stack(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor,
//                   borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//                   boxShadow:
//                       Get.find<ThemeController>().darkTheme ? null : cardShadow,
//                   border: Border.all(
//                       color:
//                           Theme.of(context).hintColor.withValues(alpha: 0.1)),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: Dimensions.paddingSizeDefault, vertical: 10),
//                 child: Row(children: [
//                   Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius:
//                             BorderRadius.circular(Dimensions.radiusSmall),
//                         child: CustomImage(
//                           image: '${serviceList[index].thumbnailFullPath}',
//                           height: 100,
//                           width: 100,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       lowestPrice > minPurchase &&
//                           discountModel.discountAmount != null &&
//                           discountModel.discountAmount! > 0
//                           ? Align(
//                         alignment: Alignment.topLeft,
//                         child: DiscountTagWidget(
//                           discountAmount: discountModel.discountAmount,
//                           discountAmountType: discountModel.discountAmountType,
//                         ),
//                       )
//                           : const SizedBox(),
//
//
//
//                       // lowestPrice > minPurchase
//                       //     ? Align(
//                       //         alignment: Alignment.topLeft,
//                       //         child: DiscountTagWidget(
//                       //           discountAmount: discountModel.discountAmount,
//                       //           discountAmountType:
//                       //               discountModel.discountAmountType,
//                       //         ),
//                       //       )
//                       //     : const SizedBox(),
//                     ],
//                   ),
//                   const SizedBox(
//                     width: Dimensions.paddingSizeSmall,
//                   ),
//                   Expanded(
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   serviceList[index].name ?? "",
//                                   style: robotoMedium.copyWith(
//                                       fontSize: Dimensions.fontSizeLarge),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: Dimensions.paddingSizeExtraLarge,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                               height: Dimensions.paddingSizeExtraSmall),
//                           RatingBar(
//                             rating: double.parse(
//                                 serviceList[index].avgRating.toString()),
//                             size: 15,
//                             ratingCount: serviceList[index].ratingCount,
//                           ),
//                           const SizedBox(
//                               height: Dimensions.paddingSizeExtraSmall),
//                           Text(
//                             serviceList[index].shortDescription ?? "",
//                             style: robotoRegular.copyWith(
//                                 fontSize: Dimensions.fontSizeSmall,
//                                 color: Theme.of(context)
//                                     .textTheme
//                                     .bodySmall
//                                     ?.color
//                                     ?.withValues(alpha: 0.5)),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(
//                               height: Dimensions.paddingSizeExtraSmall),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "starts_from".tr,
//                                 style: robotoRegular.copyWith(
//                                     fontSize: Dimensions.fontSizeSmall,
//                                     color: Theme.of(context)
//                                         .textTheme
//                                         .bodyMedium!
//                                         .color!
//                                         .withValues(alpha: 0.5)),
//                               ),
//                               Column(children: [
//                               lowestPrice > minPurchase ?
//                                   Directionality(
//                                     textDirection: TextDirection.ltr,
//                                     child: Text(
//                                       "${PriceConverter.convertPrice(lowestPrice)} ",
//                                       style: robotoRegular.copyWith(
//                                           fontSize: Dimensions.fontSizeSmall,
//                                           decoration:
//                                               TextDecoration.lineThrough,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .error
//                                               .withValues(alpha: .8)),
//                                     ),
//                                   ): Directionality(
//                                     textDirection: TextDirection.ltr,
//                                     child: Text(
//                                       "${PriceConverter.convertPrice(lowestPrice)} ",
//                                       style:  robotoBold.copyWith(
//                                               fontSize:
//                                                   Dimensions.paddingSizeDefault,
//                                               color: Get.isDarkMode
//                                                   ? Theme.of(context)
//                                                       .primaryColorLight
//                                                   : Theme.of(context)
//                                                       .primaryColor),
//                                     ),
//                                   ),
//                                 lowestPrice > minPurchase
//                                     ? Directionality(
//                                         textDirection: TextDirection.ltr,
//                                         child: Text(
//                                           PriceConverter.convertPrice(
//                                               lowestPrice,
//                                               discount:
//                                                   discountAmount!.toDouble(),
//                                               discountType: discountAmountType),
//                                           style: robotoBold.copyWith(
//                                               fontSize:
//                                                   Dimensions.paddingSizeDefault,
//                                               color: Get.isDarkMode
//                                                   ? Theme.of(context)
//                                                       .primaryColorLight
//                                                   : Theme.of(context)
//                                                       .primaryColor),
//                                         ),
//                                       ):const SizedBox.shrink()
//                                     //  Directionality(
//                                     //     textDirection: TextDirection.ltr,
//                                     //     child: Text(
//                                     //       PriceConverter.convertPrice(
//                                     //           lowestPrice),
//                                     //       style: robotoBold.copyWith(
//                                     //           fontSize:
//                                     //               Dimensions.fontSizeLarge,
//                                     //           color: Get.isDarkMode
//                                     //               ? Theme.of(context)
//                                     //                   .primaryColorLight
//                                     //               : Theme.of(context)
//                                     //                   .primaryColor),
//                                     //     ),
//                                     //   ),
//                               ]),
//                             ],
//                           ),
//                         ]),
//                   ),
//                 ]),
//               ),
//               Positioned.fill(child: RippleButton(onTap: () {
//                 Get.toNamed(
//                   RouteHelper.getServiceRoute(
//                       serviceController.recommendedServiceList![index].id!),
//                   arguments: ServiceDetailsScreen(
//                       serviceID:
//                           serviceController.recommendedServiceList![index].id!),
//                 );
//               })),
//               if (showIsFavoriteButton)
//                 Align(
//                   alignment: favButtonAlignment(),
//                   child: FavoriteIconWidget(
//                     value: serviceList[index].isFavorite,
//                     serviceId: serviceList[index].id!,
//                     signInShakeKey: signInShakeKey,
//                   ),
//                 ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

import 'package:get/get.dart';
import 'package:Vfix4u/utils/core_export.dart';

class ServiceWidgetHorizontal extends StatelessWidget {
  final List<Service> serviceList;
  final int index;
  final num? discountAmount;
  final String? discountAmountType;
  final bool showIsFavoriteButton;
  final GlobalKey<CustomShakingWidgetState>? signInShakeKey;

  const ServiceWidgetHorizontal({
    super.key,
    required this.serviceList,
    required this.index,
    required this.discountAmount,
    required this.discountAmountType,
    this.showIsFavoriteButton = true,
    this.signInShakeKey,
  });

  @override
  Widget build(BuildContext context) {
    double lowestPrice = 0.0;

    if (serviceList[index].variationsAppFormat!.zoneWiseVariations != null) {
      lowestPrice = serviceList[index]
          .variationsAppFormat!
          .zoneWiseVariations![0]
          .price!
          .toDouble();
      for (var i = 0;
          i <
              serviceList[index]
                  .variationsAppFormat!
                  .zoneWiseVariations!
                  .length;
          i++) {
        if (serviceList[index]
                .variationsAppFormat!
                .zoneWiseVariations![i]
                .price! <
            lowestPrice) {
          lowestPrice = serviceList[index]
              .variationsAppFormat!
              .zoneWiseVariations![i]
              .price!
              .toDouble();
        }
      }
    }

    Discount discountModel =
        PriceConverter.discountCalculation(serviceList[index]);
    final double minPurchase =
        PriceConverter.getMinPurchase(serviceList[index]);

    // Calculate discounted price
    double discountedPrice = PriceConverter.convertWithDiscount(
      lowestPrice,
      discountAmount?.toDouble() ?? 0,
      discountAmountType ?? '',
    );

    // Print details in console
    print('----- Service Index: $index -----');
    print('Service Name: ${serviceList[index].name}');
    print('Original Price: $lowestPrice');
    print('Discount Amount: ${discountAmount}');
    print('Discount Type: $discountAmountType');
    print('Discounted Price: $discountedPrice');

    // If discount results in same price, ignore it
    bool showOnlyOriginalPrice = discountedPrice == lowestPrice;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeEight,
          vertical: Dimensions.paddingSizeExtraSmall),
      child: GetBuilder<ServiceController>(builder: (serviceController) {
        return OnHover(
          isItem: true,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow:
                      Get.find<ThemeController>().darkTheme ? null : cardShadow,
                  border: Border.all(
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: 10,
                ),
                child: Row(children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        child: CustomImage(
                          image: '${serviceList[index].thumbnailFullPath}',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      lowestPrice > minPurchase
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: DiscountTagWidget(
                                discountAmount: discountModel.discountAmount,
                                discountAmountType:
                                    discountModel.discountAmountType,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                serviceList[index].name ?? "",
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                                width: Dimensions.paddingSizeExtraLarge),
                          ],
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        RatingBar(
                          rating: double.parse(
                              serviceList[index].avgRating.toString()),
                          size: 15,
                          ratingCount: serviceList[index].ratingCount,
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        Text(
                          serviceList[index].shortDescription ?? "",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "starts_from".tr,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color!
                                    .withOpacity(0.5),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: showOnlyOriginalPrice
                                      ? Text(
                                          PriceConverter.convertPrice(
                                              lowestPrice),
                                          style: robotoBold.copyWith(
                                            fontSize:
                                                Dimensions.paddingSizeDefault,
                                            color: Get.isDarkMode
                                                ? Theme.of(context)
                                                    .primaryColorLight
                                                : Theme.of(context)
                                                    .primaryColor,
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              PriceConverter.convertPrice(
                                                  lowestPrice),
                                              style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                            Text(
                                              PriceConverter.convertPrice(
                                                  discountedPrice),
                                              style: robotoBold.copyWith(
                                                fontSize: Dimensions
                                                    .paddingSizeDefault,
                                                color: Get.isDarkMode
                                                    ? Theme.of(context)
                                                        .primaryColorLight
                                                    : Theme.of(context)
                                                        .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              Positioned.fill(
                child: RippleButton(onTap: () {
                  Get.toNamed(
                    RouteHelper.getServiceRoute(
                      serviceController.recommendedServiceList![index].id!,
                    ),
                    arguments: ServiceDetailsScreen(
                      serviceID:
                          serviceController.recommendedServiceList![index].id!,
                    ),
                  );
                }),
              ),
              if (showIsFavoriteButton)
                Align(
                  alignment: favButtonAlignment(),
                  child: FavoriteIconWidget(
                    value: serviceList[index].isFavorite,
                    serviceId: serviceList[index].id!,
                    signInShakeKey: signInShakeKey,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
