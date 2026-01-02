// import 'package:get/get.dart';
// import 'package:Vfix4u/utils/core_export.dart';
// import 'package:intl/intl.dart';
//
// enum ScheduleType { asap, schedule }
//
// class ScheduleController extends GetxController implements GetxService {
//   final ScheduleRepo scheduleRepo;
//   ScheduleController({required this.scheduleRepo});
//
//   ServiceType _selectedServiceType = ServiceType.regular;
//   ServiceType get selectedServiceType => _selectedServiceType;
//   String? timePickerErrorMessage;
//
//   int _scheduleDaysCount = 1;
//   int get scheduleDaysCount => _scheduleDaysCount;
//
//
//
//
//   /// Regular Booking ///
//
//   // ScheduleType _selectedScheduleType = ScheduleType.asap;
//   ScheduleType _selectedScheduleType = ScheduleType.schedule;
//   ScheduleType? _initialSelectedScheduleType = ScheduleType.schedule;
//   ScheduleType get selectedScheduleType => _selectedScheduleType;
//
//   // ScheduleType? _initialSelectedScheduleType;
//   ScheduleType? get initialSelectedScheduleType => _initialSelectedScheduleType;
//
//   String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   String selectedTime = DateFormat('HH:mm:ss')
//       .format(DateTime.now().add(const Duration(minutes: 2)));
//
//   String? scheduleTime;
//
//   /// Repeat Booking /////
//
//   RepeatBookingType _selectedRepeatBookingType = RepeatBookingType.daily;
//   RepeatBookingType get selectedRepeatBookingType => _selectedRepeatBookingType;
//
//   // Daily Repeat Booking
//   DateTimeRange? _pickedDailyRepeatBookingDateRange;
//   DateTimeRange? get pickedDailyRepeatBookingDateRange =>
//       _pickedDailyRepeatBookingDateRange;
//   set updateDailyRepeatBookingDateRange(DateTimeRange? dateRange) =>
//       _pickedDailyRepeatBookingDateRange = dateRange;
//
//   TimeOfDay? _pickedDailyRepeatTime;
//   TimeOfDay? get pickedDailyRepeatTime => _pickedDailyRepeatTime;
//   set updatePickedDailyRepeatTime(TimeOfDay? time) =>
//       _pickedDailyRepeatTime = time;
//
//   // Weekly Repeat Booking
//   DateTimeRange? _finalPickedWeeklyRepeatBookingDateRange;
//   DateTimeRange? get pickedWeeklyRepeatBookingDateRange =>
//       _finalPickedWeeklyRepeatBookingDateRange;
//
//   DateTimeRange? _initialPickedWeeklyRepeatBookingDateRange;
//   DateTimeRange? get initialPickedWeeklyRepeatBookingDateRange =>
//       _initialPickedWeeklyRepeatBookingDateRange;
//   set updateInitialWeeklyRepeatBookingDateRange(DateTimeRange? dateRange) =>
//       _initialPickedWeeklyRepeatBookingDateRange = dateRange;
//
//   TimeOfDay? _pickedWeeklyRepeatTime;
//   TimeOfDay? get pickedWeeklyRepeatTime => _pickedWeeklyRepeatTime;
//   set updatePickedWeeklyRepeatTime(TimeOfDay? time) =>
//       _pickedWeeklyRepeatTime = time;
//
//
//
//   bool _isFinalRepeatWeeklyBooking = false;
//   bool get isFinalRepeatWeeklyBooking => _isFinalRepeatWeeklyBooking;
//
//   bool _isInitialRepeatWeeklyBooking = false;
//   bool get isInitialRepeatWeeklyBooking => _isInitialRepeatWeeklyBooking;
//
//   List<String> daysList = [
//     'saturday',
//     "sunday",
//     "monday",
//     "tuesday",
//     "wednesday",
//     "thursday",
//     "friday"
//   ];
//   List<bool> finalDaysCheckList = [
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false
//   ];
//   List<bool> initialDaysCheckList = [
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false
//   ];
//
//   // Custom Repeat Booking
//   List<DateTime> _pickedCustomRepeatBookingDateTimeList = [];
//   List<DateTime> get pickedCustomRepeatBookingDateTimeList =>
//       _pickedCustomRepeatBookingDateTimeList;
//
//   List<DateTime> _pickedInitialCustomRepeatBookingDateTimeList = [];
//   List<DateTime> get pickedInitialCustomRepeatBookingDateTimeList =>
//       _pickedInitialCustomRepeatBookingDateTimeList;
//   set updateInitialCustomRepeatBookingDateRange(List<DateTime> dateList) =>
//       _pickedInitialCustomRepeatBookingDateTimeList = dateList;
//
//   void buildSchedule(
//       {bool shouldUpdate = true,
//         required ScheduleType scheduleType,
//         String? schedule}) {
//     if (schedule != null) {
//       _selectedScheduleType = ScheduleType.schedule;
//       scheduleTime = schedule;
//     } else if (_initialSelectedScheduleType == ScheduleType.asap) {
//       _selectedScheduleType = ScheduleType.asap;
//       scheduleTime =
//       "${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${DateFormat('HH:mm:ss').format(DateTime.now().add(const Duration(minutes: 2)))}";
//     } else {
//       _selectedScheduleType = ScheduleType.schedule;
//       scheduleTime = "$selectedDate $selectedTime";
//     }
//     if (shouldUpdate) {
//       update();
//     }
//   }
//
//   updateScheduleType(
//       {bool shouldUpdate = true, required ScheduleType scheduleType}) {
//     if (scheduleType == ScheduleType.asap) {
//       _initialSelectedScheduleType = ScheduleType.asap;
//     } else {
//       _initialSelectedScheduleType = ScheduleType.schedule;
//     }
//     if (shouldUpdate) {
//       update();
//     }
//   }
//
//   DateTime? getSelectedDateTime() {
//     return _selectedScheduleType == ScheduleType.schedule &&
//         scheduleTime != null
//         ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(scheduleTime!)
//         : null;
//   }
//
//   // String? checkValidityOfTimeRestriction(AdvanceBooking advanceBooking) {
//   //   Duration difference = DateConverter.dateTimeStringToDate("$selectedDate $selectedTime")
//   //       .difference(DateTime.now());
//   //
//   //   if (advanceBooking.advancedBookingRestrictionType == "day" &&
//   //       difference.inDays < advanceBooking.advancedBookingRestrictionValue!) {
//   //     return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(DateTime.now().add(Duration(days: advanceBooking.advancedBookingRestrictionValue!)))}";
//   //   } else if (advanceBooking.advancedBookingRestrictionType == "hour" &&
//   //       difference.inHours < advanceBooking.advancedBookingRestrictionValue!) {
//   //     return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(DateTime.now().add(Duration(hours: advanceBooking.advancedBookingRestrictionValue!)))}";
//   //   }
//   //
//   //   // If you want to check for a time range like 9:00 AM to 11:00 PM, that should be a separate check
//   //   DateTime selectedDateTime = DateConverter.dateTimeStringToDate("$selectedDate $selectedTime");
//   //   if (selectedDateTime.hour < 9 || selectedDateTime.hour >= 23) {
//   //     return "Please select a time between 9:00 AM and 11:00 PM  jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj";
//   //   }
//   //
//   //   return null;
//   // }
//
//
//
// //   String? checkValidityOfTimeRestriction(AdvanceBooking advanceBooking) {
// //     try {
// // // Combine date and time
// //       DateTime selectedDateTime = DateConverter.dateTimeStringToDate(
// //           "\$selectedDate \$selectedTime");
// //       DateTime now = DateTime.now();
// //
// //     // Define allowed range
// //     DateTime earliestTime = DateTime(
// //     selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, 9);
// //     DateTime latestTime = DateTime(
// //     selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, 23);
// //
// //     // Validate time window
// //     if (selectedDateTime.isBefore(earliestTime) ||
// //     selectedDateTime.isAfter(latestTime)) {
// //     return 'Please select a time between 9:00 AM and 11:00 PM.';
// //     }
// //
// //     print("Selected DateTime (original): $selectedDateTime");
// //     // print("Selected DateTime (24h): ${DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime)}");
// //     print("Earliest Allowed: $earliestTime");
// //     print("Latest Allowed: $latestTime");
// //
// //     // Advanced booking restriction
// //     Duration difference = selectedDateTime.difference(now);
// //
// //     if (advanceBooking.advancedBookingRestrictionType == "day" &&
// //     difference.inDays < advanceBooking.advancedBookingRestrictionValue!) {
// //     DateTime restrictionDate =
// //     now.add(Duration(days: advanceBooking.advancedBookingRestrictionValue!));
// //     return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(restrictionDate)}";
// //     } else if (advanceBooking.advancedBookingRestrictionType == "hour" &&
// //     difference.inHours < advanceBooking.advancedBookingRestrictionValue!) {
// //     DateTime restrictionTime =
// //     now.add(Duration(hours: advanceBooking.advancedBookingRestrictionValue!));
// //     return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(restrictionTime)}";
// //     }
// //
// //     return null; // All valid
// //     } catch (e) {
// //     return 'Invalid time format.';
// //     }
// //   }
//
//   // String _timeFormatter() {
//   //   final timeFormat = Get.find<SplashController>()
//   //       .configModel
//   //       .content
//   //       ?.timeFormat
//   //       ?.toLowerCase();
//   //   return timeFormat == '24' ? 'HH:mm' : 'hh:mm a';
//   // }
//   //
//   //
//   // String? checkValidityOfTimeRestriction(
//   //     AdvanceBooking advanceBooking, {
//   //       String selectedDate = '2025-05-10',
//   //       String selectedTime = '08:11 PM',
//   //     }) {
//   //   try {
//   //     DateTime selectedDateTime;
//   //     String fullDateTime = "$selectedDate $selectedTime".trim();
//   //
//   //     // Parse depending on AM/PM presence
//   //     if (fullDateTime.toLowerCase().contains("am") || fullDateTime.toLowerCase().contains("pm")) {
//   //       selectedDateTime = DateFormat('yyyy-MM-dd h:mm a').parse(fullDateTime);
//   //     } else {
//   //       selectedDateTime = DateFormat('yyyy-MM-dd HH:mm').parse(fullDateTime);
//   //     }
//   //
//   //     // Debug log using app-configured time format
//   //     final formattedDateTime = DateFormat('yyyy-MM-dd ${_timeFormatter()}').format(selectedDateTime);
//   //     print("Selected DateTime: $formattedDateTime");
//   //
//   //     DateTime now = DateTime.now();
//   //
//   //     // Time window: between 9:00 AM and 11:00 PM
//   //     DateTime earliestTime = DateTime(
//   //       selectedDateTime.year,
//   //       selectedDateTime.month,
//   //       selectedDateTime.day,
//   //       9,
//   //     );
//   //     DateTime latestTime = DateTime(
//   //       selectedDateTime.year,
//   //       selectedDateTime.month,
//   //       selectedDateTime.day,
//   //       23,
//   //     );
//   //
//   //     // Validate time window
//   //     if (selectedDateTime.isBefore(earliestTime) || selectedDateTime.isAfter(latestTime)) {
//   //       return 'Please select a time between 9:00 AM and 11:00 PM.';
//   //     }
//   //
//   //     // Validate advanced booking
//   //     if (advanceBooking.advancedBookingRestrictionType == "day") {
//   //       final minDateTime = now.add(Duration(days: advanceBooking.advancedBookingRestrictionValue ?? 0));
//   //       if (selectedDateTime.isBefore(minDateTime)) {
//   //         return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(minDateTime)}";
//   //       }
//   //     } else if (advanceBooking.advancedBookingRestrictionType == "hour") {
//   //       final minDateTime = now.add(Duration(hours: advanceBooking.advancedBookingRestrictionValue ?? 0));
//   //       if (selectedDateTime.isBefore(minDateTime)) {
//   //         return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(minDateTime)}";
//   //       }
//   //     }
//   //
//   //     return null; // All validations passed
//   //   } catch (e) {
//   //     print("Error parsing date/time: $e");
//   //     return 'Invalid time format.';
//   //   }
//   // }
//   //
//
//
//
//
//
//   String? checkValidityOfTimeRestriction(AdvanceBooking advanceBooking, String selectedDate, String selectedTime) {
//     try {
//       if (selectedDate.trim().isEmpty || selectedTime.trim().isEmpty) {
//         return 'Date or time is missing.';
//       }
//
//       String fullDateTime = "$selectedDate $selectedTime".trim();
//
//       if (!RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(selectedDate)) {
//         return 'Invalid date format.';
//       }
//
//       DateTime selectedDateTime;
//
//       // Parse depending on AM/PM presence
//       if (fullDateTime.toLowerCase().contains("am") || fullDateTime.toLowerCase().contains("pm")) {
//         selectedDateTime = DateFormat('yyyy-MM-dd h:mm a').parse(fullDateTime);
//       } else {
//         selectedDateTime = DateFormat('yyyy-MM-dd HH:mm').parse(fullDateTime);
//       }
//
//       print("Parsed DateTime: $selectedDateTime");
//
//       DateTime now = DateTime.now();
//
//       // Time window: between 9:00 AM and 11:00 PM
//       DateTime earliestTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, 9);
//       DateTime latestTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, 23);
//
//       if (selectedDateTime.isBefore(earliestTime) || selectedDateTime.isAfter(latestTime)) {
//         return 'Please select a time between 9:00 AM and 11:00 PM.';
//       }
//
//       // Validate advanced booking
//       if (advanceBooking.advancedBookingRestrictionType == "day") {
//         final minDateTime = now.add(Duration(days: advanceBooking.advancedBookingRestrictionValue!));
//         if (selectedDateTime.isBefore(minDateTime)) {
//           return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(minDateTime)}";
//         }
//       } else if (advanceBooking.advancedBookingRestrictionType == "hour") {
//         final minDateTime = now.add(Duration(hours: advanceBooking.advancedBookingRestrictionValue!));
//         if (selectedDateTime.isBefore(minDateTime)) {
//           return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(minDateTime)}";
//         }
//       }
//
//       return null; // All good
//     } catch (e) {
//       print("Error parsing date/time: $e");
//       return 'Invalid time format.';
//     }
//   }
//
//
//
//   // String? checkValidityOfTimeRestriction(AdvanceBooking advanceBooking) {
//   //
//   //   DateTime currentDateTime = DateTime.now().add(Duration(minutes: 2));
//   //
//   //   // Format current date and time with proper AM/PM
//   //   String selectedDate = DateFormat('yyyy-MM-dd').format(currentDateTime);
//   //   String selectedTime = DateFormat('hh:mm a').format(currentDateTime); // 'a' ensures AM/PM is added
//   //
//   //   print("Current formatted time: $selectedTime"); // Debug print to verify AM/PM
//   //
//   //   // Combine date and time for parsing
//   //   DateTime selectedDateTime = DateFormat("yyyy-MM-dd hh:mm a").parse("$selectedDate $selectedTime");
//   //
//   //   DateTime now = DateTime.now();
//   //   bool isWithinAllowedTime(DateTime dt) {
//   //     int hour = dt.hour;
//   //     return hour >= 9 && hour < 23; // Note: hour == 23 is 11:00 PM which is **exclusive**
//   //   }
//   //
//   //   if (!isWithinAllowedTime(selectedDateTime)) {
//   //     return 'Please select a time between 9:00 AM and 11:00 PM.';
//   //   }
//   //
//   //   DateTime earliestTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, 9);
//   //   DateTime latestTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, 22, 59, 59);
//   //
//   //   print("Selected DateTime: $selectedDateTime");
//   //   print("Earliest Allowed: $earliestTime");
//   //   print("Latest Allowed: $latestTime");
//   //
//   //   Duration difference = selectedDateTime.difference(now);
//   //
//   //   if (advanceBooking.advancedBookingRestrictionType == "day" &&
//   //       difference.inDays < advanceBooking.advancedBookingRestrictionValue!) {
//   //     return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(now.add(Duration(days: advanceBooking.advancedBookingRestrictionValue!)))}";
//   //   } else if (advanceBooking.advancedBookingRestrictionType == "hour" &&
//   //       difference.inHours < advanceBooking.advancedBookingRestrictionValue!) {
//   //     return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(now.add(Duration(hours: advanceBooking.advancedBookingRestrictionValue!)))}";
//   //   }
//   //
//   //   return null;
//   // }
//
//   void resetSchedule() {
//     if (Get.find<SplashController>().configModel.content?.instantBooking == 1) {
//       _selectedScheduleType = ScheduleType.asap;
//       _initialSelectedScheduleType = ScheduleType.asap;
//       scheduleTime =
//       "${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${DateFormat('HH:mm:ss').format(DateTime.now().add(const Duration(minutes: 2)))}";
//     } else {
//       _selectedScheduleType = ScheduleType.schedule;
//       scheduleTime = null;
//     }
//   }
//
//   void setInitialScheduleValue() {
//     if (_selectedScheduleType == ScheduleType.asap) {
//       _initialSelectedScheduleType = ScheduleType.asap;
//     }
//   }
//
//   void updateSelectedDate(String? date) {
//     if (date != null) {
//       scheduleTime = date;
//     } else {
//       scheduleTime = null;
//     }
//   }
//
//   Future<void> updatePostInformation(String postId, String scheduleTime) async {
//     Response response =
//     await scheduleRepo.changePostScheduleTime(postId, scheduleTime);
//
//     if (response.statusCode == 200 &&
//         response.body['response_code'] == "default_update_200") {
//       customSnackBar("service_schedule_updated_successfully".tr,
//           type: ToasterMessageType.success);
//     }
//   }
//
//   void removeInitialPickedCustomRepeatBookingDate({required index}) {
//     _pickedInitialCustomRepeatBookingDateTimeList.removeAt(index);
//   }
//
//   void removePickedCustomRepeatBookingDate({required index}) {
//     _pickedCustomRepeatBookingDateTimeList.removeAt(index);
//   }
//
//   void updateSelectedRepeatBookingType({RepeatBookingType? type}) {
//     if (type != null) {
//       _selectedRepeatBookingType = type;
//       update();
//     } else {
//       _selectedRepeatBookingType = RepeatBookingType.daily;
//     }
//   }
//
//   void toggleDaysCheckedValue(int index) {
//     initialDaysCheckList[index] = !initialDaysCheckList[index];
//     update();
//   }
//
//   void updateWeeklyRepeatBookingStatus({bool shouldUpdate = true}) {
//     _initialPickedWeeklyRepeatBookingDateRange = null;
//     _isInitialRepeatWeeklyBooking = !_isInitialRepeatWeeklyBooking;
//     if (shouldUpdate) {
//       update();
//     }
//   }
//
//   void updateSelectedBookingType({ServiceType? type}) {
//     if (type != null) {
//       _selectedServiceType = type;
//       update();
//     } else {
//       _selectedServiceType = ServiceType.regular;
//     }
//   }
//
//   List<String> getWeeklyPickedDays() {
//     List<String> pickedDays = [];
//     for (int index = 0; index < finalDaysCheckList.length; index++) {
//       if (finalDaysCheckList[index]) {
//         pickedDays.add(daysList[index]);
//       }
//     }
//     return pickedDays;
//   }
//
//   List<String> getInitialWeeklyPickedDays() {
//     List<String> pickedDays = [];
//     for (int index = 0; index < initialDaysCheckList.length; index++) {
//       if (initialDaysCheckList[index]) {
//         pickedDays.add(daysList[index]);
//       }
//     }
//     return pickedDays;
//   }
//
//   void updateCustomRepeatBookingDateTime(
//       {required int index, required DateTime dateTime}) {
//     pickedInitialCustomRepeatBookingDateTimeList[index] = dateTime;
//     update();
//   }
//
//   void resetScheduleData(
//       {RepeatBookingType? repeatBookingType, bool shouldUpdate = true}) {
//     if (repeatBookingType == RepeatBookingType.daily) {
//       _finalPickedWeeklyRepeatBookingDateRange = null;
//       _pickedCustomRepeatBookingDateTimeList = [];
//       _pickedDailyRepeatTime = null;
//       _pickedWeeklyRepeatTime = null;
//       finalDaysCheckList = [false, false, false, false, false, false, false];
//       _isFinalRepeatWeeklyBooking = false;
//     } else if (repeatBookingType == RepeatBookingType.weekly) {
//       _pickedDailyRepeatBookingDateRange = null;
//       _pickedCustomRepeatBookingDateTimeList = [];
//       _pickedDailyRepeatTime = null;
//     } else if (repeatBookingType == RepeatBookingType.custom) {
//       _pickedDailyRepeatBookingDateRange = null;
//       _finalPickedWeeklyRepeatBookingDateRange = null;
//       _pickedDailyRepeatTime = null;
//       _pickedWeeklyRepeatTime = null;
//       finalDaysCheckList = [false, false, false, false, false, false, false];
//       _isFinalRepeatWeeklyBooking = false;
//     } else {
//       _pickedDailyRepeatBookingDateRange = null;
//       _finalPickedWeeklyRepeatBookingDateRange = null;
//       _pickedCustomRepeatBookingDateTimeList = [];
//       _pickedDailyRepeatTime = null;
//       _selectedRepeatBookingType = RepeatBookingType.daily;
//       _isFinalRepeatWeeklyBooking = false;
//       finalDaysCheckList = [false, false, false, false, false, false, false];
//     }
//
//     calculateScheduleCountDays(
//         serviceType: repeatBookingType == null
//             ? ServiceType.regular
//             : ServiceType.repeat,
//         repeatBookingType: repeatBookingType ?? RepeatBookingType.daily);
//
//     if (shouldUpdate) {
//       update();
//     }
//   }
//
//   void initWeeklySelectedSchedule({bool isFirst = true}) {
//     if (isFirst) {
//       _isInitialRepeatWeeklyBooking = _isFinalRepeatWeeklyBooking;
//       initialDaysCheckList.clear();
//       initialDaysCheckList.addAll(finalDaysCheckList);
//       _initialPickedWeeklyRepeatBookingDateRange =
//           _finalPickedWeeklyRepeatBookingDateRange;
//     } else {
//       _isFinalRepeatWeeklyBooking = _isInitialRepeatWeeklyBooking;
//       finalDaysCheckList.clear();
//       finalDaysCheckList.addAll(initialDaysCheckList);
//       _finalPickedWeeklyRepeatBookingDateRange =
//           _initialPickedWeeklyRepeatBookingDateRange;
//       update();
//     }
//   }
//
//   void initCustomSelectedSchedule({bool isFirst = true}) {
//     if (isFirst) {
//       _pickedInitialCustomRepeatBookingDateTimeList.clear();
//       _pickedInitialCustomRepeatBookingDateTimeList
//           .addAll(_pickedCustomRepeatBookingDateTimeList);
//     } else {
//       _pickedCustomRepeatBookingDateTimeList.clear();
//       _pickedCustomRepeatBookingDateTimeList
//           .addAll(_pickedInitialCustomRepeatBookingDateTimeList);
//       update();
//     }
//   }
//
//   void calculateScheduleCountDays(
//       {ServiceType? serviceType,
//         required RepeatBookingType repeatBookingType}) {
//     if (selectedServiceType == ServiceType.regular ||
//         serviceType == ServiceType.regular) {
//       _scheduleDaysCount = 1;
//     } else {
//       if (repeatBookingType == RepeatBookingType.daily) {
//         _scheduleDaysCount = CheckoutHelper.calculateDaysCountBetweenDateRange(
//             _pickedDailyRepeatBookingDateRange);
//       } else if (repeatBookingType == RepeatBookingType.weekly) {
//         _scheduleDaysCount = CheckoutHelper
//             .calculateDaysCountBetweenDateRangeWithSpecificSelectedDay(
//             _finalPickedWeeklyRepeatBookingDateRange,
//             getWeeklyPickedDays());
//       } else {
//         _scheduleDaysCount = _pickedCustomRepeatBookingDateTimeList.length;
//       }
//     }
//   }
// }
//
//////above code  rani
/////below saif
/// ////new code

