import 'package:demandium/feature/booking/widget/booking_otp_widget.dart';
import 'package:demandium/feature/booking/widget/booking_photo_evidence.dart';
import 'package:demandium/feature/booking/widget/payment_info_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:demandium/feature/booking/widget/regular/booking_summery_widget.dart';
import 'package:demandium/feature/booking/widget/provider_info.dart';
import 'package:demandium/feature/booking/widget/service_man_info.dart';
import 'package:intl/intl.dart';
import 'booking_screen_shimmer.dart';

class BookingDetailsSection extends StatelessWidget {
  final String? bookingId;
  final bool isSubBooking;
  const BookingDetailsSection(
      {super.key, this.bookingId, required this.isSubBooking});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BookingDetailsController>(
          builder: (bookingDetailsTabController) {
        BookingDetailsContent? bookingDetails = isSubBooking
            ? bookingDetailsTabController.subBookingDetailsContent
            : bookingDetailsTabController.bookingDetailsContent;
        if (bookingDetails != null) {
          String bookingStatus = bookingDetails.bookingStatus ?? "";
          bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
          print("object12345676543234567ui${bookingDetails.pickupInfo}");
          print("object12345676543234567ui${bookingDetails.cancelReasons}");
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      BookingInfo(
                        bookingDetails: bookingDetails,
                        bookingDetailsTabController:
                            bookingDetailsTabController,
                        isSubBooking: isSubBooking,
                      ),
                      (Get.find<SplashController>()
                                  .configModel
                                  .content!
                                  .confirmationOtpStatus! &&
                              (bookingStatus == "accepted" ||
                                  bookingStatus == "ongoing"))
                          ? BookingOtpWidget(bookingDetails: bookingDetails)
                          : const SizedBox(
                              height: Dimensions.paddingSizeDefault,
                            ),
                      PaymentView(
                          bookingDetails: bookingDetails,
                          isSubBooking: isSubBooking),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      if (!(bookingDetails?.pickupInfo?.pickupOption?.isEmpty ??
                          true))
                        PickupDetailsCard(
                          laptopDetails: bookingDetails
                                  ?.pickupInfo?.laptopDetails
                                  ?.toJson() ??
                              {},
                          bookingOtp: bookingDetails?.pickupInfo?.bookingOtp,
                          status: bookingDetails?.pickupInfo?.pickupOption,
                          date: bookingDetails?.pickupInfo?.rescheduleDate,
                        ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      BookingSummeryWidget(bookingDetails: bookingDetails),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      bookingDetails.provider != null
                          ? ProviderInfo(provider: bookingDetails.provider!)
                          : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      bookingDetails.serviceman != null
                          ? ServiceManInfo(
                              user: bookingDetails.serviceman!.user!)
                          : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      bookingDetails.photoEvidenceFullPath != null &&
                              bookingDetails.photoEvidenceFullPath!.isNotEmpty
                          ? BookingPhotoEvidence(
                              bookingDetailsContent: bookingDetails)
                          : const SizedBox(),
                      SizedBox(
                          height: bookingStatus == "completed" && isLoggedIn
                              ? Dimensions.paddingSizeExtraLarge * 3
                              : Dimensions.paddingSizeExtraLarge),
                    ]),
              ),
            ),
          );
        } else {
          return const SingleChildScrollView(child: BookingScreenShimmer());
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GetBuilder<BookingDetailsController>(
          builder: (bookingDetailsController) {
        if (bookingDetailsController.bookingDetailsContent != null &&
            !isSubBooking) {
          return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(
                bottom: Dimensions.paddingSizeDefault,
                left: Dimensions.paddingSizeDefault,
                right: Dimensions.paddingSizeDefault,
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Get.find<AuthController>().isLoggedIn() &&
                        (bookingDetailsController
                                    .bookingDetailsContent!.bookingStatus ==
                                'accepted' ||
                            bookingDetailsController
                                    .bookingDetailsContent!.bookingStatus ==
                                'ongoing')
                    ? FloatingActionButton(
                        hoverColor: Colors.transparent,
                        elevation: 0.0,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          BookingDetailsContent bookingDetailsContent =
                              bookingDetailsController.bookingDetailsContent!;

                          if (bookingDetailsContent.provider != null) {
                            showModalBottomSheet(
                              useRootNavigator: true,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => CreateChannelDialog(
                                isSubBooking: isSubBooking,
                              ),
                            );
                          } else {
                            customSnackBar(
                                'provider_or_service_man_assigned'.tr,
                                type: ToasterMessageType.info);
                          }
                        },
                        child: Icon(Icons.message_rounded,
                            color: Theme.of(context).primaryColorLight),
                      )
                    : const SizedBox(),
              ]),
            ),
            bookingDetailsController.bookingDetailsContent!.bookingStatus ==
                    'completed'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Get.find<AuthController>().isLoggedIn()
                          ? CustomButton(
                              radius: 5,
                              width: ResponsiveHelper.isDesktop(context)
                                  ? 200
                                  : 200,
                              fontSize: Dimensions.fontSizeSmall,
                              buttonText: 'Review'.tr,
                              onPressed: () {
                                // Ensure that the bookingDetailsController and its bookingDetailsContent are not null
                                if (bookingDetailsController
                                        .bookingDetailsContent !=
                                    null) {
                                  // Close the current screen
                                  Get.back();

                                  // Navigate to the RateReviewScreen with the booking ID
                                  Get.toNamed(
                                    RouteHelper.getRateReviewScreen(
                                      bookingDetailsController
                                          .bookingDetailsContent!.id!,
                                    ),
                                  );
                                }
                              },
                            )
                          : const SizedBox(),
                      Get.find<AuthController>().isLoggedIn()
                          ? const SizedBox(
                              width: 15,
                            )
                          : const SizedBox(),
                    ],
                  )
                : const SizedBox()
          ]);
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}

