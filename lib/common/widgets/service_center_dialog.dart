

// import 'package:get/get.dart';
// import 'package:demandium/utils/core_export.dart';
//
// class ServiceCenterDialog extends StatefulWidget {
//   final Service? service;
//   final CartModel? cart;
//   final int? cartIndex;
//   final bool? isFromDetails;
//   final ProviderData? providerData;
//
//   const ServiceCenterDialog(
//       {super.key,
//         required this.service,
//         this.cart,
//         this.cartIndex,
//         this.isFromDetails = false,
//         this.providerData});
//
//   @override
//   State<ServiceCenterDialog> createState() => _ProductBottomSheetState();
// }
//
// class _ProductBottomSheetState extends State<ServiceCenterDialog> {
//   num? lowestPrice = 0.0;
//   Discount? discountModel;
//   double? minPurchase;
//   @override
//   void initState() {
//     super.initState();
//
//     Get.find<CartController>().setInitialCartList(widget.service!, defaultQuantity: 1);
//     Get.find<CartController>()
//         .updatePreselectedProvider(null, shouldUpdate: false);
//     Get.find<AllSearchController>().searchFocus.unfocus();
//     // Compute lowestPrice in initState
//     if (widget.service?.variationsAppFormat?.zoneWiseVariations?.isNotEmpty ??
//         false) {
//       lowestPrice =
//           widget.service!.variationsAppFormat!.zoneWiseVariations!.first.price;
//       for (var variation
//       in widget.service!.variationsAppFormat!.zoneWiseVariations!) {
//         if (variation.price != null && variation.price! < lowestPrice!) {
//           lowestPrice = variation.price!;
//         }
//       }
//     }
//     discountModel = PriceConverter.discountCalculation(widget.service!);
//     minPurchase = PriceConverter.getMinPurchase(widget.service!);
//     print('discountModel===${discountModel!.minPurchase}');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // num? lowestPrice = 0.0;
//
//     // if (widget.service?.variationsAppFormat?.zoneWiseVariations != null &&
//     //     widget.service!.variationsAppFormat!.zoneWiseVariations!.isNotEmpty) {
//     //   lowestPrice =
//     //       widget.service!.variationsAppFormat!.zoneWiseVariations!.first.price;
//
//     //   for (var variation
//     //       in widget.service!.variationsAppFormat!.zoneWiseVariations!) {
//     //     if (variation.price != null && variation.price! < lowestPrice!) {
//     //       lowestPrice = variation.price!;
//     //     }
//     //   }
//     // }
//
//     if (ResponsiveHelper.isDesktop(context)) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
//         insetPadding: const EdgeInsets.all(30),
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         child: pointerInterceptor(),
//       );
//     }
//     return pointerInterceptor();
//   }
//
//   pointerInterceptor() {
//     return Padding(
//       padding: EdgeInsets.only(
//           top: ResponsiveHelper.isWeb() ? 0 : Dimensions.cartDialogPadding),
//       child: PointerInterceptor(
//         child: Container(
//           width: ResponsiveHelper.isDesktop(context)
//               ? Dimensions.webMaxWidth / 2
//               : Dimensions.webMaxWidth,
//           padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//           decoration: BoxDecoration(
//             color: Theme.of(context).cardColor,
//             borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(Dimensions.radiusExtraLarge)),
//           ),
//           child: GetBuilder<CartController>(builder: (cartControllerInit) {
//             return GetBuilder<ServiceController>(builder: (serviceController) {
//               if (widget.service!.variationsAppFormat!.zoneWiseVariations != null) {
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(
//                           width: Dimensions.paddingSizeLarge,
//                         ),
//                         ClipRRect(
//                           borderRadius: const BorderRadius.all(
//                               Radius.circular(Dimensions.paddingSizeDefault)),
//                           child: CustomImage(
//                             image: '${widget.service!.thumbnailFullPath}',
//                             height: Dimensions.imageSizeButton,
//                             width: Dimensions.imageSizeButton,
//                           ),
//                         ),
//                         Container(
//                           height: 40,
//                           width: 40,
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white70.withValues(alpha: 0.6),
//                               boxShadow: Get.isDarkMode
//                                   ? null
//                                   : [
//                                 BoxShadow(
//                                   color: Colors.grey[300]!,
//                                   blurRadius: 2,
//                                   spreadRadius: 1,
//                                 )
//                               ]),
//                           child: InkWell(
//                               onTap: () => Get.back(),
//                               child: const Icon(
//                                 Icons.close,
//                                 color: Colors.black54,
//                               )),
//                         )
//                       ],
//                     ),
//                     const SizedBox(
//                       height: Dimensions.paddingSizeEight,
//                     ),
//                     Text(
//                       widget.service!.name!,
//                       style: robotoMedium.copyWith(
//                           fontSize: Dimensions.fontSizeDefault),
//                       textAlign: TextAlign.center,
//                       maxLines: 2,
//                     ),
//                     const SizedBox(
//                       height: Dimensions.paddingSizeMini,
//                     ),
//                     Text(
//                       widget.service!.variationsAppFormat!.zoneWiseVariations!
//                           .length >
//                           1
//                           ? "${widget.service!.variationsAppFormat!.zoneWiseVariations!.length} ${'variations_available'.tr}"
//                           : "${widget.service!.variationsAppFormat!.zoneWiseVariations!.length} ${'variation_available'.tr}",
//                       style: robotoRegular.copyWith(
//                           color: Theme.of(context)
//                               .textTheme
//                               .bodyLarge!
//                               .color!
//                               .withValues(alpha: .5)),
//                     ),
//
//
//                     Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: Dimensions.paddingSizeLarge),
//
//                           ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: cartControllerInit.initialCartList.length,
//                               itemBuilder: (context, index) {
//                                 //variation item
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: Dimensions.paddingSizeSmall),
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical:
//                                         Dimensions.paddingSizeExtraSmall),
//                                     decoration: BoxDecoration(
//                                         color: Theme.of(context).hoverColor,
//                                         borderRadius: const BorderRadius.all(
//                                             Radius.circular(
//                                                 Dimensions.paddingSizeDefault))),
//                                     child: GetBuilder<CartController>(
//                                       builder: (cartController) {
//                                         return Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Row(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 Expanded(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                     mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                     children: [
//                                                       Text(
//                                                         cartControllerInit
//                                                             .initialCartList[
//                                                         index]
//                                                             .variantKey
//                                                             .replaceAll('-', ' '),
//                                                         style: robotoMedium
//                                                             .copyWith(
//                                                             fontSize:
//                                                             Dimensions
//                                                                 .fontSizeSmall),
//                                                         maxLines: 2,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                       ),
//                                                       const SizedBox(
//                                                         height: Dimensions
//                                                             .paddingSizeExtraSmall,
//                                                       ),
//                                                       Directionality(
//                                                         textDirection:
//                                                         TextDirection.ltr,
//                                                         child: Text(
//                                                           lowestPrice! >=
//                                                               minPurchase!
//                                                               ? PriceConverter
//                                                               .convertPrice(
//                                                             double.parse(
//                                                                 lowestPrice
//                                                                     .toString()),
//                                                             discount: discountModel!
//                                                                 .discountAmount!
//                                                                 .toDouble(),
//                                                             discountType:
//                                                             discountModel!
//                                                                 .discountAmountType,
//                                                           )
//                                                               : PriceConverter
//                                                               .convertPrice(
//                                                             double.parse(
//                                                                 lowestPrice
//                                                                     .toString()),
//                                                             isShowLongPrice:
//                                                             true,
//                                                           ),
//                                                           style: robotoMedium.copyWith(
//                                                               color: Get
//                                                                   .isDarkMode
//                                                                   ? Theme.of(
//                                                                   context)
//                                                                   .primaryColorLight
//                                                                   : Theme.of(
//                                                                   context)
//                                                                   .primaryColor,
//                                                               fontSize: Dimensions
//                                                                   .fontSizeSmall),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   flex: 1,
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                     MainAxisAlignment.end,
//                                                     children: [
//                                                       // Minus button
//                                                       InkWell(
//                                                         onTap: () {
//                                                           // Update quantity, ensure it doesn't go below 1
//                                                           if (cartControllerInit
//                                                               .initialCartList[
//                                                           index]
//                                                               .quantity >=
//                                                               1) {
//                                                             cartController
//                                                                 .updateQuantity(
//                                                                 index,
//                                                                 false);
//                                                           }
//                                                         },
//                                                         child: Container(
//                                                           height: 30,
//                                                           width: 30,
//                                                           margin: const EdgeInsets
//                                                               .symmetric(
//                                                               horizontal: Dimensions
//                                                                   .paddingSizeSmall),
//                                                           decoration:
//                                                           BoxDecoration(
//                                                             shape:
//                                                             BoxShape.circle,
//                                                             color: Theme.of(
//                                                                 context)
//                                                                 .colorScheme
//                                                                 .secondary,
//                                                           ),
//                                                           alignment:
//                                                           Alignment.center,
//                                                           child: Icon(
//                                                             Icons.remove,
//                                                             size: 15,
//                                                             color: Theme.of(
//                                                                 context)
//                                                                 .cardColor,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Text(
//                                                             () {
//                                                           final isSingleVariation = widget
//                                                               .service!
//                                                               .variationsAppFormat!
//                                                               .zoneWiseVariations!
//                                                               .length ==
//                                                               1;
//                                                           final quantity =
//                                                               cartControllerInit
//                                                                   .initialCartList[
//                                                               index]
//                                                                   .quantity;
//
//                                                           if (isSingleVariation) {
//                                                             return quantity == 0
//                                                                 ? '1'
//                                                                 : quantity
//                                                                 .toString();
//                                                           } else if (quantity >
//                                                               0) {
//                                                             return quantity
//                                                                 .toString();
//                                                           } else {
//                                                             return index == 0
//                                                                 ? '1'
//                                                                 : '0';
//                                                           }
//                                                         }(),
//                                                       ),
//                                                       // Plus button
//                                                       GestureDetector(
//                                                         onTap: () {
//                                                           // Ensure that the cartController can update the quantity regardless of its value
//                                                           cartController
//                                                               .updateQuantity(
//                                                               index, true);
//                                                         },
//                                                         child: Container(
//                                                           height: 30,
//                                                           width: 30,
//                                                           margin: const EdgeInsets
//                                                               .symmetric(
//                                                               horizontal: Dimensions
//                                                                   .paddingSizeSmall),
//                                                           decoration:
//                                                           BoxDecoration(
//                                                             shape:
//                                                             BoxShape.circle,
//                                                             color: Theme.of(
//                                                                 context)
//                                                                 .colorScheme
//                                                                 .secondary,
//                                                           ),
//                                                           alignment:
//                                                           Alignment.center,
//                                                           child: Icon(
//                                                             Icons.add,
//                                                             size: 15,
//                                                             color: Theme.of(
//                                                                 context)
//                                                                 .cardColor,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ]),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 );
//                               }),
//
//
//                           // Add to Cart button
//                           GetBuilder<CartController>(builder: (cartController) {
//                             bool addToCart = true;
//                             return cartController.isLoading
//                                 ? const Center(child: CircularProgressIndicator())
//                                 : CustomButton(
//                               height: ResponsiveHelper.isDesktop(context)
//                                   ? 55
//                                   : 45,
//                               onPressed: cartControllerInit.isButton
//                                   ? () async {
//                                 if (addToCart) {
//                                   int index = cartControllerInit
//                                       .initialCartList
//                                       .indexWhere(
//                                         (e) =>
//                                     e.serviceId ==
//                                         widget.service?.id,
//                                   );
//
//                                   if (index != -1) {
//                                     // Update the quantity for existing cart item
//                                     cartController.updateQuantity(
//                                         index, true);
//                                   }
//
//                                   // Add or update cart on server
//                                   await cartController
//                                       .addMultipleCartToServer(
//                                     providerId: cartController
//                                         .selectedProvider?.id ??
//                                         widget.providerData?.id ??
//                                         "",
//                                   );
//
//                                   // Refresh cart list from server
//                                   await cartController
//                                       .getCartListFromServer(
//                                       shouldUpdate: true);
//                                 }
//                               }
//                                   : null,
//                               buttonText: (cartController
//                                   .cartList.isNotEmpty &&
//                                   cartController.cartList
//                                       .elementAt(0)
//                                       .serviceId ==
//                                       widget.service?.id)
//                                   ? 'update_cart'.tr
//                                   : 'add_to_cart'.tr,
//                             );
//                           }),
//                           const SizedBox(height: Dimensions.paddingSizeLarge),
//                           ConstrainedBox(
//                             constraints: BoxConstraints(
//                               minHeight: Get.height * 0.02,
//                               // maxHeight: Get.height * 0.2
//                             ),
//
//                           ),
//                           const SizedBox(height: Dimensions.paddingSizeLarge),
//                           // Provider and Bidding buttons
//                           Row(
//                             children: [
//                               if (Get.find<SplashController>()
//                                   .configModel
//                                   .content
//                                   ?.directProviderBooking ==
//                                   1)
//                                 (widget.providerData != null ||
//                                     cartControllerInit.selectedProvider != null)
//                                     ? GestureDetector(
//                                   onTap: () {
//                                     showModalBottomSheet(
//                                       useRootNavigator: true,
//                                       isScrollControlled: true,
//                                       backgroundColor: Colors.transparent,
//                                       context: context,
//                                       builder: (context) =>
//                                           AvailableProviderWidget(
//                                             subcategoryId:
//                                             widget.service?.subCategoryId ??
//                                                 "",
//                                           ),
//                                     );
//                                   },
//                                   child: SelectedProductWidget(
//                                     providerData: widget.providerData ??
//                                         cartControllerInit.selectedProvider,
//                                   ),
//                                 )
//                                     : GestureDetector(
//                                   onTap: () {
//                                     showModalBottomSheet(
//                                       useRootNavigator: true,
//                                       isScrollControlled: true,
//                                       backgroundColor: Colors.transparent,
//                                       context: context,
//                                       builder: (context) =>
//                                           AvailableProviderWidget(
//                                             subcategoryId:
//                                             widget.service?.subCategoryId ??
//                                                 "",
//                                           ),
//                                     );
//                                   },
//                                   child: const UnselectedProductWidget(),
//                                 ),
//                               if (Get.find<SplashController>()
//                                   .configModel
//                                   .content
//                                   ?.directProviderBooking ==
//                                   1)
//                                 const SizedBox(
//                                   width: Dimensions.paddingSizeSmall,
//                                 ),
//                               if (Get.find<SplashController>()
//                                   .configModel
//                                   .content
//                                   ?.biddingStatus ==
//                                   1)
//                                 GestureDetector(
//                                   onTap: () {
//                                     Get.back();
//                                     showModalBottomSheet(
//                                         backgroundColor: Colors.transparent,
//                                         isScrollControlled: true,
//                                         context: Get.context!,
//                                         builder: (BuildContext context) {
//                                           return const BottomCreatePostDialog();
//                                         });
//                                     if (widget.service != null) {
//                                       Get.find<CreatePostController>()
//                                           .updateSelectedService(widget.service!);
//                                       Get.find<CreatePostController>()
//                                           .resetCreatePostValue(
//                                           removeService: false);
//                                     }
//                                   },
//                                   child: Container(
//                                     height: ResponsiveHelper.isDesktop(context)
//                                         ? 50
//                                         : 45,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(
//                                           Dimensions.radiusSmall),
//                                       border: Border.all(
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .primary
//                                               .withValues(alpha: 0.5),
//                                           width: 0.7),
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .primary
//                                           .withValues(alpha: 0.1),
//                                     ),
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: Dimensions.paddingSizeSmall),
//                                     child: Center(
//                                         child: Hero(
//                                           tag: 'provide_image',
//                                           child: Image.asset(
//                                             Images.customPostIcon,
//                                             height: 30,
//                                             width: 30,
//                                           ),
//                                         )),
//                                   ),
//                                 ),
//                               if (Get.find<SplashController>()
//                                   .configModel
//                                   .content
//                                   ?.biddingStatus ==
//                                   1)
//                                 const SizedBox(
//                                   width: Dimensions.paddingSizeSmall,
//                                 ),
//                             ],
//                           ),
//                         ]),
//                   ],
//                 );
//               }
//               return Stack(
//                 children: [
//                   Positioned(
//                     top: 0,
//                     right: 20,
//                     child: Container(
//                       height: 40,
//                       width: 40,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white70.withValues(alpha: 0.6),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey[
//                               Get.find<ThemeController>().darkTheme
//                                   ? 700
//                                   : 300]!,
//                               blurRadius: 2,
//                               spreadRadius: 1,
//                             )
//                           ]),
//                       child: InkWell(
//                           onTap: () => Get.back(),
//                           child: const Icon(Icons.close)),
//                     ),
//                   ),
//                   SizedBox(
//                       height: Get.height / 7,
//                       child: Center(
//                           child: Text(
//                             'no_variation_is_available'.tr,
//                             style: robotoMedium.copyWith(
//                                 fontSize: Dimensions.fontSizeLarge),
//                           )))
//                 ],
//               );
//             });
//           }),
//         ),
//       ),
//     );
//   }
// }
//
//