import 'package:get/get.dart';
import 'package:Vfix4u/utils/core_export.dart';
import 'package:intl/intl.dart';

enum ScheduleType { asap, schedule }

class ScheduleController extends GetxController implements GetxService {
  final ScheduleRepo scheduleRepo;
  ScheduleController({required this.scheduleRepo});
  bool isOkButtonDisabled = false;
  ServiceType _selectedServiceType = ServiceType.regular;
  ServiceType get selectedServiceType => _selectedServiceType;
  String? timePickerErrorMessage;

  int _scheduleDaysCount = 1;
  int get scheduleDaysCount => _scheduleDaysCount;

  /// Regular Booking ///

  // ScheduleType _selectedScheduleType = ScheduleType.asap;
  ScheduleType _selectedScheduleType = ScheduleType.schedule;
  ScheduleType? _initialSelectedScheduleType = ScheduleType.schedule;
  ScheduleType get selectedScheduleType => _selectedScheduleType;

  // ScheduleType? _initialSelectedScheduleType;
  ScheduleType? get initialSelectedScheduleType => _initialSelectedScheduleType;

  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String selectedTime = DateFormat('HH:mm:ss')
      .format(DateTime.now().add(const Duration(minutes: 2)));

  String? scheduleTime;

  /// Repeat Booking /////