class PickupDetailsCard extends StatelessWidget {
  final Map<String, dynamic> laptopDetails;
  final dynamic bookingOtp;
  final dynamic status;
  final dynamic date;

  const PickupDetailsCard({
    super.key,
    required this.laptopDetails,
    this.bookingOtp,
    this.status,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    final List<String> imageUrls = (laptopDetails['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final statusString = status?.toString().toLowerCase();

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pickup Details",
              style: robotoMedium.copyWith(
                fontSize: 16,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            _buildRow("Status", status?.toString(), textColor),
            const SizedBox(height: 8),
            if (statusString == "reschedule")
              _buildRow(
                "Date",
                date != null
                    ? DateFormat("yyyy-MM-dd HH:mm:ss")
                        .format(DateTime.parse(date.toString()))
                    : "-",
                textColor,
              ),
            if (statusString == "pickup") ...[
              const SizedBox(height: 8),
              _buildRow("OTP", bookingOtp?.toString(), textColor),
              const SizedBox(height: 8),
              _buildRow("RAM", laptopDetails['ram'], textColor),
              const SizedBox(height: 8),
              _buildRow("Storage", laptopDetails['storage'], textColor),
              const SizedBox(height: 8),
              _buildRow("Processor", laptopDetails['processor'], textColor),
              const SizedBox(height: 8),
              _buildRow("Model", laptopDetails['model'], textColor),
              const SizedBox(height: 8),
              _buildRow("Note", laptopDetails['note'], textColor),
              const SizedBox(height: 12),
            ],
            if (imageUrls.isNotEmpty) _buildImageGrid(context, imageUrls),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String? value, Color textColor) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          TextSpan(
            text: value ?? "-",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context, List<String> imageUrls) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        final imageUrl = imageUrls[index];
        return GestureDetector(
          onTap: () => _showFullScreenImage(context, imageUrl),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
