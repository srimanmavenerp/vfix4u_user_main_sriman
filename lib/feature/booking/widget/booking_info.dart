// import 'package:demandium/feature/booking/view/web_booking_details_screen.dart';
// import 'package:demandium/feature/booking/widget/booking_status_widget.dart';
// import 'package:get/get.dart';
// import 'package:demandium/utils/core_export.dart';
//
// class BookingInfo extends StatelessWidget {
//   final BookingDetailsContent bookingDetails;
//   final bool isSubBooking;
//   final BookingDetailsController bookingDetailsTabController;
//
//   const BookingInfo({
//     Key? key,
//     required this.bookingDetails,
//     required this.bookingDetailsTabController,
//     required this.isSubBooking,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final DateTime currentTime = DateTime.now();
//     DateTime? serviceDateTime = DateTime.tryParse(bookingDetails.serviceSchedule ?? '');
//     bool showCancelButton = false;
//
//     if (serviceDateTime != null) {
//       final difference = serviceDateTime.difference(currentTime);
//       showCancelButton = difference.inMinutes > 60;
//     }
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//         boxShadow: Get.find<ThemeController>().darkTheme ? null : searchBoxShadow,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Top Row: Booking ID and Status
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '${'booking'.tr} #${bookingDetails.readableId}',
//                   style: robotoMedium.copyWith(
//                     fontSize: Dimensions.fontSizeLarge,
//                     color: Theme.of(context).textTheme.bodyLarge!.color,
//                   ),
//                 ),
//                 BookingStatusButtonWidget(
//                   bookingStatus: bookingDetails.bookingStatus,
//                 ),
//               ],
//             ),
//             Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
//
//             /// Booking Created Date
//             BookingItem(
//               img: Images.calendar1,
//               title: "${'booking_date'.tr} : ",
//               date: DateConverter.dateMonthYearTimeTwentyFourFormat(
//                 DateConverter.isoUtcStringToLocalDate(bookingDetails.createdAt!),
//               ),
//             ),
//             Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
//
//             /// Service Schedule
//             if (bookingDetails.serviceSchedule != null)
//               BookingItem(
//                 img: Images.calendar1,
//                 title: "${'service_schedule_date'.tr} : ",
//                 date: DateConverter.dateMonthYearTimeTwentyFourFormat(
//                   DateTime.tryParse(bookingDetails.serviceSchedule!)!,
//                 ),
//               ),
//             Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
//
//             /// Address
//             BookingItem(
//               img: Images.iconLocation,
//               title: '${'address'.tr} : ${bookingDetails.serviceAddress?.address ?? bookingDetails.subBooking?.serviceAddress?.address ?? 'no_address_found'.tr}',
//               date: '',
//             ),
//             Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
//
//             /// Conditional Buttons (Cancel, Pay)
//             if (bookingDetails.isPaid == 0 &&
//                 bookingDetails.bookingStatus != "canceled" &&
//                 bookingDetails.paymentMethod == "cash_after_service")
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   if (bookingDetails.bookingStatus == "accepted" && showCancelButton)
//                     ElevatedButton(
//                       onPressed: () {
//                         showCancelConfirmationDialog(
//                           context,
//                           bookingDetailsTabController,
//                           bookingDetails,
//                           isSubBooking,
//                         );
//                       },
//                       child: Text("cancel_booking".tr),
//                     ),
//                   ElevatedButton(
//                     onPressed: () {
//                       bookingDetailsTabController.showCustomPayViaOnlineDialog(bookingDetails.id);
//                     },
//                     child: Text("pay".tr),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:demandium/feature/booking/view/web_booking_details_screen.dart';
import 'package:demandium/feature/booking/widget/booking_status_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class BookingInfo extends StatelessWidget {
  final BookingDetailsContent bookingDetails;
  final bool isSubBooking;
  final BookingDetailsController bookingDetailsTabController;

  const BookingInfo({
    Key? key,
    required this.bookingDetails,
    required this.bookingDetailsTabController,
    required this.isSubBooking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime currentTime = DateTime.now();
    DateTime? serviceDateTime =
        DateTime.tryParse(bookingDetails.serviceSchedule ?? '');
    bool showCancelButton = false;
    if (serviceDateTime != null) {
      final difference = serviceDateTime.difference(currentTime);
      showCancelButton = difference.inMinutes > 60;
    }
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow:
            Get.find<ThemeController>().darkTheme ? null : searchBoxShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row: Booking ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${'booking'.tr} #${bookingDetails.readableId}',
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                BookingStatusButtonWidget(
                  bookingStatus: bookingDetails.bookingStatus,
                ),
              ],
            ),
            Gaps.verticalGapOf(Dimensions.paddingSizeSmall),

            /// Booking Created Date
            BookingItem(
              img: Images.calendar1,
              title: "${'booking_date'.tr} : ",
              date: DateConverter.dateMonthYearTimeTwentyFourFormat(
                DateConverter.isoUtcStringToLocalDate(
                    bookingDetails.createdAt!),
              ),
            ),
            Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),

            /// Service Schedule
            if (bookingDetails.serviceSchedule != null)
              BookingItem(
                img: Images.calendar1,
                title: "${'service_schedule_date'.tr} : ",
                date: DateConverter.dateMonthYearTimeTwentyFourFormat(
                  DateTime.tryParse(bookingDetails.serviceSchedule!)!,
                ),
              ),
            Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),

            /// Address
            BookingItem(
              img: Images.iconLocation,
              title:
                  '${'address'.tr} : ${bookingDetails.serviceAddress?.address ?? bookingDetails.subBooking?.serviceAddress?.address ?? 'no_address_found'.tr}',
              date: '',
            ),
            Gaps.verticalGapOf(Dimensions.paddingSizeSmall),

            /// Conditional Buttons (Cancel, Pay)
            if (bookingDetails.bookingStatus != "canceled")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// ✅ Show cancel button for all accepted bookings regardless of payment
                  if (bookingDetails.bookingStatus == "accepted")
                    ElevatedButton(
                      onPressed: () {
                        showCancelConfirmationDialog(
                          context,
                          bookingDetailsTabController,
                          bookingDetails,
                          isSubBooking,
                        );
                      },
                      child: Text("cancel_booking".tr),
                    ),

                  // if (bookingDetails.bookingStatus == "accepted" && bookingDetails.bookingStatus != "completed")
                  //   ElevatedButton(
                  //     onPressed: () {
                  //       showCancelConfirmationDialog(
                  //         context,
                  //         bookingDetailsTabController,
                  //         bookingDetails,
                  //         isSubBooking,
                  //       );
                  //     },
                  //     child: Text("cancel_booking".tr),
                  //   ),

                  /// 💰 Only show Pay button if not paid
                  if (bookingDetails.isPaid == 0)
                    ElevatedButton(
                      onPressed: () {
                        bookingDetailsTabController
                            .showCustomPayViaOnlineDialog(bookingDetails.id);
                      },
                      child: Text("pay".tr),
                    ),
                ],
              ),

            /// Conditional Buttons (Cancel, Pay)
            // if (bookingDetails.isPaid == 0 &&
            //     bookingDetails.bookingStatus != "canceled" &&
            //     bookingDetails.paymentMethod == "cash_after_service")
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       /// ✅ Always show cancel button when booking is accepted
            //       if (bookingDetails.bookingStatus == "accepted")
            //         ElevatedButton(
            //           onPressed: () {
            //             showCancelConfirmationDialog(
            //               context,
            //               bookingDetailsTabController,
            //               bookingDetails,
            //               isSubBooking,
            //             );
            //           },
            //           child: Text("cancel_booking".tr),
            //         ),
            //       ElevatedButton(
            //         onPressed: () {
            //           bookingDetailsTabController.showCustomPayViaOnlineDialog(bookingDetails.id);
            //         },
            //         child: Text("pay".tr),
            //       ),
            //     ],
            //   ),
          ],
        ),
      ),
    );
  }
}