  RepeatBookingType _selectedRepeatBookingType = RepeatBookingType.daily;
  RepeatBookingType get selectedRepeatBookingType => _selectedRepeatBookingType;

  // Daily Repeat Booking
  DateTimeRange? _pickedDailyRepeatBookingDateRange;
  DateTimeRange? get pickedDailyRepeatBookingDateRange =>
      _pickedDailyRepeatBookingDateRange;
  set updateDailyRepeatBookingDateRange(DateTimeRange? dateRange) =>
      _pickedDailyRepeatBookingDateRange = dateRange;

  TimeOfDay? _pickedDailyRepeatTime;
  TimeOfDay? get pickedDailyRepeatTime => _pickedDailyRepeatTime;
  set updatePickedDailyRepeatTime(TimeOfDay? time) =>
      _pickedDailyRepeatTime = time;

  // Weekly Repeat Booking
  DateTimeRange? _finalPickedWeeklyRepeatBookingDateRange;
  DateTimeRange? get pickedWeeklyRepeatBookingDateRange =>
      _finalPickedWeeklyRepeatBookingDateRange;

  DateTimeRange? _initialPickedWeeklyRepeatBookingDateRange;
  DateTimeRange? get initialPickedWeeklyRepeatBookingDateRange =>
      _initialPickedWeeklyRepeatBookingDateRange;
  set updateInitialWeeklyRepeatBookingDateRange(DateTimeRange? dateRange) =>
      _initialPickedWeeklyRepeatBookingDateRange = dateRange;

