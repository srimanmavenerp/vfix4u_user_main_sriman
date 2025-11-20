import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ColorResources {
  // Bubble colors
  static Color getRightBubbleColor() {
    return Theme.of(Get.context!).primaryColor; // orange
  }

  static Color getLeftBubbleColor() {
    return Get.isDarkMode
        ? const Color(0xA2B7B7BB)
        : Theme.of(Get.context!).primaryColor.withOpacity(0.08);
  }

  // Button background colors mapped to theme
  static const Map<String, Color> buttonBackgroundColorMap = {
    'pending': Color(0x45F0692C), // light orange
    'accepted': Color(0x49F0692C),
    'ongoing': Color(0x62F0692C),
    'completed': Color(0x5FF0692C),
    'settled': Color(0x6EF0692C),
    'canceled': Color(0x51F0692C),
    'approved': Color(0x80356e4c),
    'expired': Color(0x8CF0692C),
    'running': Color(0x79F0692C),
    'denied': Color(0x66F0692C),
    'paused': Color(0xFF0461A5),
    'resumed': Color(0x6FF0692C),
    'resume': Color(0x8EF0692C),
    'subscription_purchase': Color(0x3CF0692C),
    'subscription_renew': Color(0x1DF0692C),
    'subscription_shift': Color(0x45F0692C),
    'subscription_refund': Color(0x1DF0692C),
  };

  // Button text colors mapped to theme
  static const Map<String, Color> buttonTextColorMap = {
    'pending': Color(0xFFF8FAFC), // white on orange
    'accepted': Color(0xFFF8FAFC),
    'ongoing': Color(0xFFF8FAFC),
    'completed': Color(0xFFF8FAFC),
    'settled': Color(0xFFF8FAFC),
    'canceled': Color(0xFFF8FAFC),
    'approved': Color(0xFFF8FAFC),
    'expired': Color(0xFFF8FAFC),
    'running': Color(0xFFF8FAFC),
    'denied': Color(0xFFF8FAFC),
    'paused': Color(0xFF0461A5),
    'resumed': Color(0xFFF8FAFC),
    'resume': Color(0xFFF8FAFC),
    'subscription_purchase': Color(0xFFF8FAFC),
    'subscription_renew': Color(0xFFF8FAFC),
    'subscription_shift': Color(0xFFF8FAFC),
    'subscription_refund': Color(0xFFF8FAFC),
  };
}
