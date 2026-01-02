// import 'package:Vfix4u/common/widgets/time_picker_snipper.dart';
// import 'package:Vfix4u/utils/core_export.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// class CustomTimePicker extends StatelessWidget {
//   final TimeOfDay? time;
//
//   final Function(TimeOfDay) onTimeChanged;
//   final bool isExpandedRow;
//   final String? title;
//
//   const CustomTimePicker({super.key,
//
//     required this.time,
//     required this.onTimeChanged,
//     required this.isExpandedRow,
//     this.title,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
//       child: Row(
//         children: [
//           Text('time'.tr,
//               style: robotoBold.copyWith(
//                   fontSize: Dimensions.fontSizeLarge,
//                   color: Theme.of(Get.context!).colorScheme.primary)),
//           const SizedBox(
//             width: Dimensions.paddingSizeLarge,
//           ),
//           GetBuilder<ScheduleController>(builder: (createPostController) {
//             // venkatesh E -24/4/2025
//             DateTime initialTime = DateTime.now();
//             try {
//               if (createPostController.selectedTime.isNotEmpty) {
//                 final timeFormat = DateFormat('HH:mm:ss');
//                 final parsedTime =
//                 timeFormat.parse(createPostController.selectedTime);
//                 initialTime = DateTime(
//                   DateTime.now().year,
//                   DateTime.now().month,
//                   DateTime.now().day,
//                   parsedTime.hour,
//                   parsedTime.minute,
//                   parsedTime.second,
//                 );
//               }
//             } catch (e) {
//               // Fallback to current time + 2 minutes if parsing fails
//               initialTime = DateTime.now().add(const Duration(minutes: 2));
//             }
//             return TimePickerSpinner(
//               time: initialTime,
//               is24HourMode: Get.find<SplashController>()
//                   .configModel
//                   .content
//                   ?.timeFormat ==
//                   '24',
//               normalTextStyle: robotoRegular.copyWith(
//                   color: Theme.of(context).hintColor,
//                   fontSize: Dimensions.fontSizeSmall),
//               highlightedTextStyle: robotoMedium.copyWith(
//                 fontSize: Dimensions.fontSizeLarge * 1,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               spacing: Dimensions.paddingSizeDefault,
//               itemHeight: Dimensions.fontSizeLarge + 2,
//               itemWidth: 50,
//               alignment: Alignment.topCenter,
//               isForce2Digits: true,
//               // onTimeChange: (time) {
//               //   createPostController.selectedTime =
//               //       "${time.hour}:${time.minute}:${time.second}";
//               //   //createPostController.buildSchedule(scheduleType: ScheduleType.schedule);
//               // },rani; time chages 9 am to 11pm
//               onTimeChange: (time) {
//                 final minAllowed = const TimeOfDay(hour: 9, minute: 0);
//                 final maxAllowed = const TimeOfDay(hour: 23, minute: 0);
//                 final selected = TimeOfDay(hour: time.hour, minute: time.minute);
//
//                 bool isAfterMin = selected.hour > minAllowed.hour || (selected.hour == minAllowed.hour && selected.minute >= minAllowed.minute);
//                 bool isBeforeMax = selected.hour < maxAllowed.hour || (selected.hour == maxAllowed.hour && selected.minute <= maxAllowed.minute);
//
//                 if (isAfterMin && isBeforeMax) {
//                   createPostController.selectedTime =
//                   "${time.hour}:${time.minute}:${time.second}";
//                 } else {
//                   customSnackBar("Please select a time between 9:00 AM and 11:00 PM", type: ToasterMessageType.error);
//                 }
//               },
//
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

import 'package:Vfix4u/utils/core_export.dart';
import 'package:get/get.dart';

