// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:demandium/utils/core_export.dart';
// import 'package:demandium/feature/booking/widget/booking_status_tabs.dart';
//
// import '../repo/submit_review_repo.dart';
//
// class RateScreen extends StatefulWidget {
//   final bool isFromMenu;
//   const RateScreen({super.key, this.isFromMenu = false});
//
//   @override
//   State<RateScreen> createState() => _RateScreenState();
// }
//
// class _RateScreenState extends State<RateScreen> {
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     Get.find<ServiceBookingController>().getAllBookingService(
//       offset: 1,
//       bookingStatus: "completed",
//       isFromPagination: false,
//       serviceType: "completed",
//     );
//     Get.find<ServiceBookingController>().updateBookingStatusTabs(BookingStatusTabs.completed, firstTimeCall: false);
//     Get.find<ServiceBookingController>().updateSelectedServiceType();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       endDrawer: ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
//       appBar: CustomAppBar(
//         isBackButtonExist: widget.isFromMenu,
//         onBackPressed: () => Get.back(),
//         title: 'Rate Card'.tr,
//         actionWidget: const FilterPopUpMenuWidget(),
//       ),
//       body: GetBuilder<ServiceBookingController>(
//         builder: (serviceBookingController) {
//           List<BookingModel>? bookingList = serviceBookingController.bookingList;
//           return CustomScrollView(
//             controller: _scrollController,
//             slivers: [
//               if (serviceBookingController.selectedServiceType != ServiceType.all &&
//                   !ResponsiveHelper.isDesktop(context))
//                 SliverPersistentHeader(
//                   delegate: ServiceRequestTopTitle(),
//                   pinned: true,
//                   floating: true,
//                 ),
//
//               SliverPersistentHeader(
//                 delegate: ServiceRequestSectionMenu(),
//                 pinned: true,
//                 floating: true,
//               ),
//
//               SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: ResponsiveHelper.isDesktop(context)
//                       ? Dimensions.paddingSizeDefault
//                       : 0,
//                 ),
//               ),
//
//               serviceBookingController.bookingList != null
//                   ? SliverToBoxAdapter(
//                 child: bookingList!.isNotEmpty
//                     ? Center(
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       maxWidth: Dimensions.webMaxWidth,
//                       minHeight: Get.height * 0.7,
//                     ),
//                     child: PaginatedListView(
//                       scrollController: _scrollController,
//                       totalSize: serviceBookingController
//                           .bookingContent!.total!,
//                       onPaginate: (int offset) async =>
//                       await serviceBookingController
//                           .getAllBookingService(
//                         offset: offset,
//                         bookingStatus: "completed",
//                         isFromPagination: true,
//                         serviceType: serviceBookingController
//                             .selectedServiceType.name,
//                       ),
//                       offset: serviceBookingController
//                           .bookingContent?.currentPage,
//                       itemView: GridView.builder(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: ResponsiveHelper.isDesktop(
//                               context)
//                               ? 0
//                               : Dimensions.paddingSizeDefault,
//                         ),
//                         gridDelegate:
//                         SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount:
//                           ResponsiveHelper.isDesktop(context)
//                               ? 2
//                               : 1,
//                           mainAxisExtent: Get.find<
//                               LocalizationController>()
//                               .isLtr
//                               ? 180
//                               : 215,
//                           crossAxisSpacing:
//                           Dimensions.paddingSizeDefault,
//                           mainAxisSpacing:
//                           Dimensions.paddingSizeDefault,
//                         ),
//                         physics:
//                         const NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: bookingList.length,
//                         itemBuilder: (context, index) {
//                           return BookingItemCard(
//                             bookingModel: bookingList[index],
//                             index: index,
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 )
//                     : Center(
//                   child: SizedBox(
//                     height: Get.height * 0.7,
//                     width: Dimensions.webMaxWidth,
//                     child: NoDataScreen(
//                       text: 'no_completed_booking_available'.tr,
//                       type: NoDataType.bookings,
//                     ),
//                   ),
//                 ),
//               )
//                   : const SliverToBoxAdapter(
//                 child: Center(
//                   child: SizedBox(
//                     width: Dimensions.webMaxWidth,
//                     child: BookingListItemShimmer(),
//                   ),
//                 ),
//               ),
//
//               SliverToBoxAdapter(
//                 child: ResponsiveHelper.isDesktop(context)
//                     ? const FooterView()
//                     : const SizedBox(),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// class BookingListItemShimmer extends StatelessWidget {
//   const BookingListItemShimmer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: ResponsiveHelper.isDesktop(context) ? 2 : 1,
//         mainAxisExtent: ResponsiveHelper.isDesktop(context) ? 130 : 120,
//         crossAxisSpacing: Dimensions.paddingSizeDefault,
//         mainAxisSpacing: ResponsiveHelper.isDesktop(context)
//             ? Dimensions.paddingSizeSmall
//             : Dimensions.paddingSizeExtraSmall,
//       ),
//       shrinkWrap: true,
//       itemCount: 10,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: EdgeInsets.symmetric(
//             vertical: Dimensions.paddingSizeSmall - 3,
//             horizontal: ResponsiveHelper.isDesktop(context)
//                 ? 0
//                 : Dimensions.paddingSizeDefault,
//           ),
//           child: Shimmer(
//             child: Container(
//               height: 90,
//               width: Get.width,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Theme.of(context).cardColor,
//                 boxShadow: Get.isDarkMode
//                     ? null
//                     : [
//                   BoxShadow(
//                     color: Colors.grey[300]!,
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                   )
//                 ],
//               ),
//               padding: const EdgeInsets.symmetric(
//                 horizontal: Dimensions.paddingSizeDefault,
//                 vertical: Dimensions.paddingSizeSmall,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: 17,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: Theme.of(context).shadowColor,
//                           ),
//                         ),
//                         const SizedBox(height: Dimensions.paddingSizeSmall),
//                         Container(
//                           height: 15,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: Theme.of(context).shadowColor,
//                           ),
//                         ),
//                         const SizedBox(height: Dimensions.paddingSizeSmall),
//                         Container(
//                           height: 15,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: Theme.of(context).shadowColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Expanded(child: SizedBox()),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         height: 17,
//                         width: 50,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: Theme.of(context).shadowColor,
//                         ),
//                       ),
//                       const SizedBox(height: Dimensions.paddingSizeSmall),
//                       Container(
//                         height: 15,
//                         width: 50,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: Theme.of(context).shadowColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class ServiceRequestTopTitle extends SliverPersistentHeaderDelegate {
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return GetBuilder<ServiceBookingController>(
//       builder: (serviceBookingController) {
//         return Center(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Text(
//               serviceBookingController.selectedServiceType == ServiceType.regular
//                   ? "regular_booking".tr
//                   : "repeat_booking".tr,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   double get maxExtent => 30;
//
//   @override
//   double get minExtent => 30;
//
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return true;
//   }
// }
//
// class FilterPopUpMenuWidget extends StatelessWidget {
//   const FilterPopUpMenuWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ServiceBookingController>(
//       builder: (serviceBookingController) {
//         List<String> bookingFilterList = [
//           // 'all_booking',
//           // "regular_booking",
//           // "repeat_booking"
//         ];
//
//         return PopupMenuButton<String>(
//           shape: RoundedRectangleBorder(
//             borderRadius:
//             const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
//             side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
//           ),
//           surfaceTintColor: Theme.of(context).cardColor,
//           position: PopupMenuPosition.under,
//           elevation: 8,
//           shadowColor: Theme.of(context).hintColor.withValues(alpha: 0.3),
//           padding: EdgeInsets.zero,
//           menuPadding: EdgeInsets.zero,
//           itemBuilder: (BuildContext context) {
//             return bookingFilterList.map((String option) {
//               ServiceType type = option == "regular_booking"
//                   ? ServiceType.regular
//                   : option == "repeat_booking"
//                   ? ServiceType.repeat
//                   : ServiceType.all;
//               return PopupMenuItem<String>(
//                 value: option,
//                 padding: EdgeInsets.zero,
//                 height: 45,
//                 child: serviceBookingController.selectedServiceType == type
//                     ? Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: Theme.of(context)
//                         .colorScheme
//                         .primary
//                         .withValues(alpha: Get.isDarkMode ? 0.2 : 0.08),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: Dimensions.paddingSizeDefault,
//                     vertical: 12,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         option.tr,
//                         style: robotoRegular.copyWith(
//                             color: Theme.of(context).colorScheme.primary),
//                       ),
//                     ],
//                   ),
//                 )
//                     : Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: Dimensions.paddingSizeDefault),
//                   child: Text(option.tr, style: robotoRegular),
//                 ),
//                 onTap: () {
//                   Get.find<ServiceBookingController>().updateSelectedServiceType(
//                     type: option == "regular_booking"
//                         ? ServiceType.regular
//                         : option == "repeat_booking"
//                         ? ServiceType.repeat
//                         : ServiceType.all,
//                   );
//                 },
//               );
//             }).toList();
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: Dimensions.paddingSizeDefault),
//             child: Stack(
//               alignment: AlignmentDirectional.center,
//               clipBehavior: Clip.none,
//               children: [
//                 Icon(
//                   Icons.filter_list,
//                   color: ResponsiveHelper.isDesktop(context)
//                       ? Theme.of(context).colorScheme.primary
//                       : null,
//                 ),
//                 if (serviceBookingController.selectedServiceType != ServiceType.all)
//                   Positioned(
//                     right: -5,
//                     bottom: ResponsiveHelper.isDesktop(context) ? 0 : 13,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         const Icon(Icons.circle, size: 13, color: Colors.white),
//                         Icon(
//                           Icons.circle,
//                           size: 10,
//                           color: Theme.of(context).colorScheme.error,
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class BookingItemCard extends StatefulWidget {
//   final BookingModel bookingModel;
//   final int index;
//
//   const BookingItemCard({
//     super.key,
//     required this.bookingModel,
//     required this.index,
//   });
//
//   @override
//   State<BookingItemCard> createState() => _BookingItemCardState();
// }
//
// class _BookingItemCardState extends State<BookingItemCard> {
//   double _rating = 0;
//
//   void _submitReview() async {
//     if (_rating == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select a rating')),
//       );
//       return;
//     }
//
//     final reviewBody = ReviewBody(
//       bookingID: widget.bookingModel.id!,
//       rating: _rating.toInt().toString(),
//       comment: '',
//       serviceID: '',
//     );
//
//     final response = await Get.find<SubmitReviewRepo>().submitReview(reviewBody: reviewBody);
//
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Review submitted successfully')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to submit review')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 5,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   widget.bookingModel.categoryId ?? 'Service',
//                   style: robotoMedium.copyWith(
//                     fontSize: Dimensions.fontSizeDefault,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: Dimensions.paddingSizeSmall),
//                 Text(
//                   widget.bookingModel.id ?? 'N/A',
//                   style: robotoRegular.copyWith(
//                     fontSize: Dimensions.fontSizeSmall,
//                     color: Theme.of(context).hintColor,
//                   ),
//                 ),
//                 const SizedBox(height: Dimensions.paddingSizeSmall),
//                 Text(
//                   PriceConverter.convertPrice(widget.bookingModel.totalBookingAmount ?? 0),
//                   style: robotoMedium.copyWith(
//                     fontSize: Dimensions.fontSizeDefault,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//                 const SizedBox(height: Dimensions.paddingSizeSmall),
//                 Row(
//                   children: [
//                     Row(
//                       children: List.generate(5, (index) {
//                         return IconButton(
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                           icon: Icon(
//                             index < _rating ? Icons.star : Icons.star_border,
//                             color: Theme.of(context).colorScheme.primary,
//                             size: 18,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _rating = index + 1;
//                             });
//                           },
//                         );
//                       }),
//                     ),
//                     const SizedBox(width: Dimensions.paddingSizeSmall),
//                     ElevatedButton(
//                       onPressed: _submitReview,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Theme.of(context).colorScheme.primary,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: Dimensions.paddingSizeSmall,
//                           vertical: Dimensions.paddingSizeExtraSmall,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                         ),
//                         minimumSize: const Size(60, 30),
//                       ),
//                       child: Text(
//                         'submit'.tr,
//                         style: robotoRegular.copyWith(
//                           color: Theme.of(context).colorScheme.onPrimary,
//                           fontSize: Dimensions.fontSizeSmall,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 widget.bookingModel.bookingStatus?.tr ?? 'Completed',
//                 style: robotoMedium.copyWith(
//                   fontSize: Dimensions.fontSizeSmall,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:demandium/feature/booking/widget/booking_status_tabs.dart';

class RateScreen extends StatefulWidget {
  final bool isFromMenu;
  const RateScreen({super.key, this.isFromMenu = false});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<ServiceBookingController>().getAllBookingService(
      offset: 1,
      bookingStatus: "completed",
      isFromPagination: false,
      serviceType: "all",
    );
    Get.find<ServiceBookingController>().updateBookingStatusTabs(BookingStatusTabs.completed, firstTimeCall: false);
    Get.find<ServiceBookingController>().updateSelectedServiceType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
      appBar: CustomAppBar(
        isBackButtonExist: true, // Always show back button
        onBackPressed: () => Get.back(),
        title: 'Rate Card'.tr,
        actionWidget: const FilterPopUpMenuWidget(),
      ),
      body: GetBuilder<ServiceBookingController>(
        builder: (serviceBookingController) {
          List<BookingModel>? bookingList = serviceBookingController.bookingList;
          return CustomScrollView(
            controller: _scrollController,
            slivers: [


              SliverToBoxAdapter(
                child: SizedBox(
                  height: ResponsiveHelper.isDesktop(context)
                      ? Dimensions.paddingSizeDefault
                      : Dimensions.paddingSizeSmall,
                ),
              ),

              serviceBookingController.bookingList != null
                  ? SliverToBoxAdapter(
                child: bookingList!.isNotEmpty
                    ? Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: Dimensions.webMaxWidth,
                      minHeight: Get.height * 0.7,
                    ),
                    child: PaginatedListView(
                      scrollController: _scrollController,
                      totalSize: serviceBookingController.bookingContent!.total!,
                      onPaginate: (int offset) async =>
                      await serviceBookingController.getAllBookingService(
                        offset: offset,
                        bookingStatus: "completed",
                        isFromPagination: true,
                        serviceType: serviceBookingController.selectedServiceType.name,
                      ),
                      offset: serviceBookingController.bookingContent?.currentPage,
                      itemView: GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.isDesktop(context)
                              ? 0
                              : Dimensions.paddingSizeDefault,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 2 : 1,
                          mainAxisExtent: Get.find<LocalizationController>().isLtr ? 180 : 215,
                          crossAxisSpacing: Dimensions.paddingSizeDefault,
                          mainAxisSpacing: Dimensions.paddingSizeDefault,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: bookingList.length,
                        itemBuilder: (context, index) {
                          return BookingItemCard(
                            bookingModel: bookingList[index],
                            index: index,
                          );
                        },
                      ),
                    ),
                  ),
                )
                    : Center(
                  child: SizedBox(
                    height: Get.height * 0.7,
                    width: Dimensions.webMaxWidth,
                    child: NoDataScreen(
                      text: 'no_completed_booking_available'.tr,
                      type: NoDataType.bookings,
                    ),
                  ),
                ),
              )
                  : const SliverToBoxAdapter(
                child: Center(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: BookingListItemShimmer(),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: ResponsiveHelper.isDesktop(context)
                    ? const FooterView()
                    : const SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BookingListItemShimmer extends StatelessWidget {
  const BookingListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 2 : 1,
        mainAxisExtent: ResponsiveHelper.isDesktop(context) ? 130 : 120,
        crossAxisSpacing: Dimensions.paddingSizeDefault,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context)
            ? Dimensions.paddingSizeSmall
            : Dimensions.paddingSizeExtraSmall,
      ),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeSmall - 3,
            horizontal: ResponsiveHelper.isDesktop(context)
                ? 0
                : Dimensions.paddingSizeDefault,
          ),
          child: Shimmer(
            child: Container(
              height: 90,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).cardColor,
                boxShadow: Get.isDarkMode
                    ? null
                    : [
                  BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 17,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Container(
                          height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Container(
                          height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 17,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                        height: 15,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ServiceRequestTopTitle extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GetBuilder<ServiceBookingController>(
      builder: (serviceBookingController) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              serviceBookingController.selectedServiceType == ServiceType.regular
                  ? "regular_booking".tr
                  : serviceBookingController.selectedServiceType == ServiceType.repeat
                  ? "repeat_booking".tr
                  : "all_booking".tr,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class ServiceRequestSectionMenu extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: 8),
      child: GetBuilder<ServiceBookingController>(
        builder: (controller) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTab(context, controller, "all_booking", ServiceType.all),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                _buildTab(context, controller, "regular_booking", ServiceType.regular),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                _buildTab(context, controller, "repeat_booking", ServiceType.repeat),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab(BuildContext context, ServiceBookingController controller, String label, ServiceType type) {
    bool isSelected = controller.selectedServiceType == type;
    return InkWell(
      onTap: () {
        controller.updateSelectedServiceType(type: type);
        controller.getAllBookingService(
          offset: 1,
          bookingStatus: "completed",
          isFromPagination: false,
          serviceType: type.name,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor.withOpacity(0.3),
          ),
        ),
        child: Text(
          label.tr,
          style: robotoMedium.copyWith(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor,
            fontSize: Dimensions.fontSizeDefault,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class FilterPopUpMenuWidget extends StatelessWidget {
  const FilterPopUpMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceBookingController>(
      builder: (serviceBookingController) {
        List<String> bookingFilterList = [
          'all_booking',
          "regular_booking",
          "repeat_booking"
        ];

        return PopupMenuButton<String>(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
            side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
          ),
          surfaceTintColor: Theme.of(context).cardColor,
          position: PopupMenuPosition.under,
          elevation: 8,
          shadowColor: Theme.of(context).hintColor.withValues(alpha: 0.3),
          padding: EdgeInsets.zero,
          menuPadding: EdgeInsets.zero,
          itemBuilder: (BuildContext context) {
            return bookingFilterList.map((String option) {
              ServiceType type = option == "regular_booking"
                  ? ServiceType.regular
                  : option == "repeat_booking"
                  ? ServiceType.repeat
                  : ServiceType.all;
              return PopupMenuItem<String>(
                value: option,
                padding: EdgeInsets.zero,
                height: 45,
                child: serviceBookingController.selectedServiceType == type
                    ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: Get.isDarkMode ? 0.2 : 0.08),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        option.tr,
                        style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Text(option.tr, style: robotoRegular),
                ),
                onTap: () {
                  Get.find<ServiceBookingController>().updateSelectedServiceType(
                    type: option == "regular_booking"
                        ? ServiceType.regular
                        : option == "repeat_booking"
                        ? ServiceType.repeat
                        : ServiceType.all,
                  );
                },
              );
            }).toList();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Stack(
              alignment: AlignmentDirectional.center,
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.filter_list,
                  color: ResponsiveHelper.isDesktop(context)
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                if (serviceBookingController.selectedServiceType != ServiceType.all)
                  Positioned(
                    right: -5,
                    bottom: ResponsiveHelper.isDesktop(context) ? 0 : 13,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.circle, size: 13, color: Colors.white),
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BookingItemCard extends StatefulWidget {
  final BookingModel bookingModel;
  final int index;
  final bool showCommentField;

  const BookingItemCard({
    super.key,
    required this.bookingModel,
    required this.index,
    this.showCommentField = true,
  });

  @override
  State<BookingItemCard> createState() => _BookingItemCardState();
}

class _BookingItemCardState extends State<BookingItemCard> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    final reviewBody = ReviewBody(
      bookingID: widget.bookingModel.id!,
      rating: _rating.toInt().toString(),
      comment: widget.showCommentField ? _commentController.text.trim() : '',
      serviceID: widget.bookingModel.customerId.toString(),
    );

    print('Submitting review:');
    print('Booking ID: ${widget.bookingModel.id}');
    print('Service ID: ${widget.bookingModel.customerId}');
    print('Rating: $_rating');
    print('Comment: ${widget.showCommentField ? _commentController.text.trim() : ''}');

    final response = await Get.find<new_SubmitReviewRepo>().submitReview(reviewBody: reviewBody);

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit review')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text('${'booking'.tr}# ${widget.bookingModel.readableId}', style: robotoBold.copyWith()),
                      if (widget.bookingModel.isRepeatBooking == 1)
                        Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                          padding: const EdgeInsets.all(2),
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                          child: const Icon(Icons.repeat, color: Colors.white, size: 10),
                        ),
                    ],
                  ),
                  SizedBox(height:12),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      DateConverter.dateMonthYearTimeTwentyFourFormat(
                        DateConverter.isoUtcStringToLocalDate(widget.bookingModel.createdAt.toString()),
                      ),
                      textDirection: TextDirection.ltr,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(height:12),
              
                  Text(
                    PriceConverter.convertPrice(widget.bookingModel.totalBookingAmount ?? 0),
                    style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height:6),
              
                  /// ⭐ Star Rating Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                index < _rating ? Icons.star : Icons.star_border,
                                color: Theme.of(context).colorScheme.primary, // Fixed color issue
                                size: 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  _rating = index + 1;
                                });
                              },
                            );
                          }),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _submitReview,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall,
                              vertical: Dimensions.paddingSizeExtraSmall,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            minimumSize: const Size(60, 30),
                          ),
                          child: Text(
                            'submit'.tr,
                            style: robotoRegular.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  if (widget.showCommentField) ...[
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Write your review',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall,
                          vertical: Dimensions.paddingSizeExtraSmall,
                        ),
                      ),
                      maxLines: 2,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}


class new_SubmitReviewRepo{
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  new_SubmitReviewRepo({required this.sharedPreferences,required this.apiClient});

  Future<Response> submitReview({required ReviewBody reviewBody}) async {
    return await apiClient.postData(AppConstants.serviceReview, reviewBody.toJson());
  }
  Future<Response> getReviewList({required String bookingId}) async {
    return await apiClient.getData('${AppConstants.bookingReviewList}?booking_id=$bookingId');
  }
}



