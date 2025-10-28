import 'package:demandium/feature/home/widget/nearby_provider_listview.dart';
import 'package:demandium/popupbanneradds.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../review/repo/submit_review_repo.dart';
import '../review/view/new_rate_card.dart';
import '../review/view/review_rating_screen.dart';

class HomeScreen extends StatefulWidget {
  static Future<void> loadData(bool reload,
      {int availableServiceCount = 1}) async {
    if (availableServiceCount == 0) {
      Get.find<BannerController>().getBannerList(reload);
    } else {
      await Future.wait([
        Get.find<ServiceController>().getRecommendedSearchList(),
        Get.find<ServiceController>().getAllServiceList(1, reload),
        Get.find<BannerController>().getBannerList(reload),
        Get.find<AdvertisementController>().getAdvertisementList(reload),
        Get.find<CategoryController>().getCategoryList(reload),
        Get.find<ServiceController>().getPopularServiceList(1, reload),
        Get.find<ServiceController>().getTrendingServiceList(1, reload),
        Get.find<ProviderBookingController>().getProviderList(1, reload),
        Get.find<NearbyProviderController>().getProviderList(1, reload),
        Get.find<CampaignController>().getCampaignList(reload),
        Get.find<ServiceController>().getRecommendedServiceList(1, reload),
        Get.find<CheckOutController>()
            .getOfflinePaymentMethod(false, shouldUpdate: false),
        Get.find<ServiceController>().getFeatherCategoryList(reload),
        if (Get.find<AuthController>().isLoggedIn())
          Get.find<AuthController>().updateToken(),
        if (Get.find<AuthController>().isLoggedIn())
          Get.find<ServiceController>().getRecentlyViewedServiceList(1, reload),
      ]);

      Get.find<BookingDetailsController>().manageDialog();
    }
  }

  final AddressModel? addressModel;
  final bool showServiceNotAvailableDialog;
  final UserInfoModel? userInfoModel;

  const HomeScreen(
      {super.key,
      this.addressModel,
      required this.showServiceNotAvailableDialog,
      this.userInfoModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  AddressModel? _previousAddress;
  int availableServiceCount = 0;
  bool _hasCheckedRatingDialog = false; // Flag to prevent multiple checks
  bool _isRetryingCustomerId =
      false; // Flag to track if we're currently retrying
  int _customerIdRetryCount = 0; // Counter for retries
  static const int _maxRetries = 5; // Maximum number of retries
  Timer? _customerIdRetryTimer; // Timer for retry mechanism
  bool _bannerShown = false; // to prevent multiple popups
  @override
  void initState() {
    super.initState();
    final bannerController = Get.put(PopupBannerController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Listen to loading status
      ever(bannerController.isLoading, (loading) {
        if (!loading && !_bannerShown) {
          _bannerShown = true;
          bannerController.showBannerPopup();
        }
      });
    });
    // final popupBannerController = Get.put(PopupBannerController());
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   popupBannerController.showBannerPopup();
    // });
    WidgetsBinding.instance
        .addObserver(this); // Add observer for lifecycle changes

    Get.find<LocalizationController>().filterLanguage(shouldUpdate: false);

    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<LocationController>().getAddressList();
    }

    if (Get.find<LocationController>().getUserAddress() != null) {
      availableServiceCount = Get.find<LocationController>()
          .getUserAddress()!
          .availableServiceCountInZone!;
    }

    HomeScreen.loadData(false, availableServiceCount: availableServiceCount);
    _previousAddress = widget.addressModel;

    // Delay the rating dialog check to ensure it only runs once after initialization
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_hasCheckedRatingDialog) {
        _checkRatingDialog();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed &&
        mounted &&
        !_hasCheckedRatingDialog) {
      debugPrint('HomeScreen resumed, checking rating dialog');
      _checkRatingDialog(); // Call only if not already checked
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    _customerIdRetryTimer?.cancel(); // Cancel any pending timers
    super.dispose();
  }

  Future<String?> _getCustomerId() async {
    String? customerId = Get.find<UserController>().userInfoModel?.id;

    if (customerId == null || customerId.isEmpty) {
      debugPrint(
          'Customer ID is null or empty, attempting to refresh user info');

      await Get.find<UserController>().getUserInfo();
      customerId = Get.find<UserController>().userInfoModel?.id;

      debugPrint('After refresh, customer ID: ${customerId ?? "still null"}');
    }

    return customerId;
  }

