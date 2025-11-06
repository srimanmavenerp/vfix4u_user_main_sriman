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
            // Assuming controller.selectedDate is like "2025-10-27"
            String dateString = controller.selectedDate;
            print("Selected Date: $dateString");

// Parse the string into a DateTime object
            DateTime selectedDate = DateTime.parse(dateString);

// Define the list of time slots
            final List<DateTime> timeSlots = [];

// Define time range (9 AM – 6 PM)
            final start = DateTime(
                selectedDate.year, selectedDate.month, selectedDate.day, 9, 0);
            final end = DateTime(
                selectedDate.year, selectedDate.month, selectedDate.day, 18, 0);

            print("Start time: $start");
            print("End time: $end");

            DateTime slot = start;
            while (slot.isBefore(end) || slot.isAtSameMomentAs(end)) {
              timeSlots.add(slot);
              slot = slot.add(const Duration(minutes: 60)); // 1-hour intervals
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timeSlots.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (context, index) {
                final time = timeSlots[index];
                final formattedTime = DateFormat('hh:mm a').format(time);

                final isSelected = controller.selectedTime
                    .startsWith(DateFormat('HH:mm').format(time));

                // Current time (for comparison) + 1 hour
                final currentTime =
                    DateTime.now().add(const Duration(hours: 1));

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
                      ? null // disable past buttons
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

          // Info Card
          Card(
            color: Colors.orange.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.access_time, color: Colors.orange, size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Note: Please select a time slot between 9:00 AM and 6:00 PM.\nPast time slots are disabled automatically.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
