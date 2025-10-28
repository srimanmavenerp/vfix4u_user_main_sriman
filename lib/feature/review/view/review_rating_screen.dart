import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/remote/client_api.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/styles.dart';
import '../../booking/model/service_booking_model.dart';

class CustomerReviewResponse {
  final bool showReviewPopup;
  final String bookingId;
  final String servicemanId;
  final String categoryId;
  final String subCategoryId;
  final String readableId;

  CustomerReviewResponse({
    required this.showReviewPopup,
    required this.bookingId,
    required this.servicemanId,
    required this.categoryId,
    required this.subCategoryId,
    required this.readableId,
  });

  factory CustomerReviewResponse.fromJson(Map<String, dynamic> json) {
    return CustomerReviewResponse(
      showReviewPopup: json['show_review_popup'] ?? false,
      bookingId: json['booking_id']?.toString() ?? '',
      servicemanId: json['serviceman_id']?.toString() ?? '',
      categoryId: json['category']?.toString() ?? '',
      subCategoryId: json['sub_category']?.toString() ?? '',
      readableId: json['booking_readable_id']?.toString() ?? '',
    );
  }
}

class ReviewBody {
  final String bookingID;
  final String reviewRating;
  final String comment;
  final String serviceID;

  ReviewBody({
    required this.bookingID,
    required this.reviewRating,
    required this.comment,
    required this.serviceID,
  });

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingID,
      'review_rating': reviewRating,
      'comment': comment,
      'service_id': serviceID,
    };
  }
}

class NewSubmitReviewRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  NewSubmitReviewRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> submitReview({required ReviewBody reviewBody}) async {
    return await apiClient.postData(AppConstants.serviceReview, reviewBody.toJson());
  }

  Future<Response> getReviewList({required String bookingId}) async {
    return await apiClient.getData('${AppConstants.bookingReviewList}?booking_id=$bookingId');
  }
}


class MyReviewScreen extends StatefulWidget {
  final BookingModel bookingModel;
  final bool showCommentField;

  const MyReviewScreen({
    super.key,
    required this.bookingModel,
    this.showCommentField = true,
  });

  @override
  State<MyReviewScreen> createState() => _MyReviewScreenState();
}

