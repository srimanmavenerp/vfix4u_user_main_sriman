import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:Vfix4u/common/widgets/demo_reset_dialog_widget.dart';
import 'package:Vfix4u/feature/booking/widget/booking_ignored_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:Vfix4u/utils/core_export.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHelper {
  /// Initialize notifications
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/notification_icon');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      if (kDebugMode) print("Payload: ${response.payload}");
      try {
        if (response.payload != null && response.payload!.isNotEmpty) {
          final NotificationBody notificationBody =
              NotificationBody.fromJson(jsonDecode(response.payload!));

          _handleNotificationTap(notificationBody);
        }
      } catch (e) {
        if (kDebugMode) print("Error handling notification tap: $e");
      }
    });

    /// Firebase onMessage (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (kDebugMode) print("Foreground message: ${message.data}");

      if (!ResponsiveHelper.isWeb()) {
        await _handleForegroundNotification(
            message, flutterLocalNotificationsPlugin);
      }
    });

    /// Firebase onMessageOpenedApp (User taps notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) print("Notification opened: ${message.data}");
      try {
        if (message.data.isNotEmpty) {
          final notificationBody = NotificationBody.fromJson(message.data);
          _handleNotificationTap(notificationBody);
        }
      } catch (e) {
        if (kDebugMode) print("Error handling opened notification: $e");
      }
    });
  }

  /// Handle foreground messages
  static Future<void> _handleForegroundNotification(
      RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {
    final type = message.data['type'];

    if (type == 'chatting') {
      final channelId = message.data['channel_id'];
      if (channelId != null && channelId.isNotEmpty) {
        // Update chat if user is on chat screen
        if (Get.currentRoute.contains(RouteHelper.chatScreen) &&
            channelId == Get.find<ConversationController>().channelId) {
          Get.find<ConversationController>().cleanOldData();
          Get.find<ConversationController>().setChannelId(channelId);
          Get.find<ConversationController>()
              .getConversation(channelId, 1, isInitial: true);
        } else {
          await showNotification(message, fln, false);
        }
      } else {
        await showNotification(message, fln, false);
      }
    } else if (type == 'bidding' || type == 'bid-withdraw') {
      await showNotification(message, fln, false);
    } else if (type == 'booking_ignored') {
      if (Get.find<AuthController>().isNotificationActive()) {
        final player = AudioPlayer();
        player.play(AssetSource('notification.mp3'));
      }
      Get.dialog(
        Center(
            child: NotificationIgnoredBottomSheet(
                bookingId: message.data['booking_id'])),
        barrierDismissible: false,
      );
    } else {
      await showNotification(message, fln, false);
    }
  }

  /// Handle taps on notifications
  static void _handleNotificationTap(NotificationBody notificationBody) {
    if (notificationBody.notificationType == "chatting") {
      if (!GetPlatform.isWeb) {
        if (Get.currentRoute.contains(RouteHelper.chatScreen)) {
          Get.back();
          Get.back();
        } else if (Get.currentRoute.contains(RouteHelper.chatInbox)) {
          Get.back();
        }
      }
      Get.toNamed(RouteHelper.getChatScreenRoute(
          notificationBody.channelId ?? "",
          notificationBody.userType == 'super-admin'
              ? "admin"
              : notificationBody.userName ?? "",
          notificationBody.userProfileImage ?? "",
          notificationBody.userPhone ?? "",
          notificationBody.userType ?? "",
          fromNotification: "fromNotification"));
    } else if (notificationBody.notificationType == 'bidding' ||
        notificationBody.notificationType == 'bid-withdraw') {
      Get.toNamed(
          RouteHelper.getMyPostScreen(fromNotification: "fromNotification"));
    } else if (notificationBody.notificationType == 'booking' &&
        notificationBody.bookingId != null &&
        notificationBody.bookingId!.isNotEmpty) {
      if (notificationBody.bookingType == "repeat" &&
          notificationBody.repeatBookingType == "single") {
        Get.toNamed(RouteHelper.getBookingDetailsScreen(
            subBookingId: notificationBody.bookingId!,
            fromPage: 'fromNotification'));
      } else if (notificationBody.bookingType == "repeat") {
        Get.toNamed(RouteHelper.getRepeatBookingDetailsScreen(
            bookingId: notificationBody.bookingId,
            fromPage: "fromNotification"));
      } else {
        Get.toNamed(RouteHelper.getBookingDetailsScreen(
            bookingID: notificationBody.bookingId!,
            fromPage: 'fromNotification'));
      }
    } else if (notificationBody.notificationType == 'wallet') {
      Get.toNamed(
          RouteHelper.getMyWalletScreen(fromNotification: "fromNotification"));
    } else if (notificationBody.notificationType == 'loyalty_point') {
      Get.toNamed(RouteHelper.getLoyaltyPointScreen(
          fromNotification: "fromNotification"));
    } else if (notificationBody.notificationType == 'logout') {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getSignInRoute());
    } else if (notificationBody.notificationType == 'privacy_policy') {
      Get.toNamed(RouteHelper.getHtmlRoute("privacy-policy"));
    } else if (notificationBody.notificationType == 'terms_and_conditions') {
      Get.toNamed(RouteHelper.getHtmlRoute("terms-and-condition"));
    } else {
      Get.toNamed(RouteHelper.getNotificationRoute());
    }
  }

  /// Show local notification
  static Future<void> showNotification(RemoteMessage message,
      FlutterLocalNotificationsPlugin fln, bool data) async {
    if (GetPlatform.isIOS) return;

    final String? title = message.data['title'];
    final String body = message.data['body'] ?? '';
    final String? image = message.data['image'] != null &&
            message.data['image'].isNotEmpty
        ? (message.data['image'].startsWith('http')
            ? message.data['image']
            : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}')
        : null;
    final String payload = jsonEncode(message.data);

    if (image != null) {
      try {
        await showBigPictureNotification(title!, body, payload, image, fln);
      } catch (_) {
        await showBigTextNotification(title!, body, payload, fln);
      }
    } else {
      await showBigTextNotification(title!, body, payload, fln);
    }
  }

  static Future<void> showBigTextNotification(String title, String body,
      String payload, FlutterLocalNotificationsPlugin fln) async {
    final BigTextStyleInformation styleInformation = BigTextStyleInformation(
        body,
        contentTitle: title,
        htmlFormatContentTitle: true,
        htmlFormatBigText: true);

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'vfix4u',
      'demandium',
      importance: Importance.max,
      priority: Priority.max,
      playSound: Get.find<AuthController>().isNotificationActive(),
      styleInformation: styleInformation,
      sound: Get.find<AuthController>().isNotificationActive()
          ? const RawResourceAndroidNotificationSound('notification')
          : null,
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await fln.show(Random().nextInt(100), title, body, notificationDetails,
        payload: payload);
  }

  static Future<void> showBigPictureNotification(String title, String body,
      String payload, String image, FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath =
        await _downloadAndSaveFile(image, 'bigPicture');

    final BigPictureStyleInformation styleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: body,
      htmlFormatSummaryText: true,
      hideExpandedLargeIcon: true,
    );

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'vfix4u',
      'demandium',
      importance: Importance.max,
      priority: Priority.max,
      playSound: Get.find<AuthController>().isNotificationActive(),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: styleInformation,
      sound: Get.find<AuthController>().isNotificationActive()
          ? const RawResourceAndroidNotificationSound('notification')
          : null,
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await fln.show(Random().nextInt(100), title, body, notificationDetails,
        payload: payload);
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static NotificationBody convertNotification(Map<String, dynamic> data) =>
      NotificationBody.fromJson(data);
}

/// Background handler
@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  if (kDebugMode) print("Background message: ${message.data}");
}