  Future<void> _checkRatingDialog() async {
    if (_hasCheckedRatingDialog) {
      debugPrint('Rating dialog already checked, skipping');
      return;
    }

    debugPrint('=== Starting _checkRatingDialog ===');

    final prefs = await SharedPreferences.getInstance();
    final currentDate = DateTime.now().toIso8601String().split('T')[0];
    final lastShownDate = prefs.getString('rating_popup_last_shown_date');

    // // Skip if the popup was shown today
    // if (lastShownDate == currentDate) {
    //   debugPrint('Rating popup already shown today ($currentDate), skipping');
    //   _hasCheckedRatingDialog = true; // Mark as checked since we're skipping
    //   return;
    // }

    if (!Get.find<AuthController>().isLoggedIn()) {
      debugPrint('User not logged in, skipping rating dialog');
      _hasCheckedRatingDialog = true;
      return;
    }

    try {
      final apiClient = Get.find<ApiClient>();
      String? token = apiClient.token;
      debugPrint('Authorization Token: Bearer $token');

      if (token == null || token.isEmpty) {
        debugPrint('Error: Token not found');
        _hasCheckedRatingDialog = true; // Mark as checked since we're skipping
        return;
      }

      String? customerId = await _getCustomerId();
      if (customerId == null || customerId.isEmpty) {
        if (_customerIdRetryCount < _maxRetries && !_isRetryingCustomerId) {
          _isRetryingCustomerId = true;
          _customerIdRetryCount++;

          debugPrint(
              'Error: Customer ID is null or empty. Retrying (${_customerIdRetryCount}/$_maxRetries) in 3 seconds...');

          // Set up a timer to retry
          _customerIdRetryTimer = Timer(const Duration(seconds: 3), () {
            if (mounted) {
              _isRetryingCustomerId = false;
              _checkRatingDialog(); // Recursive call to retry
            }
          });
          return;
        } else if (_customerIdRetryCount >= _maxRetries) {
          debugPrint('Error: Max retries reached for Customer ID. Giving up.');
          _hasCheckedRatingDialog =
              true; // Mark as checked since we're giving up
          return;
        }
      }

      debugPrint('Fetching review data for customer ID: $customerId');
      final Response response = await apiClient.getData(
        '/api/v1/customer/review/customer-last-completed-booking?customer_id=$customerId',
      );

      debugPrint('Review API Response Status: ${response.statusCode}');
      debugPrint('Review API Response Body: ${response.body}');

      if (response.statusCode == 200 && response.body != null) {
        final customerReviewData =
            CustomerReviewResponse.fromJson(response.body);

        debugPrint('Show Review Popup: ${customerReviewData.showReviewPopup}');
        debugPrint('Booking ID: ${customerReviewData.bookingId}');
        debugPrint('Serviceman ID: ${customerReviewData.servicemanId}');
        debugPrint('Category ID: ${customerReviewData.categoryId}');
        debugPrint('Sub Category ID: ${customerReviewData.subCategoryId}');
        debugPrint('Readable ID: ${customerReviewData.readableId}');

        if (!customerReviewData.showReviewPopup) {
          debugPrint('Review popup not shown as show_review_popup is false');
          _hasCheckedRatingDialog = true; // Mark as checked
          return;
        }

        final BookingModel latestBooking = BookingModel(
          id: customerReviewData.bookingId,
          readableId: customerReviewData.readableId,
          customerId: customerId,
          servicemanId: customerReviewData.servicemanId,
          categoryId: customerReviewData.categoryId,
          subCategoryId: customerReviewData.subCategoryId,
        );

        // Ensure the dialog is shown only if the current route is HomeScreen
        if (mounted && ModalRoute.of(context)?.isCurrent == true) {
          debugPrint(
              'Showing RatingPopupDialog for booking: ${latestBooking.id}');
          _hasCheckedRatingDialog = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => RatingPopupDialog(
              bookingModel: latestBooking,
              onSkip: () => _skipReview(latestBooking.id!),
            ),
          ).then((_) async {
            await prefs.setString('rating_popup_last_shown_date', currentDate);
            debugPrint('Rating popup shown and recorded on $currentDate');
          });
        } else {
          debugPrint('Not on HomeScreen route, skipping popup');
          _hasCheckedRatingDialog = true; // Mark as checked
        }
      } else {
        debugPrint('Error Response: ${response.body}');
        debugPrint(
            'Failed to load review data: ${response.body['message'] ?? response.statusText ?? 'Unknown error'}');
        _hasCheckedRatingDialog = true;
      }
    } catch (e, stackTrace) {
      debugPrint('Error in fetchReview: $e');
      debugPrint('Stack Trace: $stackTrace');
      _hasCheckedRatingDialog =
          true; // Mark as checked since we caught an exception
    }