class _MyReviewScreenState extends State<MyReviewScreen> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  CustomerReviewResponse? customerReviewData;
  bool isLoadingReviewData = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchReview();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> fetchReview() async {
    try {
      final apiClient = Get.find<ApiClient>();
      String? token = apiClient.token;
      debugPrint('Authorization Tokennnnnnnnnnn: Bearer $token');

      if (token == null || token.isEmpty) {
        setState(() {
          errorMessage = 'Error: Token not found';
          isLoadingReviewData = false;
        });
        return;
      }

      String customerId = widget.bookingModel.customerId ?? '';
      if (customerId.isEmpty) {
        setState(() {
          errorMessage = 'Error: Customer ID is empty';
          isLoadingReviewData = false;
        });
        return;
      }

      final Response response = await apiClient.getData(
        '/api/v1/customer/review/customer-last-completed-booking?customer_id=$customerId',
      );

      if (response.statusCode == 200 && response.body != null) {
        setState(() {
          customerReviewData = CustomerReviewResponse.fromJson(response.body);
          isLoadingReviewData = false;
          debugPrint('Review Response: ${response.body}');
          debugPrint('Show Review Popup: ${customerReviewData?.showReviewPopup}');
          if (customerReviewData?.showReviewPopup == true) {
            debugPrint('Booking ID: ${customerReviewData?.bookingId}');
            debugPrint('Serviceman ID: ${customerReviewData?.servicemanId}');
            debugPrint('Category ID: ${customerReviewData?.categoryId}');
            debugPrint('Sub Category ID: ${customerReviewData?.subCategoryId}');
            debugPrint('readableId ID: ${customerReviewData?.readableId}');
          } else {
            debugPrint('Review popup not shown as show_review_popup is false');
          }
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.body['message'] ?? response.statusText ?? 'Unknown error'}';
          isLoadingReviewData = false;
        });
        debugPrint('Error Response: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in fetchReview: $e');
      setState(() {
        errorMessage = 'Error: $e';
        isLoadingReviewData = false;
      });
    }
  }

  void _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    final reviewBody = ReviewBody(
      bookingID: customerReviewData!.bookingId ?? '',
      reviewRating: _rating.toInt().toString(),
      comment: widget.showCommentField ? _commentController.text.trim() : '',
      serviceID: customerReviewData?.servicemanId ?? widget.bookingModel.servicemanId ?? '',
      ////status: '1'
    );

    debugPrint('Submitting review:');
    debugPrint('Booking ID: ${reviewBody.bookingID}');
    debugPrint('Service ID: ${reviewBody.serviceID}');
    debugPrint('Rating: ${reviewBody.reviewRating}');
    debugPrint('Comment: ${reviewBody.comment}');

    final response = await Get.find<NewSubmitReviewRepo>().submitReview(reviewBody: reviewBody);

    debugPrint('Review Submission Response:');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.pop(context);
      });
    } else {
      String errorMsg = 'Failed to submit review';
      if (response.body != null && response.body['errors'] != null) {
        List errors = response.body['errors'];
        if (errors.isNotEmpty) {
          errorMsg = errors.map((e) => e['message'] ?? 'Unknown error').join(', ');
        } else if (response.body['message'] != null) {
          errorMsg = response.body['message'];
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('review_and_rating'.tr),
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: _buildCompactCard(),
      ),
    );
  }

  Widget _buildCompactCard() {
    if (isLoadingReviewData) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage.isNotEmpty) {
      return Text(
        errorMessage,
        style: robotoRegular.copyWith(
          color: Colors.red,
          fontSize: Dimensions.fontSizeSmall,
        ),
      );
    }
    if (customerReviewData == null || !customerReviewData!.showReviewPopup) {
      return const SizedBox.shrink(); // Display nothing if showReviewPopup is false or data is empty
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            Icons.bookmark_outline,
            'booking_id'.tr,
            customerReviewData!.readableId.isNotEmpty
                ? customerReviewData!.readableId
                : 'n_a'.tr,
          ),
          _buildDetailRow(
            Icons.category_outlined,
            'category'.tr,
            customerReviewData!.categoryId.isNotEmpty
                ? customerReviewData!.categoryId
                : 'n_a'.tr,
          ),
          const SizedBox(height:10),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => setState(() => _rating = index + 1),
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 20,
                    color: index < _rating
                        ? Colors.amber
                        : Theme.of(context).disabledColor,
                  ),
                  //onPressed: () => setState(() => _rating = index + 1),
                ),
              );
            }),
          ),

          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: List.generate(5, (index) {
          //       return GestureDetector(
          //         onTap: () => setState(() => _rating = index + 1),
          //         child: Icon(
          //           index < _rating ? Icons.star : Icons.star_border,
          //           size: 20,
          //           color: index < _rating
          //               ? Colors.amber
          //               : Theme.of(context).disabledColor,
          //         ),
          //       );
          //     }),
          //   ),
          // ),


          if (widget.showCommentField) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                     // maxLength: 2,
                      controller: _commentController,
                      decoration: InputDecoration(

                        hintText: 'share_your_experience'.tr,
                        hintStyle: robotoRegular.copyWith(
                          color: Theme.of(context).hintColor,
                          fontSize: Dimensions.fontSizeSmall,

                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          borderSide: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall,
                          vertical: Dimensions.paddingSizeExtraSmall,
                        ),
                      ),
                      maxLines: 2,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 32,
                    width: 80,
                    child: ElevatedButton(
                      onPressed: _submitReview,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeExtraSmall,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                      ),
                      child: Text(
                        'submit'.tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: Dimensions.paddingSizeDefault),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeExtraSmall,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),
                child: Center(
                  child: Text(
                    'submit'.tr,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6)),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Flexible(
            child: Text(
              '$title: ',
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}