  TimeOfDay? _pickedWeeklyRepeatTime;
  TimeOfDay? get pickedWeeklyRepeatTime => _pickedWeeklyRepeatTime;
  set updatePickedWeeklyRepeatTime(TimeOfDay? time) =>
      _pickedWeeklyRepeatTime = time;

  bool _isFinalRepeatWeeklyBooking = false;
  bool get isFinalRepeatWeeklyBooking => _isFinalRepeatWeeklyBooking;

  bool _isInitialRepeatWeeklyBooking = false;
  bool get isInitialRepeatWeeklyBooking => _isInitialRepeatWeeklyBooking;

  List<String> daysList = [
    'saturday',
    "sunday",
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday"
  ];
  List<bool> finalDaysCheckList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<bool> initialDaysCheckList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  // Custom Repeat Booking
  List<DateTime> _pickedCustomRepeatBookingDateTimeList = [];
  List<DateTime> get pickedCustomRepeatBookingDateTimeList =>
      _pickedCustomRepeatBookingDateTimeList;

  List<DateTime> _pickedInitialCustomRepeatBookingDateTimeList = [];
  List<DateTime> get pickedInitialCustomRepeatBookingDateTimeList =>
      _pickedInitialCustomRepeatBookingDateTimeList;
  set updateInitialCustomRepeatBookingDateRange(List<DateTime> dateList) =>
      _pickedInitialCustomRepeatBookingDateTimeList = dateList;