    debugPrint('=== End of _checkRatingDialog ===');
  }

  Future<void> _skipReview(String bookingId) async {
    try {
      final apiClient = Get.find<ApiClient>();
      String? token = apiClient.token;

      if (token == null || token.isEmpty) {
        debugPrint('Error: Token not found for skip review');
        return;
      }

      debugPrint('Attempting to skip review for booking ID: $bookingId');
      final Response response = await apiClient.postData(
        '/api/v1/customer/review/skip-review/send',
        {'booking_id': bookingId},
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Skip Review API Response Status: ${response.statusCode}');
      debugPrint('Skip Review API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint(' Skip review successful for booking ID: $bookingId');
      } else {
        debugPrint(
            ' Failed to skip review: ${response.statusCode} ${response.body['message'] ?? response.statusText ?? 'Unknown error'}');
      }
    } catch (e, stackTrace) {
      debugPrint('Exception during skip review: $e');
      debugPrint('Stack Trace: $stackTrace');
    }
  }

  homeAppBar({GlobalKey<CustomShakingWidgetState>? signInShakeKey}) {
    if (ResponsiveHelper.isDesktop(context)) {
      return WebMenuBar(signInShakeKey: signInShakeKey);
    } else {
      return AddressAppBar(
        backButton: false,
        userInfoModel: widget.userInfoModel,
      );
    }
  }

  final ScrollController scrollController = ScrollController();
  final signInShakeKey = GlobalKey<CustomShakingWidgetState>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: homeAppBar(signInShakeKey: signInShakeKey),
      endDrawer:
          ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     var bookingController = Get.find<ServiceBookingController>();
      //     BookingModel? latestBooking;
      //     if (bookingController.bookingList != null && bookingController.bookingList!.isNotEmpty) {
      //       latestBooking = bookingController.bookingList!
      //           .where((booking) => booking.bookingStatus == 'completed')
      //           .firstOrNull;
      //     }
      //
      //     if (latestBooking != null) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (_) => MyReviewScreen(bookingModel: latestBooking!),
      //         ),
      //       );
      //     } else {
      //       showDialog(
      //         context: context,
      //         builder: (context) => AlertDialog(
      //           title: const Text('No Completed Bookings'),
      //           content: const Text('You need to have at least one completed booking to leave a review.'),
      //           actions: [
      //             TextButton(
      //               onPressed: () => Navigator.of(context).pop(),
      //               child: const Text('OK'),
      //             ),
      //           ],
      //         ),
      //       );
      //     }
      //   },
      //   tooltip: 'Rating',
      //   child: const Icon(Icons.star_rate, color: Colors.white),
      // ),
      body: ResponsiveHelper.isDesktop(context)
          ? WebHomeScreen(
              scrollController: scrollController,
              availableServiceCount: availableServiceCount,
              signInShakeKey: signInShakeKey,
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  debugPrint('RefreshIndicator triggered');
                  if (availableServiceCount > 0) {
                    await Get.find<ServiceController>()
                        .getAllServiceList(1, true);
                    await Get.find<BannerController>().getBannerList(true);
                    await Get.find<AdvertisementController>()
                        .getAdvertisementList(true);
                    await Get.find<CategoryController>().getCategoryList(true);
                    await Get.find<ServiceController>()
                        .getRecommendedServiceList(1, true);
                    await Get.find<ProviderBookingController>()
                        .getProviderList(1, true);
                    await Get.find<ServiceController>()
                        .getPopularServiceList(1, true);
                    await Get.find<ServiceController>()
                        .getRecentlyViewedServiceList(1, true);
                    await Get.find<ServiceController>()
                        .getTrendingServiceList(1, true);
                    await Get.find<CampaignController>().getCampaignList(true);
                    await Get.find<ServiceController>()
                        .getFeatherCategoryList(true);
                    await Get.find<CartController>().getCartListFromServer();
                  } else {
                    await Get.find<BannerController>().getBannerList(true);
                  }
                  debugPrint(
                      'Refresh completed, resetting rating dialog check');
                  _hasCheckedRatingDialog =
                      false; // Allow re-check after refresh
                  _customerIdRetryCount = 0; // Reset retry counter
                  _isRetryingCustomerId = false; // Reset retry flag
                  await _checkRatingDialog();
                },
                child: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child:
                      GetBuilder<SplashController>(builder: (splashController) {
                    return GetBuilder<ProviderBookingController>(
                        builder: (providerController) {
                      return GetBuilder<ServiceController>(
                          builder: (serviceController) {
                        bool isAvailableProvider =
                            providerController.providerList != null &&
                                providerController.providerList!.isNotEmpty;
                        int? providerBooking = splashController
                            .configModel.content?.directProviderBooking;
                        bool isLtr = Get.find<LocalizationController>().isLtr;

                        return CustomScrollView(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: ClampingScrollPhysics(),
                          ),
                          slivers: [
                            const SliverToBoxAdapter(
                                child: SizedBox(
                                    height: Dimensions.paddingSizeSmall)),
                            const HomeSearchWidget(),
                            SliverToBoxAdapter(
                              child: Center(
                                child: SizedBox(
                                  width: Dimensions.webMaxWidth,
                                  child: Column(
                                    children: [
                                      const BannerView(),
                                      availableServiceCount > 0
                                          ? Column(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeDefault),
                                                  child: CategoryView(),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeDefault),
                                                  child:
                                                      HighlightProviderWidget(),
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeLarge),
                                                HorizontalScrollServiceView(
                                                  fromPage: 'popular_services',
                                                  serviceList: serviceController
                                                      .popularServiceList,
                                                ),
                                                const RandomCampaignView(),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeLarge),
                                                RecommendedServiceView(
                                                    height: isLtr ? 210 : 225),
                                                SizedBox(
                                                  height: (providerBooking ==
                                                              1 &&
                                                          (isAvailableProvider ||
                                                              providerController
                                                                      .providerList ==
                                                                  null))
                                                      ? Dimensions
                                                          .paddingSizeLarge
                                                      : 0,
                                                ),
                                                (providerBooking == 1 &&
                                                        (isAvailableProvider ||
                                                            providerController
                                                                    .providerList ==
                                                                null))
                                                    ? NearbyProviderListview(
                                                        height:
                                                            isLtr ? 190 : 205)
                                                    : const SizedBox(),
                                                (providerBooking == 1 &&
                                                        (isAvailableProvider ||
                                                            providerController
                                                                    .providerList ==
                                                                null))
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: Dimensions
                                                              .paddingSizeDefault,
                                                          vertical: Dimensions
                                                              .paddingSizeLarge,
                                                        ),
                                                        child: SizedBox(
                                                          height: 160,
                                                          child: ExploreProviderCard(
                                                              showShimmer:
                                                                  providerController
                                                                          .providerList ==
                                                                      null),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                if (Get.find<SplashController>()
                                                        .configModel
                                                        .content
                                                        ?.directProviderBooking ==
                                                    1)
                                                  const HomeRecommendProvider(
                                                      height: 220),
                                                if (Get.find<SplashController>()
                                                        .configModel
                                                        .content
                                                        ?.biddingStatus ==
                                                    1)
                                                  (serviceController
                                                                  .allService !=
                                                              null &&
                                                          serviceController
                                                              .allService!
                                                              .isNotEmpty)
                                                      ? const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: Dimensions
                                                                .paddingSizeDefault,
                                                            vertical: Dimensions
                                                                .paddingSizeLarge,
                                                          ),
                                                          child:
                                                              HomeCreatePostView(
                                                                  showShimmer:
                                                                      false),
                                                        )
                                                      : const SizedBox(),
                                                if (Get.find<AuthController>()
                                                    .isLoggedIn())
                                                  HorizontalScrollServiceView(
                                                    fromPage:
                                                        'recently_view_services',
                                                    serviceList: serviceController
                                                        .recentlyViewServiceList,
                                                  ),
                                                const CampaignView(),
                                                HorizontalScrollServiceView(
                                                  fromPage: 'trending_services',
                                                  serviceList: serviceController
                                                      .trendingServiceList,
                                                ),
                                                const FeatheredCategoryView(),
                                                (serviceController.allService !=
                                                            null &&
                                                        serviceController
                                                            .allService!
                                                            .isNotEmpty)
                                                    ? (ResponsiveHelper
                                                                .isMobile(
                                                                    context) ||
                                                            ResponsiveHelper
                                                                .isTab(context))
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                              Dimensions
                                                                  .paddingSizeDefault,
                                                              15,
                                                              Dimensions
                                                                  .paddingSizeDefault,
                                                              Dimensions
                                                                  .paddingSizeSmall,
                                                            ),
                                                            child: TitleWidget(
                                                              textDecoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              title:
                                                                  'all_service'
                                                                      .tr,
                                                              onTap: () =>
                                                                  Get.toNamed(
                                                                      RouteHelper
                                                                          .getSearchResultRoute()),
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink()
                                                    : const SizedBox.shrink(),
                                                PaginatedListView(
                                                  scrollController:
                                                      scrollController,
                                                  totalSize: serviceController
                                                      .serviceContent?.total,
                                                  offset: serviceController
                                                      .serviceContent
                                                      ?.currentPage,
                                                  onPaginate: (int
                                                          offset) async =>
                                                      await serviceController
                                                          .getAllServiceList(
                                                              offset, false),
                                                  showBottomSheet: true,
                                                  itemView: ServiceViewVertical(
                                                    service: serviceController
                                                                .serviceContent !=
                                                            null
                                                        ? serviceController
                                                            .allService
                                                        : null,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? Dimensions
                                                              .paddingSizeExtraSmall
                                                          : Dimensions
                                                              .paddingSizeDefault,
                                                      vertical: ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? Dimensions
                                                              .paddingSizeExtraSmall
                                                          : 0,
                                                    ),
                                                    type: 'others',
                                                    noDataType: NoDataType.home,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .6,
                                              child:
                                                  const ServiceNotAvailableScreen(),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                    });
                  }),
                ),
              ),
            ),
    );
  }
}

