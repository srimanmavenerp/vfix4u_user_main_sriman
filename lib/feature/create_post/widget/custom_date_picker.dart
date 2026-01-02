// import 'package:Vfix4u/utils/core_export.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//
// class CustomDatePicker extends StatelessWidget {
//   final DateRangePickerController dateRangePickerController;
//   const CustomDatePicker({super.key, required this.dateRangePickerController});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 300,
//       width: 500,
//       child: GetBuilder<ScheduleController>(builder: (scheduleController) {
//         return SfDateRangePicker(
//           backgroundColor: Theme.of(context).cardColor,
//           controller: dateRangePickerController,
//           showNavigationArrow: true,
//           // onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
//           //   if(args.value !=null){
//           //     scheduleController.selectedDate =  DateFormat('yyyy-MM-dd').format(args.value);
//           //     scheduleController.updateScheduleType(scheduleType: ScheduleType.schedule);
//           //   }
//           // },
//
//           // venkatesh E -24/4/2025
//           onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
//             if (args.value != null) {
//               final clickedDate = DateFormat('yyyy-MM-dd').format(args.value);
//
//               // If same date is clicked again, toggle between ASAP and Schedule
//               if (scheduleController.selectedDate == clickedDate &&
//                   scheduleController.updateScheduleType(
//                       scheduleType: ScheduleType.schedule)) {
//                 scheduleController.updateScheduleType(
//                     scheduleType: ScheduleType.asap);
//                 scheduleController.selectedDate = '';
//               } else {
//                 scheduleController.selectedDate = clickedDate;
//                 scheduleController.updateScheduleType(
//                     scheduleType: ScheduleType.schedule);
//               }
//             } else {
//               scheduleController.selectedDate = '';
//             }
//           },
//           initialSelectedDate: scheduleController.getSelectedDateTime(),
//           selectionMode: DateRangePickerSelectionMode.single,
//           selectionShape: DateRangePickerSelectionShape.rectangle,
//           viewSpacing: 10,
//           headerHeight: 50,
//           toggleDaySelection: true,
//           enablePastDates: false,
//           headerStyle: DateRangePickerHeaderStyle(
//             backgroundColor: Theme.of(context).cardColor,
//             textAlign: TextAlign.center,
//             textStyle: robotoMedium.copyWith(
//               fontSize: Dimensions.fontSizeLarge,
//               color: Theme.of(context)
//                   .textTheme
//                   .bodyLarge!
//                   .color!
//                   .withValues(alpha: 0.8),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

import 'package:Vfix4u/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// class CustomDatePicker extends StatelessWidget {
//   final DateRangePickerController dateRangePickerController;
//   const CustomDatePicker({super.key, required this.dateRangePickerController});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 300,
//       width: 500,
//       child: GetBuilder<ScheduleController>(builder: (scheduleController) {
//         return SfDateRangePicker(
//           backgroundColor: Theme.of(context).cardColor,
//           controller: dateRangePickerController,
//           showNavigationArrow: true,
//           // onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
//           //   if(args.value !=null){
//           //     scheduleController.selectedDate =  DateFormat('yyyy-MM-dd').format(args.value);
//           //     scheduleController.updateScheduleType(scheduleType: ScheduleType.schedule);
//           //   }
//           // },
//
//           // venkatesh E -24/4/2025
//           onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
//             if (args.value != null) {
//               final clickedDate = DateFormat('yyyy-MM-dd').format(args.value);
//
//               // If same date is clicked again, toggle between ASAP and Schedule
//               if (scheduleController.selectedDate == clickedDate &&
//                   scheduleController.updateScheduleType(
//                       scheduleType: ScheduleType.schedule)) {
//                 scheduleController.updateScheduleType(
//                     scheduleType: ScheduleType.asap);
//                 scheduleController.selectedDate = '';
//               } else {
//                 scheduleController.selectedDate = clickedDate;
//                 scheduleController.updateScheduleType(
//                     scheduleType: ScheduleType.schedule);
//               }
//             } else {
//               scheduleController.selectedDate = '';
//             }
//           },
//           initialSelectedDate: scheduleController.getSelectedDateTime(),
//           selectionMode: DateRangePickerSelectionMode.single,
//           selectionShape: DateRangePickerSelectionShape.rectangle,
//           viewSpacing: 10,
//           headerHeight: 50,
//           toggleDaySelection: true,
//           enablePastDates: false,
//           headerStyle: DateRangePickerHeaderStyle(
//             backgroundColor: Theme.of(context).cardColor,
//             textAlign: TextAlign.center,
//             textStyle: robotoMedium.copyWith(
//               fontSize: Dimensions.fontSizeLarge,
//               color: Theme.of(context)
//                   .textTheme
//                   .bodyLarge!
//                   .color!
//                   .withValues(alpha: 0.8),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

class CustomDatePicker extends StatelessWidget {
  final DateRangePickerController dateRangePickerController;

  const CustomDatePicker({super.key, required this.dateRangePickerController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 500,
      child: GetBuilder<ScheduleController>(
        builder: (scheduleController) {
          return SfDateRangePicker(
            backgroundColor: Theme.of(context).cardColor,
            controller: dateRangePickerController,
            showNavigationArrow: true,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              if (args.value != null) {
                final clickedDate = DateFormat('yyyy-MM-dd').format(args.value);

                if (scheduleController.selectedDate == clickedDate) {
                  // Toggle to ASAP if same date clicked again
                  scheduleController.updateScheduleType(
                      scheduleType: ScheduleType.asap);
                  scheduleController.selectedDate = '';
                } else {
                  scheduleController.selectedDate = clickedDate;
                  scheduleController.updateScheduleType(
                      scheduleType: ScheduleType.schedule);
                }
              } else {
                scheduleController.selectedDate = '';
              }
            },
            initialSelectedDate: scheduleController.getSelectedDateTime(),
            selectionMode: DateRangePickerSelectionMode.single,
            selectionShape: DateRangePickerSelectionShape.rectangle,
            viewSpacing: 10,
            headerHeight: 50,
            toggleDaySelection: true,
            enablePastDates: false,
            headerStyle: DateRangePickerHeaderStyle(
              backgroundColor: Theme.of(context).cardColor,
              textAlign: TextAlign.center,
              textStyle: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withAlpha(204), // ~80% opacity
              ),
            ),
          );
        },
      ),
    );
  }
}
