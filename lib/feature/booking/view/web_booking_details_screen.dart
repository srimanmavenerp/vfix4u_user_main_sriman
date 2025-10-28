// import 'package:demandium/feature/booking/widget/payment_info_widget.dart';
// import 'package:demandium/utils/core_export.dart';
// import 'package:demandium/feature/booking/widget/booking_otp_widget.dart';
// import 'package:demandium/feature/booking/widget/booking_screen_shimmer.dart';
// import 'package:demandium/feature/booking/widget/regular/booking_summery_widget.dart';
// import 'package:get/get.dart';
//
// class WebBookingDetailsScreen extends StatelessWidget {
//   final TabController? tabController;
//   final String? bookingId;
//   final bool isSubBooking;
//   const WebBookingDetailsScreen(
//       {super.key,
//         this.tabController,
//         this.bookingId,
//         required this.isSubBooking});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FooterBaseView(
//         child: GetBuilder<BookingDetailsController>(
//             builder: (bookingDetailsController) {
//               BookingDetailsContent? bookingDetails = isSubBooking
//                   ? bookingDetailsController.subBookingDetailsContent
//                   : bookingDetailsController.bookingDetailsContent;
//
//               if (bookingDetails != null) {
//                 return Center(
//                   child: SizedBox(
//                     width: Dimensions.webMaxWidth,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         BookingDetailsTopCard(
//                             bookingDetailsContent: bookingDetails),
//                         BookingTabBar(
//                           tabController: tabController,
//                           isSubBooking: isSubBooking,
//                         ),
//                         SizedBox(
//                           height: 650,
//                           child: TabBarView(controller: tabController, children: [
//                             WebBookingDetailsSection(
//                               bookingDetails: bookingDetails,
//                               isSubBooking: isSubBooking,
//                             ),
//                             BookingHistory(
//                               bookingId: bookingId,
//                               isSubBooking: isSubBooking,
//                             )
//                           ]),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               } else {
//                 return const Center(
//                     child: SizedBox(
//                         width: Dimensions.webMaxWidth,
//                         child: BookingScreenShimmer()));
//               }
//             }),
//       ),
//     );
//   }
// }
// class BookingDetailsTopCard extends StatelessWidget {
//   final BookingDetailsContent bookingDetailsContent;
//
//   // Constructor to receive the content
//   BookingDetailsTopCard({
//     super.key,
//     required this.bookingDetailsContent,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Assuming bookingDetailsRepo is available via dependency injection or context
//     final bookingDetailsRepo = Get.find<BookingDetailsRepo>(); // or pass it from the parent widget
//
//     // Use GetBuilder to listen to changes in BookingDetailsController
//     return GetBuilder<BookingDetailsController>(
//       init: BookingDetailsController(bookingDetailsRepo: bookingDetailsRepo), // Pass the repo here
//       builder: (controller) {
//         final currentTime = DateTime.now();
//         DateTime? serviceDateTime =
//         DateTime.tryParse(bookingDetailsContent.serviceSchedule ?? '');
//
//         bool showCancelButton = false;
//         if (serviceDateTime != null) {
//           final difference = serviceDateTime.difference(currentTime);
//           showCancelButton = difference.inMinutes > 60;
//         }
//
//         return Container(
//           decoration: BoxDecoration(
//             color: ResponsiveHelper.isDesktop(context)
//                 ? Theme.of(context).colorScheme.primary.withOpacity(0.07)
//                 : Theme.of(context).cardColor,
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(Dimensions.radiusLarge),
//               bottomRight: Radius.circular(Dimensions.radiusLarge),
//             ),
//           ),
//           width: Dimensions.webMaxWidth,
//           child: Column(
//             children: [
//               Gaps.verticalGapOf(Dimensions.paddingSizeExtraLarge),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     '${'booking'.tr} # ',
//                     style: robotoBold.copyWith(
//                       fontSize: Dimensions.fontSizeLarge,
//                       color: Theme.of(context).textTheme.bodyLarge!.color,
//                     ),
//                   ),
//                   Text(
//                     bookingDetailsContent.readableId ?? '',
//                     style: robotoBold.copyWith(
//                       fontSize: Dimensions.fontSizeLarge,
//                     ),
//                   ),
//                   if (bookingDetailsContent.isRepeatBooking == 1)
//                     Container(
//                       decoration: const BoxDecoration(
//                           shape: BoxShape.circle, color: Colors.green),
//                       padding: const EdgeInsets.all(2),
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: Dimensions.paddingSizeExtraSmall),
//                       child: const Icon(
//                         Icons.repeat,
//                         color: Colors.white,
//                         size: 12,
//                       ),
//                     )
//                 ],
//               ),
//               Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     '${'booking_place'.tr} : ',
//                     style: robotoMedium.copyWith(
//                         fontSize: Dimensions.fontSizeDefault,
//                         color: Theme.of(context).textTheme.bodyLarge!.color),
//                   ),
//                   Text(
//                     DateConverter.dateMonthYearTimeTwentyFourFormat(
//                       DateConverter.isoUtcStringToLocalDate(
//                           bookingDetailsContent.createdAt ?? ''),
//                     ),
//                     style: robotoRegular.copyWith(
//                         fontSize: Dimensions.fontSizeDefault),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: Dimensions.paddingSizeSmall),
//               if (bookingDetailsContent.serviceSchedule != null)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "${'service_scheduled_date'.tr} : ",
//                       style: robotoMedium.copyWith(
//                           fontSize: Dimensions.fontSizeDefault,
//                           color: Theme.of(context).textTheme.bodyLarge!.color),
//                     ),
//                     Text(
//                       DateConverter.dateMonthYearTimeTwentyFourFormat(
//                           serviceDateTime!),
//                       style: robotoRegular.copyWith(
//                           fontSize: Dimensions.fontSizeDefault),
//                     ),
//                   ],
//                 ),
//               if (bookingDetailsContent.serviceSchedule != null)
//                 const SizedBox(height: Dimensions.paddingSizeSmall),
//               SizedBox(
//                 width: Dimensions.webMaxWidth / 2,
//                 child: RichText(
//                   textAlign: TextAlign.center,
//                   text: TextSpan(
//                     text: '${'address'.tr} : ',
//                     style: robotoMedium.copyWith(
//                       fontSize: Dimensions.fontSizeDefault,
//                       color: Theme.of(context).textTheme.bodyLarge!.color,
//                     ),
//                     children: [
//                       TextSpan(
//                         text: bookingDetailsContent.serviceAddress?.address ??
//                             bookingDetailsContent.subBooking?.serviceAddress
//                                 ?.address ??
//                             'no_address_found'.tr,
//                         style: robotoRegular.copyWith(
//                             fontSize: Dimensions.fontSizeDefault),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: Dimensions.paddingSizeSmall),
//               RichText(
//                 text: TextSpan(
//                   text: '${'booking_status'.tr} : ',
//                   style: robotoMedium.copyWith(
//                     fontSize: Dimensions.fontSizeDefault,
//                     color: Theme.of(context).textTheme.bodyLarge!.color,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: controller.bookingDetailsContent!.bookingStatus?.tr,
//                       style: robotoMedium.copyWith(
//                         fontSize: Dimensions.fontSizeDefault,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (showCancelButton)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: Dimensions.paddingSizeDefault),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Show cancel confirmation dialog
//                       showCancelConfirmationDialog(
//                         context,
//                         controller, // Pass the controller here
//                         bookingDetailsContent,
//                         false, // Set to true if this is a sub-booking
//                       );
//                     },
//                     child: Text('Cancel Booking'),
//                   ),
//                 ),
//               Gaps.verticalGapOf(Dimensions.paddingSizeDefault),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class WebBookingDetailsSection extends StatelessWidget {
//   final BookingDetailsContent bookingDetails;
//   final bool isSubBooking;
//   const WebBookingDetailsSection(
//       {super.key, required this.bookingDetails, required this.isSubBooking});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(children: [
//         const SizedBox(height: Dimensions.paddingSizeDefault),
//         Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Expanded(
//               child: SizedBox(
//                 height: 630,
//                 child: SingleChildScrollView(
//                   child: BookingSummeryWidget(bookingDetails: bookingDetails),
//                 ),
//               )),
//           const SizedBox(width: Dimensions.paddingSizeDefault),
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 (Get.find<SplashController>()
//                     .configModel
//                     .content!
//                     .confirmationOtpStatus! &&
//                     (bookingDetails.bookingStatus == "accepted" ||
//                         bookingDetails.bookingStatus == "ongoing"))
//                     ? BookingOtpWidget(bookingDetails: bookingDetails)
//                     : const SizedBox(),
//
//                 (Get.find<SplashController>()
//                     .configModel
//                     .content!
//                     .confirmationOtpStatus! &&
//                     (bookingDetails.bookingStatus == "accepted" ||
//                         bookingDetails.bookingStatus == "ongoing"))
//                     ? const SizedBox()
//                     : const SizedBox(height: Dimensions.paddingSizeEight),
//
//                 PaymentView(
//                     bookingDetails: bookingDetails, isSubBooking: isSubBooking),
//                 const SizedBox(height: Dimensions.paddingSizeDefault),
//
//                 //const BookingCancelButton(),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     bookingDetails.provider != null
//                         ? SizedBox(
//                       height: 165,
//                       width: 285,
//                       child: Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                             color: Theme.of(context).cardColor,
//                             borderRadius: BorderRadius.circular(
//                                 Dimensions.radiusDefault),
//                             border: Border.all(
//                                 color: Theme.of(context)
//                                     .hintColor
//                                     .withValues(alpha: 0.3)),
//                             boxShadow: Get.find<ThemeController>()
//                                 .darkTheme
//                                 ? null
//                                 : searchBoxShadow), //boxShadow: shadow),
//                         child: Column(
//                           children: [
//                             Gaps.verticalGapOf(
//                                 Dimensions.paddingSizeDefault),
//                             Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal:
//                                     Dimensions.paddingSizeDefault),
//                                 child: Text("provider_info".tr,
//                                     style: robotoMedium.copyWith(
//                                         fontSize:
//                                         Dimensions.fontSizeSmall,
//                                         color: Theme.of(context)
//                                             .textTheme
//                                             .bodyLarge!
//                                             .color!))),
//                             Gaps.verticalGapOf(
//                                 Dimensions.paddingSizeSmall),
//                             ClipRRect(
//                               borderRadius: const BorderRadius.all(
//                                   Radius.circular(
//                                       Dimensions.paddingSizeExtraLarge)),
//                               child: SizedBox(
//                                 width: Dimensions.imageSize,
//                                 height: Dimensions.imageSize,
//                                 child: CustomImage(
//                                     image:
//                                     "${bookingDetails.provider?.logoFullPath}"),
//                               ),
//                             ),
//                             Gaps.verticalGapOf(
//                                 Dimensions.paddingSizeExtraSmall),
//                             Text(
//                                 "${bookingDetails.provider?.companyName}",
//                                 style: robotoBold.copyWith(
//                                     fontSize:
//                                     Dimensions.fontSizeExtraSmall)),
//                             Gaps.verticalGapOf(
//                                 Dimensions.paddingSizeExtraSmall),
//                             Text(
//                                 "${bookingDetails.provider?.companyPhone}",
//                                 style: robotoRegular.copyWith(
//                                     fontSize:
//                                     Dimensions.fontSizeExtraSmall)),
//                             Gaps.verticalGapOf(
//                                 Dimensions.paddingSizeDefault),
//                           ],
//                         ),
//                       ),
//                     )
//                         : const SizedBox(),
//                     bookingDetails.serviceman != null
//                         ? SizedBox(
//                       height: 165,
//                       width: 285,
//                       child: Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.all(
//                               Radius.circular(
//                                   Dimensions.paddingSizeExtraSmall)),
//                           color: Theme.of(context)
//                               .primaryColor
//                               .withValues(alpha: 0.05),
//                         ),
//                         child: Column(
//                           children: [
//                             Gaps.verticalGapOf(
//                                 Dimensions.paddingSizeDefault),
//                             Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal:
//                                     Dimensions.paddingSizeDefault),
//                                 child: Text("service_man_info".tr,
//                                     style: robotoMedium.copyWith(
//                                         fontSize:
//                                         Dimensions.fontSizeSmall,
//                                         color: Theme.of(context)
//                                             .textTheme
//                                             .bodyLarge!
//                                             .color!))),
//                             Gaps.verticalGapOf(
//                                 Dimensions.paddingSizeSmall),
//                             ClipRRect(
//                               borderRadius: const BorderRadius.all(
//                                   Radius.circular(
//                                       Dimensions.paddingSizeExtraLarge)),
//                               child: SizedBox(
//                                 width: Dimensions.imageSize,
//                                 height: Dimensions.imageSize,
//                                 child: CustomImage(
//                                     image: bookingDetails.serviceman?.user
//                                         ?.profileImageFullPath ??
//                                         ""),
//                               ),
//                             ),
//                             Gaps.verticalGapOf(
//                                 Dimensions.paddingSizeExtraSmall),
//                             Text(
//                                 "${bookingDetails.serviceman!.user?.firstName} ${bookingDetails.serviceman!.user?.lastName}",
//                                 style: robotoBold.copyWith(
//                                     fontSize:
//                                     Dimensions.fontSizeExtraSmall)),
//                             Gaps.verticalGapOf(
//                                 Dimensions.paddingSizeExtraSmall),
//                             Text(
//                                 "${bookingDetails.serviceman!.user!.phone}",
//                                 style: robotoRegular.copyWith(
//                                     fontSize:
//                                     Dimensions.fontSizeExtraSmall)),
//                             Gaps.verticalGapOf(
//                                 Dimensions.paddingSizeDefault),
//                           ],
//                         ),
//                       ),
//                     )
//                         : const SizedBox(),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ])
//       ]),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Get.find<AuthController>().isLoggedIn()
//           ? GetBuilder<BookingDetailsController>(
//           builder: (bookingDetailsController) {
//             return Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   const Expanded(child: SizedBox()),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                       bottom: Dimensions.paddingSizeDefault,
//                       left: Dimensions.paddingSizeDefault,
//                       right: Dimensions.paddingSizeDefault,
//                     ),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           FloatingActionButton(
//                             hoverColor: Colors.transparent,
//                             elevation: 0.0,
//                             backgroundColor:
//                             Theme.of(context).colorScheme.primary,
//                             onPressed: () {
//                               BookingDetailsContent? bookingDetailsContent =
//                               isSubBooking
//                                   ? bookingDetailsController
//                                   .subBookingDetailsContent
//                                   : bookingDetailsController
//                                   .bookingDetailsContent;
//
//                               if (bookingDetailsContent?.provider != null) {
//                                 showModalBottomSheet(
//                                   useRootNavigator: true,
//                                   isScrollControlled: true,
//                                   backgroundColor: Colors.transparent,
//                                   context: context,
//                                   builder: (context) => CreateChannelDialog(
//                                     isSubBooking: isSubBooking,
//                                   ),
//                                 );
//                               } else {
//                                 customSnackBar(
//                                     'provider_or_service_man_assigned'.tr,
//                                     type: ToasterMessageType.info);
//                               }
//                             },
//                             child: Icon(Icons.message_rounded,
//                                 color: Theme.of(context).primaryColorLight),
//                           ),
//                         ]),
//                   ),
//                   !ResponsiveHelper.isDesktop(context) &&
//                       bookingDetailsController
//                           .bookingDetailsContent!.bookingStatus ==
//                           'completed'
//                       ? Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(
//                           radius: 0,
//                           buttonText: 'review'.tr,
//                           onPressed: () {
//                             showModalBottomSheet(
//                               context: context,
//                               useRootNavigator: true,
//                               isScrollControlled: true,
//                               backgroundColor: Colors.transparent,
//                               builder: (context) =>
//                                   ReviewRecommendationDialog(
//                                     id: bookingDetailsController
//                                         .bookingDetailsContent!.id!,
//                                   ),
//                             );
//                           },
//                         ),
//                       ),
//                       Container(
//                         width: 3,
//                         height: 50,
//                         color: Theme.of(context).disabledColor,
//                       ),
//                       GetBuilder<ServiceBookingController>(
//                           builder: (serviceBookingController) {
//                             return Expanded(
//                               child: serviceBookingController.isLoading
//                                   ? const Center(
//                                   child: CircularProgressIndicator())
//                                   : CustomButton(
//                                 radius: 0,
//                                 buttonText: 'rebook'.tr,
//                                 onPressed: () {
//                                   serviceBookingController
//                                       .checkCartSubcategory(
//                                       bookingDetailsController
//                                           .bookingDetailsContent!
//                                           .id!,
//                                       bookingDetailsController
//                                           .bookingDetailsContent!
//                                           .subCategoryId!);
//                                 },
//                               ),
//                             );
//                           }),
//                     ],
//                   )
//                       : const SizedBox()
//                 ]);
//           })
//           : null,
//     );
//   }
// }
//
// void showCancelConfirmationDialog(
//     BuildContext context,
//     BookingDetailsController bookingDetailsController,
//     BookingDetailsContent bookingDetailsContent,
//     bool isSubBooking,
//     ) {
//   final List<CancelReason> cancelReasons =
//       bookingDetailsContent.cancelReasons ?? [];
//
//   String? selectedCancelReason =
//   cancelReasons.isNotEmpty ? cancelReasons.first.reason : null;
//   String? otherReason;
//
//   Get.dialog(
//     ConfirmationDialog(
//       icon: Images.deleteProfile,
//       title: 'are_you_sure_to_cancel_this_full_booking'.tr,
//       description: 'once_cancel_full_booking'.tr,
//       noButtonText: "yes_cancel".tr,
//       noButtonColor: Theme.of(context).colorScheme.primary,
//       noTextColor: Colors.white,
//       yesButtonText: "not_now".tr,
//       yesButtonColor: Theme.of(context).colorScheme.error,
//       yesTextColor: Colors.white,
//       onYesPressed: () {
//         Get.back(); // Close first dialog
//       },
//       onNoPressed: () {
//         Get.back(); // Close first dialog
//         Get.dialog(
//           StatefulBuilder(
//             builder: (context, setState) {
//               return AlertDialog(
//                 title: Text('Select Cancellation Reason'.tr),
//                 content: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ...cancelReasons.map((reason) {
//                         return RadioListTile<String>(
//                           value: reason.reason!,
//                           groupValue: selectedCancelReason,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedCancelReason = value;
//                               if (value != "Other") {
//                                 otherReason = null;
//                               }
//                             });
//                           },
//                           title: Text(reason.reason!.tr),
//                         );
//                       }).toList(),
//                       if (selectedCancelReason == "Other")
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10.0),
//                           child: TextField(
//                             onChanged: (value) {
//                               setState(() {
//                                 otherReason = value;
//                               });
//                             },
//                             decoration: InputDecoration(
//                               hintText: "Please Provide Reason".tr,
//                               border: const OutlineInputBorder(),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Get.back(),
//                     child: Text(
//                       "cancel".tr,
//                       style: TextStyle(
//                           color: Theme.of(context).colorScheme.error),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () async {
//                       String? reasonToSubmit = selectedCancelReason;
//
//                       if (reasonToSubmit == "Other") {
//                         if (otherReason == null ||
//                             otherReason!.trim().isEmpty) {
//                           Get.snackbar("error".tr, "Please Enter Reason".tr,
//                               snackPosition: SnackPosition.BOTTOM);
//                           return;
//                         }
//                         reasonToSubmit = otherReason;
//                       }
//
//                       if (reasonToSubmit != null &&
//                           reasonToSubmit.trim().isNotEmpty) {
//                         Get.dialog(const CustomLoader(),
//                             barrierDismissible: false);
//
//                         if (isSubBooking) {
//                           await bookingDetailsController.subBookingCancel(
//                             subBookingId: bookingDetailsContent.id ?? "",
//                           );
//                         } else {
//                           await bookingDetailsController.bookingCancel(
//                             bookingId: bookingDetailsContent.id ?? "",
//                             cancelReason: reasonToSubmit,
//                           );
//                         }
//
//                         Get.back(); // Close loader
//                         Get.back(); // Close alert dialog
//                       } else {
//                         Get.snackbar(
//                           'error'.tr,
//                           'Please select or enter reason'.tr,
//                           snackPosition: SnackPosition.BOTTOM,
//                         );
//                       }
//                     },
//                     child: Text(
//                       "submit".tr,
//                       style: TextStyle(
//                           color: Theme.of(context).colorScheme.primary),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     ),
//   );
// }



import 'package:demandium/feature/booking/widget/payment_info_widget.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:demandium/feature/booking/widget/booking_otp_widget.dart';
import 'package:demandium/feature/booking/widget/booking_screen_shimmer.dart';
import 'package:demandium/feature/booking/widget/regular/booking_summery_widget.dart';
import 'package:get/get.dart';

class WebBookingDetailsScreen extends StatelessWidget {
  final TabController? tabController;
  final String? bookingId;
  final bool isSubBooking;
  const WebBookingDetailsScreen({
    super.key,
    this.tabController,
    this.bookingId,
    required this.isSubBooking,
  });

  @override
  Widget build(BuildContext context) {
    // Register BookingDetailsRepo with required dependencies
    Get.put(BookingDetailsRepo(
      sharedPreferences: Get.find<SharedPreferences>(),
      apiClient: Get.find<ApiClient>(),
    ));

    return Scaffold(
      body: FooterBaseView(
        child: GetBuilder<BookingDetailsController>(
            builder: (bookingDetailsController) {
              BookingDetailsContent? bookingDetails = isSubBooking
                  ? bookingDetailsController.subBookingDetailsContent
                  : bookingDetailsController.bookingDetailsContent;

              if (bookingDetails != null) {
                return Center(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BookingDetailsTopCard(
                            bookingDetailsContent: bookingDetails),
                        BookingTabBar(
                          tabController: tabController,
                          isSubBooking: isSubBooking,
                        ),
                        SizedBox(
                          height: 650,
                          child: TabBarView(controller: tabController, children: [
                            WebBookingDetailsSection(
                              bookingDetails: bookingDetails,
                              isSubBooking: isSubBooking,
                            ),
                            BookingHistory(
                              bookingId: bookingId,
                              isSubBooking: isSubBooking,
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                    child: SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: BookingScreenShimmer()));
              }
            }),
      ),
    );
  }
}

class BookingDetailsTopCard extends StatelessWidget {
  final BookingDetailsContent bookingDetailsContent;

  const BookingDetailsTopCard({
    super.key,
    required this.bookingDetailsContent,
  });

  @override
  Widget build(BuildContext context) {
    final bookingDetailsRepo = Get.find<BookingDetailsRepo>();

    return GetBuilder<BookingDetailsController>(
      init: BookingDetailsController(bookingDetailsRepo: bookingDetailsRepo),
      builder: (controller) {
        final currentTime = DateTime.now();
        DateTime? serviceDateTime =
        DateTime.tryParse(bookingDetailsContent.serviceSchedule ?? '');

        bool showCancelButton = false;
        if (serviceDateTime != null &&
            bookingDetailsContent.bookingStatus != "completed" &&
            bookingDetailsContent.bookingStatus != "canceled") {
          final difference = serviceDateTime.difference(currentTime);
          showCancelButton = difference.inMinutes > 60;
        }

        return Container(
          decoration: BoxDecoration(
            color: ResponsiveHelper.isDesktop(context)
                ? Theme.of(context).colorScheme.primary.withOpacity(0.07)
                : Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(Dimensions.radiusLarge),
              bottomRight: Radius.circular(Dimensions.radiusLarge),
            ),
          ),
          width: Dimensions.webMaxWidth,
          child: Column(
            children: [
              Gaps.verticalGapOf(Dimensions.paddingSizeExtraLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${'booking'.tr} # ',
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  Text(
                    bookingDetailsContent.readableId ?? '',
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                  if (bookingDetailsContent.isRepeatBooking == 1)
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green),
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeExtraSmall),
                      child: const Icon(
                        Icons.repeat,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                ],
              ),
              Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${'booking_place'.tr} : ',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                  Text(
                    DateConverter.dateMonthYearTimeTwentyFourFormat(
                      DateConverter.isoUtcStringToLocalDate(
                          bookingDetailsContent.createdAt ?? ''),
                    ),
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              if (bookingDetailsContent.serviceSchedule != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${'service_scheduled_date'.tr} : ",
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                    Text(
                      DateConverter.dateMonthYearTimeTwentyFourFormat(
                          serviceDateTime!),
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault),
                    ),
                  ],
                ),
              if (bookingDetailsContent.serviceSchedule != null)
                const SizedBox(height: Dimensions.paddingSizeSmall),
              SizedBox(
                width: Dimensions.webMaxWidth / 2,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: '${'address'.tr} : ',
                    style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    children: [
                      TextSpan(
                        text: bookingDetailsContent.serviceAddress?.address ??
                            bookingDetailsContent.subBooking?.serviceAddress
                                ?.address ??
                            'no_address_found'.tr,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              RichText(
                text: TextSpan(
                  text: '${'booking_status'.tr} : ',
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                  children: [
                    TextSpan(
                      text: controller.bookingDetailsContent!.bookingStatus?.tr,
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              if (showCancelButton)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeDefault),
                  child: ElevatedButton(
                    onPressed: () {
                      showCancelConfirmationDialog(
                        context,
                        controller,
                        bookingDetailsContent,
                        false,
                      );
                    },
                    child: Text('Cancel Booking'),
                  ),
                ),
              Gaps.verticalGapOf(Dimensions.paddingSizeDefault),
            ],
          ),
        );
      },
    );
  }
}

class WebBookingDetailsSection extends StatelessWidget {
  final BookingDetailsContent bookingDetails;
  final bool isSubBooking;
  const WebBookingDetailsSection({
    super.key,
    required this.bookingDetails,
    required this.isSubBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const SizedBox(height: Dimensions.paddingSizeDefault),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: SizedBox(
                height: 630,
                child: SingleChildScrollView(
                  child: BookingSummeryWidget(bookingDetails: bookingDetails),
                ),
              )),
          const SizedBox(width: Dimensions.paddingSizeDefault),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (Get.find<SplashController>()
                    .configModel
                    .content!
                    .confirmationOtpStatus! &&
                    (bookingDetails.bookingStatus == "accepted" ||
                        bookingDetails.bookingStatus == "ongoing"))
                    ? BookingOtpWidget(bookingDetails: bookingDetails)
                    : const SizedBox(),
                (Get.find<SplashController>()
                    .configModel
                    .content!
                    .confirmationOtpStatus! &&
                    (bookingDetails.bookingStatus == "accepted" ||
                        bookingDetails.bookingStatus == "ongoing"))
                    ? const SizedBox()
                    : const SizedBox(height: Dimensions.paddingSizeEight),
                PaymentView(
                    bookingDetails: bookingDetails, isSubBooking: isSubBooking),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    bookingDetails.provider != null
                        ? SizedBox(
                      height: 165,
                      width: 285,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(
                                Dimensions.radiusDefault),
                            border: Border.all(
                                color: Theme.of(context)
                                    .hintColor
                                    .withValues(alpha: 0.3)),
                            boxShadow: Get.find<ThemeController>()
                                .darkTheme
                                ? null
                                : searchBoxShadow),
                        child: Column(
                          children: [
                            Gaps.verticalGapOf(
                                Dimensions.paddingSizeDefault),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                    Dimensions.paddingSizeDefault),
                                child: Text("provider_info".tr,
                                    style: robotoMedium.copyWith(
                                        fontSize:
                                        Dimensions.fontSizeSmall,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!))),
                            Gaps.verticalGapOf(
                                Dimensions.paddingSizeSmall),
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                      Dimensions.paddingSizeExtraLarge)),
                              child: SizedBox(
                                width: Dimensions.imageSize,
                                height: Dimensions.imageSize,
                                child: CustomImage(
                                    image:
                                    "${bookingDetails.provider?.logoFullPath}"),
                              ),
                            ),
                            Gaps.verticalGapOf(
                                Dimensions.paddingSizeExtraSmall),
                            Text(
                                "${bookingDetails.provider?.companyName}",
                                style: robotoBold.copyWith(
                                    fontSize:
                                    Dimensions.fontSizeExtraSmall)),
                            Gaps.verticalGapOf(
                                Dimensions.paddingSizeExtraSmall),
                            Text(
                                "${bookingDetails.provider?.companyPhone}",
                                style: robotoRegular.copyWith(
                                    fontSize:
                                    Dimensions.fontSizeExtraSmall)),
                            Gaps.verticalGapOf(
                                Dimensions.paddingSizeDefault),
                          ],
                        ),
                      ),
                    )
                        : const SizedBox(),
                    bookingDetails.serviceman != null
                        ? SizedBox(
                      height: 165,
                      width: 285,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(
                                  Dimensions.paddingSizeExtraSmall)),
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.05),
                        ),
                        child: Column(
                          children: [
                            Gaps.verticalGapOf(
                                Dimensions.paddingSizeDefault),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                    Dimensions.paddingSizeDefault),
                                child: Text("service_man_info".tr,
                                    style: robotoMedium.copyWith(
                                        fontSize:
                                        Dimensions.fontSizeSmall,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!))),
                            Gaps.verticalGapOf(
                                Dimensions.paddingSizeSmall),
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                      Dimensions.paddingSizeExtraLarge)),
                              child: SizedBox(
                                width: Dimensions.imageSize,
                                height: Dimensions.imageSize,
                                child: CustomImage(
                                    image: bookingDetails.serviceman?.user
                                        ?.profileImageFullPath ??
                                        ""),
                              ),
                            ),
                            Gaps.verticalGapOf(
                                Dimensions.paddingSizeExtraSmall),
                            Text(
                                "${bookingDetails.serviceman!.user?.firstName} ${bookingDetails.serviceman!.user?.lastName}",
                                style: robotoBold.copyWith(
                                    fontSize:
                                    Dimensions.fontSizeExtraSmall)),
                            Gaps.verticalGapOf(
                                Dimensions.paddingSizeExtraSmall),
                            Text(
                                "${bookingDetails.serviceman!.user!.phone}",
                                style: robotoRegular.copyWith(
                                    fontSize:
                                    Dimensions.fontSizeExtraSmall)),
                            Gaps.verticalGapOf(
                                Dimensions.paddingSizeDefault),
                          ],
                        ),
                      ),
                    )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Get.find<AuthController>().isLoggedIn()
          ? GetBuilder<BookingDetailsController>(
          builder: (bookingDetailsController) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: Dimensions.paddingSizeDefault,
                      left: Dimensions.paddingSizeDefault,
                      right: Dimensions.paddingSizeDefault,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                            hoverColor: Colors.transparent,
                            elevation: 0.0,
                            backgroundColor:
                            Theme.of(context).colorScheme.primary,
                            onPressed: () {
                              BookingDetailsContent? bookingDetailsContent =
                              isSubBooking
                                  ? bookingDetailsController
                                  .subBookingDetailsContent
                                  : bookingDetailsController
                                  .bookingDetailsContent;

                              if (bookingDetailsContent?.provider != null) {
                                showModalBottomSheet(
                                  useRootNavigator: true,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => CreateChannelDialog(
                                    isSubBooking: isSubBooking,
                                  ),
                                );
                              } else {
                                customSnackBar(
                                    'provider_or_service_man_assigned'.tr,
                                    type: ToasterMessageType.info);
                              }
                            },
                            child: Icon(Icons.message_rounded,
                                color: Theme.of(context).primaryColorLight),
                          ),
                        ]),
                  ),
                  !ResponsiveHelper.isDesktop(context) &&
                      bookingDetailsController
                          .bookingDetailsContent!.bookingStatus ==
                          'completed'
                      ? Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          radius: 0,
                          buttonText: 'review'.tr,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              useRootNavigator: true,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  ReviewRecommendationDialog(
                                    id: bookingDetailsController
                                        .bookingDetailsContent!.id!,
                                  ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 3,
                        height: 50,
                        color: Theme.of(context).disabledColor,
                      ),
                      GetBuilder<ServiceBookingController>(
                          builder: (serviceBookingController) {
                            return Expanded(
                              child: serviceBookingController.isLoading
                                  ? const Center(
                                  child: CircularProgressIndicator())
                                  : CustomButton(
                                radius: 0,
                                buttonText: 'rebook'.tr,
                                onPressed: () {
                                  serviceBookingController
                                      .checkCartSubcategory(
                                      bookingDetailsController
                                          .bookingDetailsContent!
                                          .id!,
                                      bookingDetailsController
                                          .bookingDetailsContent!
                                          .subCategoryId!);
                                },
                              ),
                            );
                          }),
                    ],
                  )
                      : const SizedBox(),
                ]);
          })
          : null,
    );
  }
}

