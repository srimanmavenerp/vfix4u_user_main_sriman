// import 'package:get/get.dart';
// import 'package:demandium/utils/core_export.dart';
//
// class CompletePage extends StatelessWidget {
//   final String? token;
//   final String? phoneNumber; // Accept phoneNumber as a parameter
//   final String? bookingID; // Accept bookingID as a parameter
//
//   const CompletePage({super.key, this.token, this.phoneNumber, this.bookingID});
//
//   @override
//   Widget build(BuildContext context) {
//     final bookingController = Get.find<BookingDetailsController>();
//
//     return Padding(
//       padding:
//           const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GetBuilder<CheckOutController>(builder: (controller) {
//               return Column(
//                 children: [
//                   const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
//                   Image.asset(Images.orderComplete, scale: 4.5),
//                   const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
//                   Text(
//                     controller.isPlacedOrderSuccessfully
//                         ? 'you_placed_the_booking_successfully'.tr
//                         : 'your_bookings_is_failed_to_place'.tr,
//                     style: robotoBold.copyWith(
//                       fontSize: Dimensions.fontSizeExtraLarge,
//                       color: controller.isPlacedOrderSuccessfully
//                           ? null
//                           : Theme.of(context).colorScheme.error,
//                     ),
//                   ),
//                   if (controller.bookingReadableId.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: Dimensions.paddingSizeDefault),
//                       child: Text(
//                         "${'booking_id'.tr} ${controller.bookingReadableId}",
//                         style: robotoBold.copyWith(
//                           fontSize: Dimensions.fontSizeExtraLarge,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
//                   CustomButton(
//                     buttonText: "explore_more_service".tr,
//                     width: 280,
//                     backgroundColor: Theme.of(context)
//                         .colorScheme
//                         .primary
//                         .withValues(alpha: 0.1),
//                     textStyle: robotoRegular.copyWith(
//                       fontSize: Dimensions.fontSizeDefault,
//                       color: Theme.of(context)
//                           .textTheme
//                           .bodyLarge
//                           ?.color
//                           ?.withValues(alpha: 0.8),
//                     ),
//                     onPressed: () {
//                       Get.find<CheckOutController>()
//                           .updateState(PageState.orderDetails);
//                       Get.offAllNamed(RouteHelper.getMainRoute('home'));
//                     },
//                   ),
//                   const SizedBox(height: Dimensions.paddingSizeLarge),
//                   // Track Booking Button
//                   CustomButton(
//                     buttonText: "track_booking".tr, // Translation key here
//                     width: 280,
//                     backgroundColor: Theme.of(context)
//                         .colorScheme
//                         .secondary
//                         .withValues(alpha: 0.1),
//                     textStyle: robotoRegular.copyWith(
//                       fontSize: Dimensions.fontSizeDefault,
//                       color: Theme.of(context)
//                           .textTheme
//                           .bodyLarge
//                           ?.color
//                           ?.withValues(alpha: 0.8),
//                     ),
//                     onPressed: () async {
//                       // Ensure the phoneNumber is properly formatted
//                       String phoneWithCode = "${phoneNumber?.trim()}";
//                       String bookingCode = controller.bookingReadableId;
//                       print('---book---$bookingCode');
//                       // Navigate to the booking details screen with the fetched booking details
//                       Get.toNamed(RouteHelper.getBookingDetailsScreen(
//                         bookingID: bookingCode,
//                       ));
//                     },
//                   ),
//
//                   // CustomButton(
//                   //   buttonText: "track_booking".tr,
//                   //   width: 280,
//                   //   backgroundColor: Theme.of(context)
//                   //       .colorScheme
//                   //       .secondary
//                   //       .withOpacity(0.1), // Changed from .withValues() to .withOpacity() for simplicity and clarity
//                   //   textStyle: robotoRegular.copyWith(
//                   //     fontSize: Dimensions.fontSizeDefault,
//                   //     color: Theme.of(context)
//                   //         .textTheme
//                   //         .bodyLarge
//                   //         ?.color
//                   //         ?.withOpacity(0.8),
//                   //   ),
//                   //   onPressed: () {
//                   //     Get.to(() => BookingListScreen(isFromMenu: true));
//                   //   },
//                   // ),
//
//                 ],
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class CompletePage extends StatelessWidget {
  final String? token;
  final String? phoneNumber; // Accept phoneNumber as a parameter
  final String? bookingID; // Accept bookingID as a parameter
  final AddressModel? previousAddress; // Add previousAddress as a parameter
  final bool showServiceNotAvailableDialog; // Add showServiceNotAvailableDialog as a parameter

  const CompletePage({
    super.key,
    this.token,
    this.phoneNumber,
    this.bookingID,
    this.previousAddress, // Pass previousAddress here
    required this.showServiceNotAvailableDialog, // Pass showServiceNotAvailableDialog here
  });

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.find<BookingDetailsController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<CheckOutController>(builder: (controller) {
              return Column(
                children: [
                  const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                  Image.asset(Images.orderComplete, scale: 4.5),
                  const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                  Text(
                    controller.isPlacedOrderSuccessfully
                        ? 'you_placed_the_booking_successfully'.tr
                        : 'your_bookings_is_failed_to_place'.tr,
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      color: controller.isPlacedOrderSuccessfully
                          ? null
                          : Theme.of(context).colorScheme.error,
                    ),
                  ),
                  if (controller.bookingReadableId.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeDefault),
                      child: Text(
                        "${'booking_id'.tr} ${controller.bookingReadableId}",
                        style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                  CustomButton(
                    buttonText: "explore_more_service".tr,
                    width: 280,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    textStyle: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color
                          ?.withValues(alpha: 0.8),
                    ),
                    onPressed: () {
                      Get.find<CheckOutController>()
                          .updateState(PageState.orderDetails);
                      Get.offAllNamed(RouteHelper.getMainRoute('home'));
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  // Track Booking Button
                  CustomButton(
                      buttonText: "track_booking".tr, // Translation key here
                      width: 280,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.1),
                      textStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.color
                            ?.withValues(alpha: 0.8),
                      ),
                      // onPressed: () async {
                      //   // Ensure the phoneNumber is properly formatted
                      //   String phoneWithCode = "${phoneNumber?.trim()}";
                      //   String bookingCode = controller.bookingReadableId;
                      //   print('---book---$bookingCode');
                      //
                      //   Get.to(() =>  BookingListScreen(
                      //     isFromMenu: false,
                      //     initialTab: BookingStatusTabs.pending,
                      //   ));
                      //
                      //
                      //   // Navigate to the BottomNavScreen with the `bookings` page selected (pageIndex = 1)
                      //   // Get.to(() => BottomNavScreen(
                      //   //   pageIndex: 1, // Set pageIndex to 1 to navigate to the bookings page
                      //   //   previousAddress: previousAddress, // Pass the correct previousAddress parameter
                      //   //   showServiceNotAvailableDialog: showServiceNotAvailableDialog, // Pass the correct flag
                      //   // ));
                      // },

                      onPressed: () async {
                        String phoneWithCode = "${phoneNumber?.trim()}";
                        String bookingCode = controller.bookingReadableId;
                        print('---book---$bookingCode');

                        // Navigate to BottomNavScreen (with pageIndex 1 for the bookings page)
                        Get.to(() => BottomNavScreen(
                          pageIndex: 1, // BookingListScreen is at index 1
                          previousAddress: previousAddress,
                          showServiceNotAvailableDialog: showServiceNotAvailableDialog,
                          initialBookingTab: BookingStatusTabs.pending, // Pass the initial tab value here
                        ));
                      }

                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
