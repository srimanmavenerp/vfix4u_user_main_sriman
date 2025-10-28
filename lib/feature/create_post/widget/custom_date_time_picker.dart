// import 'package:demandium/utils/core_export.dart';
// import 'package:demandium/feature/create_post/widget/custom_date_picker.dart';
// import 'package:demandium/feature/create_post/widget/custom_time_picker.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//
// class CustomDateTimePicker extends StatelessWidget {
//   const CustomDateTimePicker({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     if (ResponsiveHelper.isDesktop(context)) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
//         ),
//         insetPadding: const EdgeInsets.all(30),
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         child: pointerInterceptor(),
//       );
//     }
//     return pointerInterceptor();
//   }
//
//   Widget pointerInterceptor() {
//     Get.find<ScheduleController>().setInitialScheduleValue();
//     ConfigModel configModel = Get.find<SplashController>().configModel;
//     var dateRangePickerController = DateRangePickerController();
//
//     if (Get.find<ScheduleController>().selectedDate.isNotEmpty) {
//       dateRangePickerController.selectedDate = DateFormat('yyyy-MM-dd')
//           .parse(Get.find<ScheduleController>().selectedDate);
//     }
//
//     return Container(
//       width: ResponsiveHelper.isDesktop(Get.context!)
//           ? Dimensions.webMaxWidth / 2
//           : Dimensions.webMaxWidth,
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(Dimensions.radiusLarge),
//           topRight: Radius.circular(Dimensions.radiusLarge),
//         ),
//         color: Theme.of(Get.context!).cardColor,
//       ),
//       padding: const EdgeInsets.all(10), // Reduced padding
//       child: GetBuilder<ScheduleController>(builder: (scheduleController) {
//         return SingleChildScrollView(
//           child: Column(
//             // mainAxisSize: MainAxisSize.min,
//             children: [
//               /// Date Picker
//               CustomDatePicker(
//                 dateRangePickerController: dateRangePickerController,
//               ),
//
//               /// Time Picker
//               CustomTimePicker(),
//
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: actionButtonWidget(Get.context!, scheduleController),
//               ),
//
//
//               /// ASAP Button if enabled
//
//
//               if (configModel.content?.instantBooking == 1)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Divider(
//                       color: Theme.of(Get.context!).hintColor,
//                       thickness: 0.5,
//                       height: 0.5,
//                     ),
//                     const SizedBox(height: 10),
//                     CustomButton(
//                       width: 100,
//                       //height: 40,
//                       radius: Dimensions.radiusExtraMoreLarge,
//                       backgroundColor:
//                       scheduleController.initialSelectedScheduleType ==
//                           ScheduleType.asap
//                           ? Theme.of(Get.context!).colorScheme.primary
//                           : Theme.of(Get.context!).disabledColor,
//                       buttonText: "ASAP".tr.toUpperCase(),
//                       onPressed: () {
//                         scheduleController.updateScheduleType(
//                             scheduleType: ScheduleType.asap);
//                         dateRangePickerController.selectedDate = null;
//                       },
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   /// Compact OK/CANCEL button row
//   Widget actionButtonWidget(
//       BuildContext context, ScheduleController scheduleController) {
//     return Padding(
//       padding: const EdgeInsets.all(40.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           TextButton(
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               minimumSize: const Size(0, 0),
//             ),
//             onPressed: () => Get.back(),
//             child: Text(
//               'cancel'.tr.toUpperCase(),
//               style: robotoMedium.copyWith(
//                 fontSize: 15,
//                 color: Get.isDarkMode
//                     ? Theme.of(context).primaryColorLight
//                     : Colors.black.withOpacity(0.8),
//               ),
//             ),
//           ),
//           CustomButton(
//               width: 70,
//               height: 36,
//               radius: Dimensions.radiusExtraMoreLarge,
//               buttonText: "ok".tr.toUpperCase(),
//
//               // onPressed: () {
//               //   ConfigModel config = Get.find<SplashController>().configModel;
//               //
//               //   if (scheduleController.initialSelectedScheduleType == null ||
//               //       scheduleController.selectedDate == '') {
//               //     customSnackBar('select_your_preferable_booking_time'.tr,
//               //         showDefaultSnackBar: false);
//               //
//               //   } else if (config.content!.advanceBooking != null &&
//               //       config.content?.scheduleBookingTimeRestriction == 1 &&
//               //       scheduleController.initialSelectedScheduleType !=
//               //           ScheduleType.asap) {
//               //     if (scheduleController.checkValidityOfTimeRestriction(
//               //         config.content!.advanceBooking!) !=
//               //         null) {
//               //       customSnackBar(
//               //           scheduleController.checkValidityOfTimeRestriction(
//               //               config.content!.advanceBooking!),
//               //           showDefaultSnackBar: false);
//               //     } else {
//               //       scheduleController.buildSchedule(
//               //           scheduleType: ScheduleType.schedule);
//               //       Get.back();
//               //     }
//               //   }
//               //
//               //   else {
//               //     customSnackBar("Please select a time between 9:00 AM and 11:00 PM", type: ToasterMessageType.error);
//               //   }
//               //
//               //   // else {
//               //   //   scheduleController.buildSchedule(
//               //   //       scheduleType: scheduleController.selectedScheduleType);
//               //   //   Get.back();
//               //   // }
//               // },
//
//               // onPressed: () {
//               //   ConfigModel config = Get.find<SplashController>().configModel;
//               //
//               //   // Basic validation
//               //   if (scheduleController.initialSelectedScheduleType == null ||
//               //       scheduleController.selectedDate.isEmpty) {
//               //     customSnackBar('select_your_preferable_booking_time TTTTTTTTTTTTTTTTTTTTTT'.tr,
//               //         showDefaultSnackBar: false);
//               //     return;
//               //   }
//               //
//               //   // Time restriction validation
//               //   if (config.content?.advanceBooking != null &&
//               //       config.content?.scheduleBookingTimeRestriction == 1 &&
//               //       scheduleController.initialSelectedScheduleType != ScheduleType.asap) {
//               //     String? restrictionError = scheduleController.checkValidityOfTimeRestriction(
//               //         config.content!.advanceBooking!);
//               //
//               //     if (restrictionError != null) {
//               //       customSnackBar(restrictionError, showDefaultSnackBar: false);
//               //       return;
//               //     }
//               //   }
//               //
//               //   // If everything is valid, proceed
//               //   scheduleController.buildSchedule(scheduleType: ScheduleType.schedule);
//               //   Get.back();
//               // }
//
//               onPressed: () {
//                 ConfigModel config = Get.find<SplashController>().configModel;
//
//                 // Basic validation
//                 if (scheduleController.initialSelectedScheduleType == null ||
//                     scheduleController.selectedDate.isEmpty) {
//                   customSnackBar(
//                     'select_your_preferable_booking_time'.tr +
//                         ' Please select a time between 9:00 AM and 11:00 PMra.',
//                     showDefaultSnackBar: false,
//                   );
//
//                   // Optional: Reset selected time to force user to reselect
//                   // scheduleController.clearTime(); // <- Make sure this method exists to clear time
//                   scheduleController.update(); // <- Update UI
//                   return;
//                 }
//
//                 // Time restriction validation
//                 if (config.content?.advanceBooking != null &&
//                     config.content?.scheduleBookingTimeRestriction == 1 &&
//                     scheduleController.initialSelectedScheduleType != ScheduleType.asap) {
//
//                   if (scheduleController.selectedTime.isEmpty) {
//                     customSnackBar('please_select_time'.tr, showDefaultSnackBar: false);
//                     scheduleController.update(); // Ensure UI updates
//                     return;
//                   }
//
//                   String? restrictionError = scheduleController.checkValidityOfTimeRestriction(
//                     config.content!.advanceBooking!,
//                     scheduleController.selectedDate,
//                     scheduleController.selectedTime,
//                   );
//
//                   if (restrictionError != null) {
//                     customSnackBar(restrictionError, showDefaultSnackBar: false);
//
//                     // Clear invalid selection and refresh UI
//                     // scheduleController.clearTime(); // You define this to reset selectedTime
//                     scheduleController.update();
//                     return;
//                   }
//                 }
//
//                 // Valid case: Build schedule and close
//                 scheduleController.buildSchedule(scheduleType: ScheduleType.schedule);
//                 Get.back();
//               }
//
//
//
//           ),
//         ],
//       ),
//     );
//   }
// }
/////below code saif