////////////////////////////////////////

///old code




/////varient data




import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class ServiceCenterDialog extends StatefulWidget {
  final Service? service;
  final CartModel? cart;
  final int? cartIndex;
  final bool? isFromDetails;
  final ProviderData? providerData;

  const ServiceCenterDialog({
    super.key,
    required this.service,
    this.cart,
    this.cartIndex,
    this.isFromDetails = false,
    this.providerData,
  });

  @override
  State<ServiceCenterDialog> createState() => _ServiceCenterDialogState();
}

class _ServiceCenterDialogState extends State<ServiceCenterDialog> {
  num? lowestPrice = 0.0;
  Discount? discountModel;
  double? minPurchase;

  @override
  void initState() {
    super.initState();

    Get.find<CartController>().setInitialCartList(widget.service!, defaultQuantity: 1);
    Get.find<CartController>().updatePreselectedProvider(null, shouldUpdate: false);
    Get.find<AllSearchController>().searchFocus.unfocus();

    // Compute lowestPrice in initState
    if (widget.service?.variationsAppFormat?.zoneWiseVariations?.isNotEmpty ?? false) {
      lowestPrice = widget.service!.variationsAppFormat!.zoneWiseVariations!.first.price;
      for (var variation in widget.service!.variationsAppFormat!.zoneWiseVariations!) {
        if (variation.price != null && variation.price! < lowestPrice!) {
          lowestPrice = variation.price!;
        }
      }
    }
    discountModel = PriceConverter.discountCalculation(widget.service!);
    minPurchase = PriceConverter.getMinPurchase(widget.service!);
  }