void showCancelConfirmationDialog(
    BuildContext context,
    BookingDetailsController bookingDetailsController,
    BookingDetailsContent bookingDetailsContent,
    bool isSubBooking,
    ) {
  final List<CancelReason> cancelReasons =
      bookingDetailsContent.cancelReasons ?? [];

  String? selectedCancelReason =
  cancelReasons.isNotEmpty ? cancelReasons.first.reason : null;
  String? otherReason;

  Get.dialog(
    ConfirmationDialog(
      icon: Images.deleteProfile,
      title: 'are_you_sure_to_cancel_this_full_booking'.tr,
      description: 'once_cancel_full_booking'.tr,
      noButtonText: "yes_cancel".tr,
      noButtonColor: Theme.of(context).colorScheme.primary,
      noTextColor: Colors.white,
      yesButtonText: "not_now".tr,
      yesButtonColor: Theme.of(context).colorScheme.error,
      yesTextColor: Colors.white,
      onYesPressed: () {
        Get.back();
      },
      onNoPressed: () {
        Get.back();
        Get.dialog(
          StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Select Cancellation Reason'.tr),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...cancelReasons.map((reason) {
                        return RadioListTile<String>(
                          value: reason.reason!,
                          groupValue: selectedCancelReason,
                          onChanged: (value) {
                            setState(() {
                              selectedCancelReason = value;
                              if (value != "Other") {
                                otherReason = null;
                              }
                            });
                          },
                          title: Text(reason.reason!.tr),
                        );
                      }).toList(),
                      if (selectedCancelReason == "Other")
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                otherReason = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Please Provide Reason".tr,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "cancel".tr,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      String? reasonToSubmit = selectedCancelReason;

                      if (reasonToSubmit == "Other") {
                        if (otherReason == null ||
                            otherReason!.trim().isEmpty) {
                          Get.snackbar("error".tr, "Please Enter Reason".tr,
                              snackPosition: SnackPosition.BOTTOM);
                          return;
                        }
                        reasonToSubmit = otherReason;
                      }

                      if (reasonToSubmit != null &&
                          reasonToSubmit.trim().isNotEmpty) {
                        Get.dialog(const CustomLoader(),
                            barrierDismissible: false);

                        if (isSubBooking) {
                          await bookingDetailsController.subBookingCancel(
                            subBookingId: bookingDetailsContent.id ?? "",
                          );
                        } else {
                          await bookingDetailsController.bookingCancel(
                            bookingId: bookingDetailsContent.id ?? "",
                            cancelReason: reasonToSubmit,
                          );
                        }

                        Get.back();
                        Get.back();
                      } else {
                        Get.snackbar(
                          'error'.tr,
                          'Please select or enter reason'.tr,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: Text(
                      "submit".tr,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    ),
  );
}