///new code



import 'package:demandium/utils/core_export.dart';
import 'package:demandium/feature/create_post/widget/custom_date_picker.dart';
import 'package:demandium/feature/create_post/widget/custom_time_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDateTimePicker extends StatelessWidget {
  const CustomDateTimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        ),
        insetPadding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: pointerInterceptor(),
      );
    }
    return pointerInterceptor();
  }

  Widget pointerInterceptor() {
    Get.find<ScheduleController>().setInitialScheduleValue();
    ConfigModel configModel = Get.find<SplashController>().configModel;
    var dateRangePickerController = DateRangePickerController();

    if (Get.find<ScheduleController>().selectedDate.isNotEmpty) {
      dateRangePickerController.selectedDate = DateFormat('yyyy-MM-dd')
          .parse(Get.find<ScheduleController>().selectedDate);
    }

    return Container(
      width: ResponsiveHelper.isDesktop(Get.context!)
          ? Dimensions.webMaxWidth / 2
          : Dimensions.webMaxWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusLarge),
          topRight: Radius.circular(Dimensions.radiusLarge),
        ),
        color: Theme.of(Get.context!).cardColor,
      ),
      padding: const EdgeInsets.all(10), // Reduced padding
      child: GetBuilder<ScheduleController>(builder: (scheduleController) {
        return SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              /// Date Picker
              CustomDatePicker(
                dateRangePickerController: dateRangePickerController,
              ),

              /// Time Picker
              CustomTimePicker(),

              Align(
                alignment: Alignment.centerRight,
                child: actionButtonWidget(Get.context!, scheduleController),
              ),


              /// ASAP Button if enabled


              if (configModel.content?.instantBooking == 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Theme.of(Get.context!).hintColor,
                      thickness: 0.5,
                      height: 0.5,
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      width: 100,
                      //height: 40,
                      radius: Dimensions.radiusExtraMoreLarge,
                      backgroundColor:
                      scheduleController.initialSelectedScheduleType ==
                          ScheduleType.asap
                          ? Theme.of(Get.context!).colorScheme.primary
                          : Theme.of(Get.context!).disabledColor,
                      buttonText: "ASAP".tr.toUpperCase(),
                      onPressed: () {
                        scheduleController.updateScheduleType(
                            scheduleType: ScheduleType.asap);
                        dateRangePickerController.selectedDate = null;
                      },
                    ),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }

  /// Compact OK/CANCEL button row
  Widget actionButtonWidget(
      BuildContext context, ScheduleController scheduleController) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: const Size(0, 0),
            ),
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr.toUpperCase(),
              style: robotoMedium.copyWith(
                fontSize: 15,
                color: Get.isDarkMode
                    ? Theme.of(context).primaryColorLight
                    : Colors.black.withOpacity(0.8),
              ),
            ),
          ),

          /// This is where we fix the logic
          GetBuilder<ScheduleController>(builder: (controller) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
                ),
              ),
              onPressed: controller.isOkButtonDisabled
                  ? null
                  : () {
                ConfigModel config =
                    Get.find<SplashController>().configModel;

                if (controller.initialSelectedScheduleType == null ||
                    controller.selectedDate.isEmpty) {
                  customSnackBar(
                    'select_your_preferable_booking_time'.tr +
                        ' Please select a time between 9:00 AM and 11:00 PM.',
                    showDefaultSnackBar: false,
                  );
                  controller.update();
                  return;
                }

                if (config.content?.advanceBooking != null &&
                    config.content?.scheduleBookingTimeRestriction == 1 &&
                    controller.initialSelectedScheduleType !=
                        ScheduleType.asap) {
                  if (controller.selectedTime.isEmpty) {
                    customSnackBar('please_select_time'.tr,
                        showDefaultSnackBar: false);
                    controller.update();
                    return;
                  }

                  String? restrictionError =
                  controller.checkValidityOfTimeRestriction(
                    config.content!.advanceBooking!,
                    controller.selectedDate,
                    controller.selectedTime,
                  );

                  if (restrictionError != null) {
                    customSnackBar(restrictionError,
                        showDefaultSnackBar: false);
                    controller.update();
                    return;
                  }
                }

                controller.buildSchedule(
                    scheduleType: ScheduleType.schedule);
                Get.back();
              },
              child: controller.isOkButtonDisabled
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text("..."),
                ],
              )
                  : Text("OK".tr.toUpperCase()),
            );
          }),
        ],
      ),
    );
  }

}