class RatingPopupDialog extends StatelessWidget {
  final BookingModel bookingModel;
  final VoidCallback onSkip;

  const RatingPopupDialog({
    super.key,
    required this.bookingModel,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rate Your Experience!'.tr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 220,
                  child: MyReviewScreen(bookingModel: bookingModel),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final currentDate =
                          DateTime.now().toIso8601String().split('T')[0];
                      await prefs.setString(
                          'rating_popup_skip_date', currentDate);
                      debugPrint('Rating popup skipped on $currentDate');
                      onSkip();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'skip'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


///////


// import 'package:demandium/feature/home/widget/nearby_provider_listview.dart';
// import 'package:get/get.dart';
// import 'package:demandium/utils/core_export.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../review/repo/submit_review_repo.dart';
// import '../review/view/new_rate_card.dart';
// import '../review/view/review_rating_screen.dart';
//
//
// class HomeScreen extends StatefulWidget {
//   static Future<void> loadData(bool reload, {int availableServiceCount = 1}) async {
//     if (availableServiceCount == 0) {
//       await Get.find<BannerController>().getBannerList(reload);
//     } else {
//       await Future.wait([
//         Get.find<ServiceController>().getRecommendedSearchList(),
//         Get.find<ServiceController>().getAllServiceList(1, reload),
//         Get.find<BannerController>().getBannerList(reload),
//         Get.find<AdvertisementController>().getAdvertisementList(reload),
//         Get.find<CategoryController>().getCategoryList(reload),
//         Get.find<ServiceController>().getPopularServiceList(1, reload),
//         Get.find<ServiceController>().getTrendingServiceList(1, reload),
//         Get.find<ProviderBookingController>().getProviderList(1, reload),
//         Get.find<NearbyProviderController>().getProviderList(1, reload),
//         Get.find<CampaignController>().getCampaignList(reload),
//         Get.find<ServiceController>().getRecommendedServiceList(1, reload),
//         Get.find<CheckOutController>().getOfflinePaymentMethod(false, shouldUpdate: false),
//         Get.find<ServiceController>().getFeatherCategoryList(reload),
//         if (Get.find<AuthController>().isLoggedIn()) Get.find<AuthController>().updateToken(),
//         if (Get.find<AuthController>().isLoggedIn()) Get.find<ServiceController>().getRecentlyViewedServiceList(1, reload),
//       ]);
//       Get.find<BookingDetailsController>().manageDialog();
//     }
//   }
//
//   final AddressModel? addressModel;
//   final bool showServiceNotAvailableDialog;
//   final UserInfoModel? userInfoModel;
//
//   const HomeScreen({
//     super.key,
//     this.addressModel,
//     required this.showServiceNotAvailableDialog,
//     this.userInfoModel,
//   });
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
//   AddressModel? _previousAddress;
//   int availableServiceCount = 0;
//   bool _hasCheckedRatingDialog = false;
//   bool _isRetryingCustomerId = false;
//   int _customerIdRetryCount = 0;
//   static const int _maxRetries = 5;
//   Timer? _customerIdRetryTimer;
//
//   final ScrollController scrollController = ScrollController();
//   final GlobalKey<CustomShakingWidgetState> signInShakeKey = GlobalKey<CustomShakingWidgetState>();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     Get.find<LocalizationController>().filterLanguage(shouldUpdate: false);
//
//     if (Get.find<AuthController>().isLoggedIn()) {
//       Get.find<UserController>().getUserInfo();
//       Get.find<LocationController>().getAddressList();
//     }
//
//     // Initialize availableServiceCount based on the user's address
//     final userAddress = Get.find<LocationController>().getUserAddress();
//     if (userAddress != null) {
//       availableServiceCount = userAddress.availableServiceCountInZone ?? 0;
//     } else if (widget.addressModel != null) {
//       availableServiceCount = widget.addressModel!.availableServiceCountInZone ?? 0;
//     }
//
//     HomeScreen.loadData(false, availableServiceCount: availableServiceCount);
//     _previousAddress = widget.addressModel;
//
//     // Delay rating dialog check to ensure initialization is complete
//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted && !_hasCheckedRatingDialog) {
//         _checkRatingDialog();
//       }
//     });
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.resumed && mounted && !_hasCheckedRatingDialog) {
//       debugPrint('HomeScreen resumed, checking rating dialog');
//       _checkRatingDialog();
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     scrollController.dispose();
//     _customerIdRetryTimer?.cancel();
//     super.dispose();
//   }
//
//   Future<String?> _getCustomerId() async {
//     String? customerId = Get.find<UserController>().userInfoModel?.id;
//     if (customerId == null || customerId.isEmpty) {
//       debugPrint('Customer ID is null or empty, attempting to refresh user info');
//       await Get.find<UserController>().getUserInfo();
//       customerId = Get.find<UserController>().userInfoModel?.id;
//       debugPrint('After refresh, customer ID: ${customerId ?? "still null"}');
//     }
//     return customerId;
//   }
//
//   Future<void> _checkRatingDialog() async {
//     if (_hasCheckedRatingDialog) {
//       debugPrint('Rating dialog already checked, skipping');
//       return;
//     }
//
//     debugPrint('=== Starting _checkRatingDialog ===');
//     _hasCheckedRatingDialog = true;
//
//     final prefs = await SharedPreferences.getInstance();
//     final currentDate = DateTime.now().toIso8601String().split('T')[0];
//     final lastShownDate = prefs.getString('rating_popup_last_shown_date');
//
//     if (!Get.find<AuthController>().isLoggedIn()) {
//       debugPrint('User not logged in, skipping rating dialog');
//       return;
//     }
//
//     try {
//       final apiClient = Get.find<ApiClient>();
//       String? token = apiClient.token;
//       debugPrint('Authorization Token: Bearer $token');
//
//       if (token == null || token.isEmpty) {
//         debugPrint('Error: Token not found');
//         return;
//       }
//
//       String? customerId = await _getCustomerId();
//       if (customerId == null || customerId.isEmpty) {
//         if (_customerIdRetryCount < _maxRetries && !_isRetryingCustomerId) {
//           _isRetryingCustomerId = true;
//           _customerIdRetryCount++;
//           debugPrint('Error: Customer ID is null. Retrying ($_customerIdRetryCount/$_maxRetries) in 3 seconds...');
//           _customerIdRetryTimer = Timer(const Duration(seconds: 3), () {
//             if (mounted) {
//               _isRetryingCustomerId = false;
//               _checkRatingDialog();
//             }
//           });
//           return;
//         } else if (_customerIdRetryCount >= _maxRetries) {
//           debugPrint('Error: Max retries reached for Customer ID. Giving up.');
//           return;
//         }
//       }
//
//       debugPrint('Fetching review data for customer ID: $customerId');
//       final Response response = await apiClient.getData(
//         '/api/v1/customer/review/customer-last-completed-booking?customer_id=$customerId',
//       );
//
//       debugPrint('Review API Response Status: ${response.statusCode}');
//       debugPrint('Review API Response Body: ${response.body}');
//
//       if (response.statusCode == 200 && response.body != null) {
//         final customerReviewData = CustomerReviewResponse.fromJson(response.body);
//
//         if (!customerReviewData.showReviewPopup) {
//           debugPrint('Review popup not shown as show_review_popup is false');
//           return;
//         }
//
//         final BookingModel latestBooking = BookingModel(
//           id: customerReviewData.bookingId,
//           readableId: customerReviewData.readableId,
//           customerId: customerId,
//           servicemanId: customerReviewData.servicemanId,
//           categoryId: customerReviewData.categoryId,
//           subCategoryId: customerReviewData.subCategoryId,
//         );
//
//         if (mounted && ModalRoute.of(context)?.isCurrent == true) {
//           debugPrint('Showing RatingPopupDialog for booking: ${latestBooking.id}');
//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (context) => RatingPopupDialog(bookingModel: latestBooking),
//           ).then((_) async {
//             await prefs.setString('rating_popup_last_shown_date', currentDate);
//             debugPrint('Rating popup shown and recorded on $currentDate');
//           });
//         } else {
//           debugPrint('Not on HomeScreen route, skipping popup');
//         }
//       } else {
//         debugPrint('Failed to load review data: ${response.body['message'] ?? response.statusText ?? 'Unknown error'}');
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error in fetchReview: $e');
//       debugPrint('Stack Trace: $stackTrace');
//     }
//   }
//
//   PreferredSizeWidget homeAppBar({GlobalKey<CustomShakingWidgetState>? signInShakeKey}) {
//     return ResponsiveHelper.isDesktop(context)
//         ? WebMenuBar(signInShakeKey: signInShakeKey)
//         : AddressAppBar(
//       backButton: false,
//       userInfoModel: widget.userInfoModel,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<LocationController>(builder: (locationController) {
//       // Get the current address (selected or saved)
//       final AddressModel? currentAddress = locationController.selectedAddress ?? locationController.getUserAddress();
//
//       return Scaffold(
//         appBar: homeAppBar(signInShakeKey: signInShakeKey),
//         endDrawer: ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
//         // floatingActionButton: FloatingActionButton(
//         //   onPressed: () {
//         //     var bookingController = Get.find<ServiceBookingController>();
//         //     BookingModel? latestBooking;
//         //     if (bookingController.bookingList != null && bookingController.bookingList!.isNotEmpty) {
//         //       latestBooking = bookingController.bookingList!
//         //           .where((booking) => booking.bookingStatus == 'completed')
//         //           .firstOrNull;
//         //     }
//         //
//         //     if (latestBooking != null) {
//         //       Navigator.push(
//         //         context,
//         //         MaterialPageRoute(
//         //           builder: (_) => MyReviewScreen(bookingModel: latestBooking!),
//         //         ),
//         //       );
//         //     } else {
//         //       showDialog(
//         //         context: context,
//         //         builder: (context) => AlertDialog(
//         //           title: Text('no_completed_bookings'.tr),
//         //           content: Text('no_completed_bookings_message'.tr),
//         //           actions: [
//         //             TextButton(
//         //               onPressed: () => Navigator.of(context).pop(),
//         //               child: Text('ok'.tr),
//         //             ),
//         //           ],
//         //         ),
//         //       );
//         //     }
//         //   },
//         //   tooltip: 'rating'.tr,
//         //   child: const Icon(Icons.star_rate, color: Colors.white),
//         // ),
//         body: RefreshIndicator(
//           onRefresh: () async {
//             debugPrint('RefreshIndicator triggered');
//             if (availableServiceCount > 0) {
//               await Future.wait([
//                 Get.find<ServiceController>().getAllServiceList(1, true),
//                 Get.find<BannerController>().getBannerList(true),
//                 Get.find<AdvertisementController>().getAdvertisementList(true),
//                 Get.find<CategoryController>().getCategoryList(true),
//                 Get.find<ServiceController>().getRecommendedServiceList(1, true),
//                 Get.find<ProviderBookingController>().getProviderList(1, true),
//                 Get.find<ServiceController>().getPopularServiceList(1, true),
//                 Get.find<ServiceController>().getRecentlyViewedServiceList(1, true),
//                 Get.find<ServiceController>().getTrendingServiceList(1, true),
//                 Get.find<CampaignController>().getCampaignList(true),
//                 Get.find<ServiceController>().getFeatherCategoryList(true),
//                 Get.find<CartController>().getCartListFromServer(),
//               ]);
//             } else {
//               await Get.find<BannerController>().getBannerList(true);
//             }
//             debugPrint('Refresh completed, resetting rating dialog check');
//             _hasCheckedRatingDialog = false;
//             _customerIdRetryCount = 0;
//             _isRetryingCustomerId = false;
//             await _checkRatingDialog();
//           },
//           child: SafeArea(
//             child: GetBuilder<SplashController>(builder: (splashController) {
//               return GetBuilder<ProviderBookingController>(builder: (providerController) {
//                 return GetBuilder<ServiceController>(builder: (serviceController) {
//                   bool isAvailableProvider = providerController.providerList != null && providerController.providerList!.isNotEmpty;
//                   int? providerBooking = splashController.configModel.content?.directProviderBooking;
//                   bool isLtr = Get.find<LocalizationController>().isLtr;
//
//                   return CustomScrollView(
//                     controller: scrollController,
//                     physics: const AlwaysScrollableScrollPhysics(
//                       parent: ClampingScrollPhysics(),
//                     ),
//                     slivers: [
//                       SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeSmall)),
//                       // Address Display
//                       // SliverToBoxAdapter(
//                       //   child: Padding(
//                       //     padding: const EdgeInsets.symmetric(
//                       //       horizontal: Dimensions.paddingSizeDefault,
//                       //       vertical: Dimensions.paddingSizeSmall,
//                       //     ),
//                       //     child: Column(
//                       //       crossAxisAlignment: CrossAxisAlignment.start,
//                       //       children: [
//                       //         Text(
//                       //           'current_address'.tr,
//                       //           style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
//                       //         ),
//                       //         const SizedBox(height: Dimensions.paddingSizeSmall),
//                       //         currentAddress != null
//                       //             ? Column(
//                       //           crossAxisAlignment: CrossAxisAlignment.start,
//                       //           children: [
//                       //             Text(
//                       //               currentAddress.address ?? 'unknown_address'.tr,
//                       //               style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
//                       //             ),
//                       //             Text(
//                       //               'zone_id'.tr + ': ${currentAddress.zoneId ?? 'N/A'}',
//                       //               style: robotoRegular.copyWith(
//                       //                 fontSize: Dimensions.fontSizeSmall,
//                       //                 color: Colors.grey,
//                       //               ),
//                       //             ),
//                       //             const SizedBox(height: Dimensions.paddingSizeSmall),
//                       //             CustomButton(
//                       //               buttonText: 'change_address'.tr,
//                       //               width: 150,
//                       //               onPressed: () => Get.toNamed(RouteHelper.getAddressRoute('home')), // Pass 'home' or null
//                       //             ),
//                       //           ],
//                       //         )
//                       //             : Text(
//                       //           'no_address_selected'.tr,
//                       //           style: robotoRegular.copyWith(
//                       //             fontSize: Dimensions.fontSizeDefault,
//                       //             color: Theme.of(context).colorScheme.error,
//                       //           ),
//                       //         ),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // ),
//                       const HomeSearchWidget(),
//                       SliverToBoxAdapter(
//                         child: Center(
//                           child: SizedBox(
//                             width: Dimensions.webMaxWidth,
//                             child: Column(
//                               children: [
//                                 const BannerView(),
//                                 availableServiceCount > 0
//                                     ? Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
//                                       child: CategoryView(),
//                                     ),
//                                     const Padding(
//                                       padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
//                                       child: HighlightProviderWidget(),
//                                     ),
//                                     const SizedBox(height: Dimensions.paddingSizeLarge),
//                                     HorizontalScrollServiceView(
//                                       fromPage: 'popular_services',
//                                       serviceList: serviceController.popularServiceList ?? [],
//                                     ),
//                                     const RandomCampaignView(),
//                                     const SizedBox(height: Dimensions.paddingSizeLarge),
//                                     RecommendedServiceView(height: isLtr ? 210 : 225),
//                                     SizedBox(
//                                       height: (providerBooking == 1 && (isAvailableProvider || providerController.providerList == null))
//                                           ? Dimensions.paddingSizeLarge
//                                           : 0,
//                                     ),
//                                     (providerBooking == 1 && (isAvailableProvider || providerController.providerList == null))
//                                         ? NearbyProviderListview(height: isLtr ? 190 : 205)
//                                         : const SizedBox(),
//                                     (providerBooking == 1 && (isAvailableProvider || providerController.providerList == null))
//                                         ? Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: Dimensions.paddingSizeDefault,
//                                         vertical: Dimensions.paddingSizeLarge,
//                                       ),
//                                       child: SizedBox(
//                                         height: 160,
//                                         child: ExploreProviderCard(showShimmer: providerController.providerList == null),
//                                       ),
//                                     )
//                                         : const SizedBox(),
//                                     if (splashController.configModel.content?.directProviderBooking == 1)
//                                       const HomeRecommendProvider(height: 220),
//                                     if (splashController.configModel.content?.biddingStatus == 1)
//                                       (serviceController.allService != null && serviceController.allService!.isNotEmpty)
//                                           ? const Padding(
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: Dimensions.paddingSizeDefault,
//                                           vertical: Dimensions.paddingSizeLarge,
//                                         ),
//                                         child: HomeCreatePostView(showShimmer: false),
//                                       )
//                                           : const SizedBox(),
//                                     if (Get.find<AuthController>().isLoggedIn())
//                                       HorizontalScrollServiceView(
//                                         fromPage: 'recently_view_services',
//                                         serviceList: serviceController.recentlyViewServiceList ?? [],
//                                       ),
//                                     const CampaignView(),
//                                     HorizontalScrollServiceView(
//                                       fromPage: 'trending_services',
//                                       serviceList: serviceController.trendingServiceList ?? [],
//                                     ),
//                                     const FeatheredCategoryView(),
//                                     (serviceController.allService != null && serviceController.allService!.isNotEmpty)
//                                         ? (ResponsiveHelper.isMobile(context) || ResponsiveHelper.isTab(context))
//                                         ? Padding(
//                                       padding: const EdgeInsets.fromLTRB(
//                                         Dimensions.paddingSizeDefault,
//                                         15,
//                                         Dimensions.paddingSizeDefault,
//                                         Dimensions.paddingSizeSmall,
//                                       ),
//                                       child: TitleWidget(
//                                         textDecoration: TextDecoration.underline,
//                                         title: 'all_service'.tr,
//                                         onTap: () => Get.toNamed(RouteHelper.getSearchResultRoute()),
//                                       ),
//                                     )
//                                         : const SizedBox.shrink()
//                                         : const SizedBox.shrink(),
//                                     PaginatedListView(
//                                       scrollController: scrollController,
//                                       totalSize: serviceController.serviceContent?.total ?? 0,
//                                       offset: serviceController.serviceContent?.currentPage ?? 1,
//                                       onPaginate: (int offset) async => await serviceController.getAllServiceList(offset, false),
//                                       showBottomSheet: true,
//                                       itemView: ServiceViewVertical(
//                                         service: serviceController.serviceContent != null ? serviceController.allService : null,
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: ResponsiveHelper.isDesktop(context)
//                                               ? Dimensions.paddingSizeExtraSmall
//                                               : Dimensions.paddingSizeDefault,
//                                           vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
//                                         ),
//                                         type: 'others',
//                                         noDataType: NoDataType.home,
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                                     : SizedBox(
//                                   height: MediaQuery.of(context).size.height * 0.6,
//                                   child: const ServiceNotAvailableScreen(),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 });
//               });
//             }),
//           ),
//         ),
//       );
//     });
//   }
// }
//
// class RatingPopupDialog extends StatelessWidget {
//   final BookingModel bookingModel;
//
//   const RatingPopupDialog({Key? key, required this.bookingModel}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.9,
//         constraints: BoxConstraints(
//           maxWidth: 500,
//           maxHeight: MediaQuery.of(context).size.height * 0.8,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'rate_your_experience'.tr,
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: SizedBox(
//                   height: 220,
//                   child: MyReviewScreen(bookingModel: bookingModel),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(
//                     onPressed: () async {
//                       final prefs = await SharedPreferences.getInstance();
//                       final currentDate = DateTime.now().toIso8601String().split('T')[0];
//                       await prefs.setString('rating_popup_skip_date', currentDate);
//                       debugPrint('Rating popup skipped on $currentDate');
//                       Navigator.of(context).pop();
//                     },
//                     child: Text(
//                       'skip'.tr,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Theme.of(context).hintColor,
//                       ),
//                     ),
//                   ),
//
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }