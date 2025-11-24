import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demandium/utils/core_export.dart';

class CustomTimePicker extends StatelessWidget {
  const CustomTimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time'.tr,
            style: robotoBold.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          // Time slots
          GetBuilder<ScheduleController>(builder: (controller) {
            DateTime selectedDate = DateTime.parse(controller.selectedDate);
            DateTime today = DateTime.now();

            // Define time slots (9 AM – 6 PM)
            List<DateTime> activeSlots = [];
            DateTime start = DateTime(
                selectedDate.year, selectedDate.month, selectedDate.day, 9);
            DateTime end = DateTime(
                selectedDate.year, selectedDate.month, selectedDate.day, 18);

            DateTime slot = start;
            while (slot.isBefore(end) || slot.isAtSameMomentAs(end)) {
              activeSlots.add(slot);
              slot = slot.add(const Duration(hours: 1));
            }

            // Current time + 1 hour
            DateTime currentTime = DateTime.now().add(const Duration(hours: 1));

            // 🔹 Validate current selectedTime
            if (controller.selectedTime.isNotEmpty) {
              DateTime selectedTimeDT =
                  _parseSelectedTime(controller.selectedTime, selectedDate);

              bool isValid = false;
              if (_isSameDate(selectedDate, today)) {
                // For today, selectedTime must be after current time
                isValid = selectedTimeDT.isAfter(currentTime);
              } else {
                // For future dates, any time slot is valid
                isValid = activeSlots.any((s) =>
                    s.hour == selectedTimeDT.hour &&
                    s.minute == selectedTimeDT.minute);
              }

              // If invalid → update to first valid slot
              if (!isValid) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_isSameDate(selectedDate, today)) {
                    int index =
                        activeSlots.indexWhere((s) => s.isAfter(currentTime));
                    if (index == -1) index = 0;
                    controller.selectedTime =
                        '${activeSlots[index].hour.toString().padLeft(2, '0')}:${activeSlots[index].minute.toString().padLeft(2, '0')}:00';
                  } else {
                    controller.selectedTime =
                        '${activeSlots[0].hour.toString().padLeft(2, '0')}:${activeSlots[0].minute.toString().padLeft(2, '0')}:00';
                  }
                  controller.update();
                });
              }
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeSlots.length, // ✅ use activeSlots here
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (context, index) {
                final time = activeSlots[index]; // ✅ use activeSlots
                final formattedTime = DateFormat('hh:mm a').format(time);

                final isSelected = controller.selectedTime
                    .startsWith(DateFormat('HH:mm').format(time));

                // Disable past time slots
                final isPast = time.isBefore(currentTime);

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : isPast
                            ? Colors.grey.shade300
                            : Theme.of(context).colorScheme.surface,
                    foregroundColor: isPast
                        ? Colors.grey
                        : isSelected
                            ? Colors.white
                            : Theme.of(context).hintColor,
                    elevation: isPast ? 0 : 2,
                  ),
                  onPressed: isPast
                      ? null
                      : () {
                          controller.selectedTime =
                              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
                          controller.update();

                          controller.disableOkButtonTemporarily();
                          controller.buildSchedule(
                              scheduleType: ScheduleType.schedule);
                        },
                  child: Text(
                    formattedTime,
                    style: robotoMedium.copyWith(
                      fontSize: 14,
                      decoration: TextDecoration.none,
                    ),
                  ),
                );
              },
            );
          }),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // Helper functions
  DateTime _parseSelectedTime(String timeString, DateTime baseDate) {
    try {
      final parts = timeString.split(':');
      return DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (e) {
      return DateTime(0); // fallback if invalid
    }
  }

  bool _isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