  void disableOkButtonTemporarily() {
    isOkButtonDisabled = true;
    update();

    Future.delayed(const Duration(milliseconds: 150), () {
      isOkButtonDisabled = false;
      update();
    });
  }

  void buildSchedule(
      {bool shouldUpdate = true,
      required ScheduleType scheduleType,
      String? schedule}) {
    if (schedule != null) {
      _selectedScheduleType = ScheduleType.schedule;
      scheduleTime = schedule;
    } else if (_initialSelectedScheduleType == ScheduleType.asap) {
      _selectedScheduleType = ScheduleType.asap;
      scheduleTime =
          "${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${DateFormat('HH:mm:ss').format(DateTime.now().add(const Duration(minutes: 2)))}";
    } else {
      _selectedScheduleType = ScheduleType.schedule;
      scheduleTime = "$selectedDate $selectedTime";
    }
    if (shouldUpdate) {
      update();
    }
  }

  updateScheduleType(
      {bool shouldUpdate = true, required ScheduleType scheduleType}) {
    if (scheduleType == ScheduleType.asap) {
      _initialSelectedScheduleType = ScheduleType.asap;
    } else {
      _initialSelectedScheduleType = ScheduleType.schedule;
    }
    if (shouldUpdate) {
      update();
    }
  }

// Add this to your controller
  void clearTimeValidation() {
    timePickerErrorMessage = null;
    update(); // Trigger UI update
  }

  DateTime? getSelectedDateTime() {
    return _selectedScheduleType == ScheduleType.schedule &&
            scheduleTime != null
        ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(scheduleTime!)
        : null;
  }

  String? checkValidityOfTimeRestriction(
      AdvanceBooking advanceBooking, String selectedDate, String selectedTime) {
    try {
      if (selectedDate.trim().isEmpty || selectedTime.trim().isEmpty) {
        return 'Date or time is missing.';
      }

      String fullDateTime = "$selectedDate $selectedTime".trim();

      if (!RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(selectedDate)) {
        return 'Invalid date format.';
      }

      DateTime selectedDateTime;

      // Parse depending on AM/PM presence
      if (fullDateTime.toLowerCase().contains("am") ||
          fullDateTime.toLowerCase().contains("pm")) {
        selectedDateTime = DateFormat('yyyy-MM-dd h:mm a').parse(fullDateTime);
      } else {
        selectedDateTime = DateFormat('yyyy-MM-dd HH:mm').parse(fullDateTime);
      }

      print("Parsed DateTime: $selectedDateTime");

      DateTime now = DateTime.now();
      DateTime minBookingTime = now.add(const Duration(hours: 1));
      // Time window: between 9:00 AM and 11:00 PM
      DateTime earliestTime = DateTime(selectedDateTime.year,
          selectedDateTime.month, selectedDateTime.day, 9);
      DateTime latestTime = DateTime(selectedDateTime.year,
          selectedDateTime.month, selectedDateTime.day, 23);

      if (selectedDateTime.isBefore(earliestTime) ||
          selectedDateTime.isAfter(latestTime)) {
        return 'Please select a time between 9:00 AM and 11:00 PM.';
      }
      if (selectedDateTime.isBefore(minBookingTime)) {
        return 'You must schedule at least 1 hour ahead.';
      }

      // Validate advanced booking
      if (advanceBooking.advancedBookingRestrictionType == "day") {
        final minDateTime = now.add(
            Duration(days: advanceBooking.advancedBookingRestrictionValue!));
        if (selectedDateTime.isBefore(minDateTime)) {
          return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(minDateTime)}";
        }
      } else if (advanceBooking.advancedBookingRestrictionType == "hour") {
        final minDateTime = now.add(
            Duration(hours: advanceBooking.advancedBookingRestrictionValue!));
        if (selectedDateTime.isBefore(minDateTime)) {
          return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(minDateTime)}";
        }
      }
      return null; // All good
    } catch (e) {
      print("Error parsing date/time: $e");
      return 'Invalid time format.';
    }
  }

  bool isValidTime = false; // default to false

  void validateTime(AdvanceBooking advanceBooking) {
    final error = checkValidityOfTimeRestriction(
      advanceBooking,
      selectedDate,
      selectedTime,
    );
    isValidTime = error == null;
    update(); // triggers GetBuilder to rebuild
  }

  void updateSelectedTimeWithValidation(String time, {String? date}) {
    clearTimeValidation();

    try {
      // Use current date if not provided
      final selectedDate =
          date ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
      final selectedTime = time;

      // First validate basic format
      if (selectedDate.trim().isEmpty || selectedTime.trim().isEmpty) {
        timePickerErrorMessage = 'Date or time is missing.';
        this.selectedTime = '';
        update();
        return;
      }

      if (!RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(selectedDate)) {
        timePickerErrorMessage = 'Invalid date format.';
        this.selectedTime = '';
        update();
        return;
      }

      // Parse the combined datetime
      DateTime selectedDateTime;
      String fullDateTime = "$selectedDate $selectedTime".trim();

      if (fullDateTime.toLowerCase().contains("am") ||
          fullDateTime.toLowerCase().contains("pm")) {
        selectedDateTime = DateFormat('yyyy-MM-dd h:mm a').parse(fullDateTime);
      } else {
        selectedDateTime = DateFormat('yyyy-MM-dd HH:mm').parse(fullDateTime);
      }

      // Business hours validation (9AM-11PM)
      DateTime earliestTime = DateTime(selectedDateTime.year,
          selectedDateTime.month, selectedDateTime.day, 9);
      DateTime latestTime = DateTime(selectedDateTime.year,
          selectedDateTime.month, selectedDateTime.day, 23);

      if (selectedDateTime.isBefore(earliestTime) ||
          selectedDateTime.isAfter(latestTime)) {
        timePickerErrorMessage =
            'Please select a time between 9:00 AM and 11:00 PM.';
        this.selectedTime = '';
        update();
        return;
      }

      // Minimum 1 hour ahead requirement
      DateTime now = DateTime.now();
      DateTime minBookingTime = now.add(const Duration(hours: 1));
      if (selectedDateTime.isBefore(minBookingTime)) {
        timePickerErrorMessage = 'You must schedule at least 1 hour ahead.';
        this.selectedTime = '';
        update();
        return;
      }

      // If all validations pass
      this.selectedTime = time;
      timePickerErrorMessage = null;
    } catch (e) {
      timePickerErrorMessage = 'Invalid time format';
      this.selectedTime = '';
    }

    update();
  }

  // String? checkValidityOfTimeRestriction(AdvanceBooking advanceBooking) {
  //
  //   DateTime currentDateTime = DateTime.now().add(Duration(minutes: 2));
  //
  //   // Format current date and time with proper AM/PM
  //   String selectedDate = DateFormat('yyyy-MM-dd').format(currentDateTime);
  //   String selectedTime = DateFormat('hh:mm a').format(currentDateTime); // 'a' ensures AM/PM is added
  //
  //   print("Current formatted time: $selectedTime"); // Debug print to verify AM/PM
  //
  //   // Combine date and time for parsing
  //   DateTime selectedDateTime = DateFormat("yyyy-MM-dd hh:mm a").parse("$selectedDate $selectedTime");
  //
  //   DateTime now = DateTime.now();
  //   bool isWithinAllowedTime(DateTime dt) {
  //     int hour = dt.hour;
  //     return hour >= 9 && hour < 23; // Note: hour == 23 is 11:00 PM which is **exclusive**
  //   }
  //
  //   if (!isWithinAllowedTime(selectedDateTime)) {
  //     return 'Please select a time between 9:00 AM and 11:00 PM.';
  //   }
  //
  //   DateTime earliestTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, 9);
  //   DateTime latestTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, 22, 59, 59);
  //
  //   print("Selected DateTime: $selectedDateTime");
  //   print("Earliest Allowed: $earliestTime");
  //   print("Latest Allowed: $latestTime");
  //
  //   Duration difference = selectedDateTime.difference(now);
  //
  //   if (advanceBooking.advancedBookingRestrictionType == "day" &&
  //       difference.inDays < advanceBooking.advancedBookingRestrictionValue!) {
  //     return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(now.add(Duration(days: advanceBooking.advancedBookingRestrictionValue!)))}";
  //   } else if (advanceBooking.advancedBookingRestrictionType == "hour" &&
  //       difference.inHours < advanceBooking.advancedBookingRestrictionValue!) {
  //     return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(now.add(Duration(hours: advanceBooking.advancedBookingRestrictionValue!)))}";
  //   }
  //
  //   return null;
  // }

  void resetSchedule() {
    if (Get.find<SplashController>().configModel.content?.instantBooking == 1) {
      _selectedScheduleType = ScheduleType.asap;
      _initialSelectedScheduleType = ScheduleType.asap;
      scheduleTime =
          "${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${DateFormat('HH:mm:ss').format(DateTime.now().add(const Duration(minutes: 2)))}";
    } else {
      _selectedScheduleType = ScheduleType.schedule;
      scheduleTime = null;
    }
  }

  void setInitialScheduleValue() {
    if (_selectedScheduleType == ScheduleType.asap) {
      _initialSelectedScheduleType = ScheduleType.asap;
    }
  }

  void updateSelectedDate(String? date) {
    clearTimeValidation();
    // Force re-selection of time
    update();
    if (date != null) {
      scheduleTime = date;
    } else {
      scheduleTime = null;
    }
  }

  Future<void> updatePostInformation(String postId, String scheduleTime) async {
    Response response =
        await scheduleRepo.changePostScheduleTime(postId, scheduleTime);

    if (response.statusCode == 200 &&
        response.body['response_code'] == "default_update_200") {
      customSnackBar("service_schedule_updated_successfully".tr,
          type: ToasterMessageType.success);
    }
  }

  void removeInitialPickedCustomRepeatBookingDate({required index}) {
    _pickedInitialCustomRepeatBookingDateTimeList.removeAt(index);
  }

  void removePickedCustomRepeatBookingDate({required index}) {
    _pickedCustomRepeatBookingDateTimeList.removeAt(index);
  }

  void updateSelectedRepeatBookingType({RepeatBookingType? type}) {
    if (type != null) {
      _selectedRepeatBookingType = type;
      update();
    } else {
      _selectedRepeatBookingType = RepeatBookingType.daily;
    }
  }

  void toggleDaysCheckedValue(int index) {
    initialDaysCheckList[index] = !initialDaysCheckList[index];
    update();
  }

  void updateWeeklyRepeatBookingStatus({bool shouldUpdate = true}) {
    _initialPickedWeeklyRepeatBookingDateRange = null;
    _isInitialRepeatWeeklyBooking = !_isInitialRepeatWeeklyBooking;
    if (shouldUpdate) {
      update();
    }
  }

  void updateSelectedBookingType({ServiceType? type}) {
    if (type != null) {
      _selectedServiceType = type;
      update();
    } else {
      _selectedServiceType = ServiceType.regular;
    }
  }

  List<String> getWeeklyPickedDays() {
    List<String> pickedDays = [];
    for (int index = 0; index < finalDaysCheckList.length; index++) {
      if (finalDaysCheckList[index]) {
        pickedDays.add(daysList[index]);
      }
    }
    return pickedDays;
  }

  List<String> getInitialWeeklyPickedDays() {
    List<String> pickedDays = [];
    for (int index = 0; index < initialDaysCheckList.length; index++) {
      if (initialDaysCheckList[index]) {
        pickedDays.add(daysList[index]);
      }
    }
    return pickedDays;
  }

  void updateCustomRepeatBookingDateTime(
      {required int index, required DateTime dateTime}) {
    pickedInitialCustomRepeatBookingDateTimeList[index] = dateTime;
    update();
  }

  void resetScheduleData(
      {RepeatBookingType? repeatBookingType, bool shouldUpdate = true}) {
    if (repeatBookingType == RepeatBookingType.daily) {
      _finalPickedWeeklyRepeatBookingDateRange = null;
      _pickedCustomRepeatBookingDateTimeList = [];
      _pickedDailyRepeatTime = null;
      _pickedWeeklyRepeatTime = null;
      finalDaysCheckList = [false, false, false, false, false, false, false];
      _isFinalRepeatWeeklyBooking = false;
    } else if (repeatBookingType == RepeatBookingType.weekly) {
      _pickedDailyRepeatBookingDateRange = null;
      _pickedCustomRepeatBookingDateTimeList = [];
      _pickedDailyRepeatTime = null;
    } else if (repeatBookingType == RepeatBookingType.custom) {
      _pickedDailyRepeatBookingDateRange = null;
      _finalPickedWeeklyRepeatBookingDateRange = null;
      _pickedDailyRepeatTime = null;
      _pickedWeeklyRepeatTime = null;
      finalDaysCheckList = [false, false, false, false, false, false, false];
      _isFinalRepeatWeeklyBooking = false;
    } else {
      _pickedDailyRepeatBookingDateRange = null;
      _finalPickedWeeklyRepeatBookingDateRange = null;
      _pickedCustomRepeatBookingDateTimeList = [];
      _pickedDailyRepeatTime = null;
      _selectedRepeatBookingType = RepeatBookingType.daily;
      _isFinalRepeatWeeklyBooking = false;
      finalDaysCheckList = [false, false, false, false, false, false, false];
    }

    calculateScheduleCountDays(
        serviceType: repeatBookingType == null
            ? ServiceType.regular
            : ServiceType.repeat,
        repeatBookingType: repeatBookingType ?? RepeatBookingType.daily);

    if (shouldUpdate) {
      update();
    }
  }

  void initWeeklySelectedSchedule({bool isFirst = true}) {
    if (isFirst) {
      _isInitialRepeatWeeklyBooking = _isFinalRepeatWeeklyBooking;
      initialDaysCheckList.clear();
      initialDaysCheckList.addAll(finalDaysCheckList);
      _initialPickedWeeklyRepeatBookingDateRange =
          _finalPickedWeeklyRepeatBookingDateRange;
    } else {
      _isFinalRepeatWeeklyBooking = _isInitialRepeatWeeklyBooking;
      finalDaysCheckList.clear();
      finalDaysCheckList.addAll(initialDaysCheckList);
      _finalPickedWeeklyRepeatBookingDateRange =
          _initialPickedWeeklyRepeatBookingDateRange;
      update();
    }
  }

  void initCustomSelectedSchedule({bool isFirst = true}) {
    if (isFirst) {
      _pickedInitialCustomRepeatBookingDateTimeList.clear();
      _pickedInitialCustomRepeatBookingDateTimeList
          .addAll(_pickedCustomRepeatBookingDateTimeList);
    } else {
      _pickedCustomRepeatBookingDateTimeList.clear();
      _pickedCustomRepeatBookingDateTimeList
          .addAll(_pickedInitialCustomRepeatBookingDateTimeList);
      update();
    }
  }

  void calculateScheduleCountDays(
      {ServiceType? serviceType,
      required RepeatBookingType repeatBookingType}) {
    if (selectedServiceType == ServiceType.regular ||
        serviceType == ServiceType.regular) {
      _scheduleDaysCount = 1;
    } else {
      if (repeatBookingType == RepeatBookingType.daily) {
        _scheduleDaysCount = CheckoutHelper.calculateDaysCountBetweenDateRange(
            _pickedDailyRepeatBookingDateRange);
      } else if (repeatBookingType == RepeatBookingType.weekly) {
        _scheduleDaysCount = CheckoutHelper
            .calculateDaysCountBetweenDateRangeWithSpecificSelectedDay(
                _finalPickedWeeklyRepeatBookingDateRange,
                getWeeklyPickedDays());
      } else {
        _scheduleDaysCount = _pickedCustomRepeatBookingDateTimeList.length;
      }
    }
  }
}