// class CustomTimePicker extends StatelessWidget {
//   final  TimeOfDay? time;
//   final Function(TimeOfDay) onTimeChanged;
//   final bool isExpandedRow;
//   const CustomTimePicker({super.key, this.time, required this.onTimeChanged, this.isExpandedRow = true});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//
//       InkWell(
//         onTap: () async {
//           TimeOfDay? time = await showTimePicker(
//             context: context, initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
//             builder: (BuildContext context, Widget? child) {
//               return MediaQuery(
//                 data: MediaQuery.of(context).copyWith(
//                   alwaysUse24HourFormat: Get.find<SplashController>().configModel.content?.timeFormat == "24",
//                 ),
//                 child: child!,
//               );
//             },
//           );
//           if(time != null) {
//             onTimeChanged(time);
//           }
//         },
//         child: Container(
//           height: isExpandedRow ? 50 : 35, alignment: Alignment.center,
//           padding: EdgeInsets.symmetric(horizontal: isExpandedRow ?  Dimensions.paddingSizeDefault : Dimensions.paddingSizeSmall),
//           decoration: BoxDecoration(
//             color: Theme.of(context).cardColor,
//             borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
//             border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5), width: 0.5),
//           ),
//           child: Row(children: [
//
//             Text(
//               time != null ? DateConverter.convertDateTimeToTime(DateTime(DateTime.now().year, 1, 1, time!.hour, time!.minute)) : 'time_hint'.tr,
//               style: robotoRegular.copyWith(color: time != null ? null : Theme.of(context).hintColor),
//               maxLines: 1,
//             ),
//             isExpandedRow ? const Expanded(child: SizedBox()) : const SizedBox(width: Dimensions.paddingSizeSmall,),
//
//             Icon(Icons.access_time, size: 20,   color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5)),
//
//           ]),
//         ),
//       ),
//
//     ]);
//   }
// }

class CustomTimePicker extends StatelessWidget {
  final TimeOfDay? time;
  final Function(TimeOfDay) onTimeChanged;
  final bool isExpandedRow;

  const CustomTimePicker({
    super.key,
    this.time,
    required this.onTimeChanged,
    this.isExpandedRow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              // initialTime: time ?? TimeOfDay.now(),

              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    alwaysUse24HourFormat: Get.find<SplashController>()
                            .configModel
                            .content
                            ?.timeFormat ==
                        "24",
                  ),
                  child: child!,
                );
              },
            );

            if (pickedTime != null) {
              final int selectedMinutes =
                  pickedTime.hour * 60 + pickedTime.minute;
              final int minMinutes = 9 * 60; // 9:00 AM
              final int maxMinutes = 22 * 60; // 11:00 PM

              if (selectedMinutes < minMinutes ||
                  selectedMinutes > maxMinutes) {
                customSnackBar(
                    "Please select a time between 9:00 AM and 11:00 PM",
                    type: ToasterMessageType.error);
              } else {
                // Trigger snackbar if exactly 12:00 PM
                if (pickedTime.hour == 12 && pickedTime.minute == 0) {
                  customSnackBar("12:00 PM selected",
                      duration: 4, type: ToasterMessageType.info);
                }

                onTimeChanged(pickedTime);
              }
            }
          },
          child: Container(
            height: isExpandedRow ? 50 : 35,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: isExpandedRow
                  ? Dimensions.paddingSizeDefault
                  : Dimensions.paddingSizeSmall,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
              border: Border.all(
                color: Theme.of(context).hintColor.withAlpha(128),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Text(
                  time != null
                      ? DateConverter.convertDateTimeToTime(
                          DateTime(DateTime.now().year, 1, 1, time!.hour,
                              time!.minute),
                        )
                      : 'time_hint'.tr,
                  style: robotoRegular.copyWith(
                      color: time != null ? null : Theme.of(context).hintColor),
                  maxLines: 1,
                ),
                isExpandedRow
                    ? const Expanded(child: SizedBox())
                    : const SizedBox(width: Dimensions.paddingSizeSmall),
                Icon(Icons.access_time,
                    size: 20,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color
                        ?.withAlpha(128)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