  @override
  Widget build(BuildContext context) {
    return pointerInterceptor(context);
  }

  Widget pointerInterceptor(BuildContext context) {
    return PointerInterceptor(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.63,
        width: ResponsiveHelper.isDesktop(context)
            ? Dimensions.webMaxWidth / 2
            : Dimensions.webMaxWidth,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Stack(
          children: [
            GetBuilder<CartController>(
              builder: (cartController) {
                if (widget.service?.variationsAppFormat?.zoneWiseVariations?.isNotEmpty ?? false) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: Dimensions.paddingSizeLarge), // Space for the close icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                              child: CustomImage(
                                image: widget.service?.thumbnailFullPath ?? '',
                                height: Dimensions.imageSizeButton,
                                width: Dimensions.imageSizeButton,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeEight),

                        Text(
                          widget.service?.name ?? '',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeMini),

                        Text(
                          widget.service!.variationsAppFormat!.zoneWiseVariations!.length > 1
                              ? "${widget.service!.variationsAppFormat!.zoneWiseVariations!.length} ${'variations_available'.tr}"
                              : "${widget.service!.variationsAppFormat!.zoneWiseVariations!.length} ${'variation_available'.tr}",
                          style: robotoRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5),
                          ),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        // Variations list
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartController.initialCartList.length,
                          itemBuilder: (context, index) {
                            // Get variation price for the current item
                            num variationPrice = 0.0;
                            if (widget.service?.variationsAppFormat?.zoneWiseVariations != null &&
                                index < widget.service!.variationsAppFormat!.zoneWiseVariations!.length) {
                              variationPrice = widget.service!.variationsAppFormat!.zoneWiseVariations![index].price ?? 0.0;

                              // Print variation price to console for debugging
                              print('Variation ${index+1}: ${cartController.initialCartList[index].variantKey}, Price: $variationPrice');
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hoverColor,
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            cartController.initialCartList[index].variantKey.replaceAll('-', ' '),
                                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                          Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Text(
                                              variationPrice >= minPurchase!
                                                  ? PriceConverter.convertPrice(
                                                variationPrice.toDouble(),
                                                discount: discountModel!.discountAmount!.toDouble(),
                                                discountType: discountModel!.discountAmountType,
                                              )
                                                  : PriceConverter.convertPrice(
                                                variationPrice.toDouble(),
                                                isShowLongPrice: true,
                                              ),
                                              style: robotoMedium.copyWith(
                                                color: Get.isDarkMode
                                                    ? Theme.of(context).primaryColorLight
                                                    : Theme.of(context).primaryColor,
                                                fontSize: Dimensions.fontSizeSmall,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Minus button
                                        InkWell(
                                          onTap: () {
                                            if (cartController.initialCartList[index].quantity > 0) {
                                              cartController.updateQuantity(index, false);
                                            }
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: cartController.initialCartList[index].quantity > 0
                                                  ? Theme.of(context).colorScheme.secondary
                                                  : Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.remove,
                                              size: 15,
                                              color: Theme.of(context).cardColor,
                                            ),
                                          ),
                                        ),

                                        // // Quantity display
                                        // Text(
                                        //   cartController.initialCartList[index].quantity.toString(),
                                        //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                        // ),

                                        Text(
                                              () {
                                            final isSingleVariation = widget.service!.variationsAppFormat!.zoneWiseVariations!.length == 1;
                                            final quantity = cartController.initialCartList[index].quantity;

                                            if (isSingleVariation && quantity == 0) {
                                              cartController.initialCartList[index].quantity = 1;
                                              return '1';
                                            } else {
                                              return quantity.toString();
                                            }
                                          }(),
                                        ),

                                        // Plus button
                                        InkWell(
                                          onTap: () => cartController.updateQuantity(index, true),
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context).colorScheme.secondary,
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.add,
                                              size: 15,
                                              color: Theme.of(context).cardColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // Add to Cart Button
                        cartController.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                          height: 45,
                          onPressed: cartController.isButton
                              ? () async {
                            int index = cartController.initialCartList.indexWhere(
                                  (e) => e.serviceId == widget.service?.id,
                            );

                            // Add or update cart on server
                            await cartController.addMultipleCartToServer(
                              providerId: cartController.selectedProvider?.id ??
                                  widget.providerData?.id ??
                                  "",
                            );

                            // Refresh cart list from server
                            await cartController.getCartListFromServer(shouldUpdate: true);

                            Get.back();
                          }
                              : null,
                          buttonText: (cartController.cartList.isNotEmpty &&
                              cartController.cartList.any((cart) => cart.serviceId == widget.service?.id))
                              ? 'update_cart'.tr
                              : 'add_to_cart'.tr,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        // Provider and Bidding buttons
                        Row(
                          children: [
                            if (Get.find<SplashController>().configModel.content?.directProviderBooking == 1)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      useRootNavigator: true,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) => AvailableProviderWidget(
                                        subcategoryId: widget.service?.subCategoryId ?? "",
                                      ),
                                    );
                                  },
                                  child: (widget.providerData != null || cartController.selectedProvider != null)
                                      ? SelectedProductWidget(
                                    providerData: widget.providerData ?? cartController.selectedProvider,
                                  )
                                      : const UnselectedProductWidget(),
                                ),
                              ),

                            if (Get.find<SplashController>().configModel.content?.directProviderBooking == 1 &&
                                Get.find<SplashController>().configModel.content?.biddingStatus == 1)
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                            if (Get.find<SplashController>().configModel.content?.biddingStatus == 1)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.back();
                                    showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const BottomCreatePostDialog();
                                      },
                                    );

                                    if (widget.service != null) {
                                      Get.find<CreatePostController>().updateSelectedService(widget.service!);
                                      Get.find<CreatePostController>().resetCreatePostValue(removeService: false);
                                    }
                                  },
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      border: Border.all(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                        width: 0.7,
                                      ),
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                    child: Center(
                                      child: Hero(
                                        tag: 'provide_image',
                                        child: Image.asset(
                                          Images.customPostIcon,
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.info_outline, size: 40),
                        const SizedBox(height: 10),
                        Text(
                          'no_variation_is_available'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),

            // Close Icon (top-right)
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () => Get.back(),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white70.withOpacity(0.6),
                    boxShadow: Get.isDarkMode
                        ? null
                        : [
                      BoxShadow(
                        color: Colors.grey[300]!,
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close, color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//////afer deleter varient data

// import 'package:get/get.dart';
// import 'package:demandium/utils/core_export.dart';
//
// class ServiceCenterDialog extends StatefulWidget {
//   final Service? service;
//   final CartModel? cart;
//   final int? cartIndex;
//   final bool? isFromDetails;
//   final ProviderData? providerData;
//
//   const ServiceCenterDialog({
//     super.key,
//     required this.service,
//     this.cart,
//     this.cartIndex,
//     this.isFromDetails = false,
//     this.providerData,
//   });
//
//   @override
//   State<ServiceCenterDialog> createState() => _ServiceCenterDialogState();
// }
//
// class _ServiceCenterDialogState extends State<ServiceCenterDialog> {
//   num? lowestPrice = 0.0;
//   Discount? discountModel;
//   double? minPurchase;
//
//   @override
//   void initState() {
//     super.initState();
//
//     final cartController = Get.find<CartController>();
//     if (widget.service != null) {
//       cartController.setInitialCartList(widget.service!, defaultQuantity: 1);
//     }
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (cartController.initialCartList.isNotEmpty) {
//         cartController.initialCartList[0].quantity = 1;
//         cartController.update();
//       }
//     });
//
//     cartController.updatePreselectedProvider(null, shouldUpdate: false);
//     Get.find<AllSearchController>().searchFocus.unfocus();
//
//     if (widget.service?.variationsAppFormat?.zoneWiseVariations?.isNotEmpty ?? false) {
//       lowestPrice = widget.service!.variationsAppFormat!.zoneWiseVariations!.first.price;
//       for (var variation in widget.service!.variationsAppFormat!.zoneWiseVariations!) {
//         if (variation.price != null && variation.price! < lowestPrice!) {
//           lowestPrice = variation.price!;
//         }
//       }
//     }
//     discountModel = PriceConverter.discountCalculation(widget.service!);
//     minPurchase = PriceConverter.getMinPurchase(widget.service!);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return pointerInterceptor(context); // Just return the content, call from showModalBottomSheet
//   }
//
//   Widget pointerInterceptor(BuildContext context) {
//     return PointerInterceptor(
//       child: Container(
//         height: MediaQuery.of(context).size.height * 0.55,
//         width: ResponsiveHelper.isDesktop(context)
//             ? Dimensions.webMaxWidth / 2
//             : Dimensions.webMaxWidth,
//         padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: const BorderRadius.vertical(
//             top: Radius.circular(Dimensions.radiusExtraLarge),
//           ),
//         ),
//         child: Stack(
//           children: [
//             GetBuilder<CartController>(
//               builder: (cartController) {
//                 if (widget.service?.variationsAppFormat?.zoneWiseVariations?.isNotEmpty ?? false) {
//                   return SingleChildScrollView(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const SizedBox(height: Dimensions.paddingSizeLarge), // Space for the close icon
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
//                           child: CustomImage(
//                             image: widget.service?.thumbnailFullPath ?? '',
//                             height: Dimensions.imageSizeButton,
//                             width: Dimensions.imageSizeButton,
//                           ),
//                         ),
//                         const SizedBox(height: Dimensions.paddingSizeEight),
//
//                         Text(
//                           widget.service?.name ?? '',
//                           style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                         ),
//                         const SizedBox(height: Dimensions.paddingSizeMini),
//
//                         Text(
//                           "${widget.service!.variationsAppFormat!.zoneWiseVariations!.length} ${'variations_available'.tr}",
//                           style: robotoRegular.copyWith(
//                             color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5),
//                           ),
//                         ),
//
//                         // Quantity Selector
//                         if (cartController.initialCartList.isNotEmpty)
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).hoverColor,
//                                 borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
//                               ),
//                               padding: const EdgeInsets.all(8),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           cartController.initialCartList[0].variantKey.replaceAll('-', ' '),
//                                           style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
//                                         ),
//                                         const SizedBox(height: Dimensions.paddingSizeExtraSmall),
//                                         Text(
//                                           lowestPrice! >= minPurchase!
//                                               ? PriceConverter.convertPrice(
//                                             lowestPrice!.toDouble(),
//                                             discount: discountModel!.discountAmount!.toDouble(),
//                                             discountType: discountModel!.discountAmountType,
//                                           )
//                                               : PriceConverter.convertPrice(
//                                             lowestPrice!.toDouble(),
//                                             isShowLongPrice: true,
//                                           ),
//                                           style: robotoMedium.copyWith(
//                                             color: Get.isDarkMode
//                                                 ? Theme.of(context).primaryColorLight
//                                                 : Theme.of(context).primaryColor,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       // Minus
//                                       InkWell(
//                                         onTap: () {
//                                           if (cartController.initialCartList[0].quantity > 1) {
//                                             cartController.updateQuantity(0, false);
//                                           }
//                                         },
//                                         child: CircleAvatar(
//                                           radius: 15,
//                                           backgroundColor: cartController.initialCartList[0].quantity > 1
//                                               ? Theme.of(context).colorScheme.secondary
//                                               : Theme.of(context).colorScheme.secondary.withOpacity(0.5),
//                                           child: Icon(Icons.remove,
//                                               color: Theme.of(context).cardColor, size: 15),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                                         child: Text(
//                                           cartController.initialCartList[0].quantity.toString(),
//                                           style:
//                                           robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
//                                         ),
//                                       ),
//                                       // Plus
//                                       InkWell(
//                                         onTap: () => cartController.updateQuantity(0, true),
//                                         child: CircleAvatar(
//                                           radius: 15,
//                                           backgroundColor: Theme.of(context).colorScheme.secondary,
//                                           child: Icon(Icons.add,
//                                               color: Theme.of(context).cardColor, size: 15),
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         const SizedBox(height: 40),
//
//                         // Add to Cart Button
//                         cartController.isLoading
//                             ? const Center(child: CircularProgressIndicator())
//                             : Padding(
//                           padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
//                           child: CustomButton(
//                             height: 45,
//                             onPressed: cartController.isButton
//                                 ? () async {
//                               await cartController.addMultipleCartToServer(
//                                 providerId: cartController.selectedProvider?.id ??
//                                     widget.providerData?.id ??
//                                     "",
//                               );
//                               await cartController.getCartListFromServer(shouldUpdate: true);
//                               Get.back();
//                             }
//                                 : null,
//                             buttonText: (cartController.cartList.isNotEmpty &&
//                                 cartController.cartList[0].serviceId == widget.service?.id)
//                                 ? 'update_cart'.tr
//                                 : 'add_to_cart'.tr,
//                           ),
//                         ),
//                         const SizedBox(height: Dimensions.paddingSizeLarge),
//
//                         // Provider / Bidding Options
//                         Row(
//                           children: [
//                             if (Get.find<SplashController>()
//                                 .configModel
//                                 .content
//                                 ?.directProviderBooking ==
//                                 1)
//                               GestureDetector(
//                                 onTap: () {
//                                   showModalBottomSheet(
//                                     useRootNavigator: true,
//                                     isScrollControlled: true,
//                                     backgroundColor: Colors.transparent,
//                                     context: context,
//                                     builder: (context) => AvailableProviderWidget(
//                                       subcategoryId: widget.service?.subCategoryId ?? "",
//                                     ),
//                                   );
//                                 },
//                                 child: widget.providerData != null ||
//                                     cartController.selectedProvider != null
//                                     ? SelectedProductWidget(
//                                   providerData: widget.providerData ??
//                                       cartController.selectedProvider,
//                                 )
//                                     : const UnselectedProductWidget(),
//                               ),
//                             if (Get.find<SplashController>()
//                                 .configModel
//                                 .content
//                                 ?.biddingStatus ==
//                                 1)
//                               const SizedBox(width: Dimensions.paddingSizeSmall),
//                             if (Get.find<SplashController>()
//                                 .configModel
//                                 .content
//                                 ?.biddingStatus ==
//                                 1)
//                               GestureDetector(
//                                 onTap: () {
//                                   Get.back();
//                                   showModalBottomSheet(
//                                     backgroundColor: Colors.transparent,
//                                     isScrollControlled: true,
//                                     context: context,
//                                     builder: (context) => const BottomCreatePostDialog(),
//                                   );
//                                   if (widget.service != null) {
//                                     Get.find<CreatePostController>()
//                                         .updateSelectedService(widget.service!);
//                                     Get.find<CreatePostController>()
//                                         .resetCreatePostValue(removeService: false);
//                                   }
//                                 },
//                                 child: Container(
//                                   height: 45,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                                     border: Border.all(
//                                       color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
//                                     ),
//                                     color:
//                                     Theme.of(context).colorScheme.primary.withOpacity(0.1),
//                                   ),
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: Dimensions.paddingSizeSmall),
//                                   child: Center(
//                                     child: Hero(
//                                       tag: 'provide_image',
//                                       child: Image.asset(
//                                         Images.customPostIcon,
//                                         height: 30,
//                                         width: 30,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   return Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.info_outline, size: 40),
//                         const SizedBox(height: 10),
//                         Text(
//                           'no_variation_is_available'.tr,
//                           style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               },
//             ),
//
//             // Close Icon (top-right)
//             Positioned(
//               top: 0,
//               right: 0,
//               child: InkWell(
//                 onTap: () => Get.back(),
//                 child: Container(
//                   margin: const EdgeInsets.all(8),
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white70.withOpacity(0.6),
//                     boxShadow: Get.isDarkMode
//                         ? null
//                         : [
//                       BoxShadow(
//                         color: Colors.grey[300]!,
//                         blurRadius: 2,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                   child: const Icon(Icons.close, color: Colors.black54),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }