import 'dart:convert';

import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String? serviceID;
  final String? fromPage;
  const ServiceDetailsScreen(
      {super.key, this.serviceID, this.fromPage = "others"});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (widget.serviceID != null) {
      Get.find<ServiceDetailsController>().getServiceDetails(widget.serviceID!,
          fromPage: widget.fromPage == "search_page" ? "search_page" : "");
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<ServiceController>().getRecentlyViewedServiceList(
          1,
          true,
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      endDrawer:
          ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
      appBar: CustomAppBar(
        centerTitle: false,
        title: 'service_details'.tr,
        showCart: true,
      ),
      body: GetBuilder<ServiceDetailsController>(
        builder: (serviceController) {
          if (serviceController.service != null || widget.serviceID == null) {
            if (serviceController.service != null &&
                serviceController.service!.id != null &&
                widget.serviceID != null) {
              Service? service = serviceController.service;
              Discount discount = PriceConverter.discountCalculation(service!);
              double lowestPrice = 0.0;
              if (service.variationsAppFormat!.zoneWiseVariations != null) {
                lowestPrice = service
                    .variationsAppFormat!.zoneWiseVariations![0].price!
                    .toDouble();
                for (var i = 0;
                    i < service.variationsAppFormat!.zoneWiseVariations!.length;
                    i++) {
                  if (service
                          .variationsAppFormat!.zoneWiseVariations![i].price! <
                      lowestPrice) {
                    lowestPrice = service
                        .variationsAppFormat!.zoneWiseVariations![i].price!
                        .toDouble();
                  }
                }
              }
              return FooterBaseView(
                isScrollView: ResponsiveHelper.isMobile(context) ? false : true,
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: DefaultTabController(
                    length: Get.find<ServiceDetailsController>()
                            .service!
                            .faqs!
                            .isNotEmpty
                        ? 3
                        : 2,
                    child: Column(
                      children: [
                        if (!ResponsiveHelper.isMobile(context) &&
                            !ResponsiveHelper.isTab(context))
                          const SizedBox(
                            height: Dimensions.paddingSizeDefault,
                          ),
                        Stack(
                          children: [
                            Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      (!ResponsiveHelper.isMobile(context) &&
                                              !ResponsiveHelper.isTab(context))
                                          ? const Radius.circular(8)
                                          : const Radius.circular(0.0)),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: SizedBox(
                                          width: Dimensions.webMaxWidth,
                                          height: ResponsiveHelper.isDesktop(
                                                  context)
                                              ? 280
                                              : 150,
                                          child: CustomImage(
                                              image:
                                                  service.coverImageFullPath ??
                                                      ""),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          width: Dimensions.webMaxWidth,
                                          height: ResponsiveHelper.isDesktop(
                                                  context)
                                              ? 280
                                              : 150,
                                          decoration: BoxDecoration(
                                              color: Colors.black
                                                  .withValues(alpha: 0.6)),
                                        ),
                                      ),
                                      Container(
                                        width: Dimensions.webMaxWidth,
                                        height:
                                            ResponsiveHelper.isDesktop(context)
                                                ? 280
                                                : 150,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeLarge),
                                        child: Center(
                                            child: Text(service.name ?? '',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraLarge,
                                                    color: Colors.white))),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 120,
                                )
                              ],
                            ),
                            Positioned(
                              bottom: -2,
                              left: Dimensions.paddingSizeSmall,
                              right: Dimensions.paddingSizeSmall,
                              child: ServiceInformationCard(
                                discount: discount,
                                service: service,
                                lowestPrice: lowestPrice,
                              ),
                            ),
                          ],
                        ),
                        //Tab Bar
                        rateCardButton(context, widget.serviceID),
                        GetBuilder<ServiceTabController>(
                          init: Get.find<ServiceTabController>(),
                          builder: (serviceTabController) {
                            return Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Center(
                                child: Container(
                                  width: ResponsiveHelper.isMobile(context)
                                      ? null
                                      : Get.width / 3,
                                  color: Get.isDarkMode
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                      : Theme.of(context).cardColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.paddingSizeDefault),
                                  child: DecoratedTabBar(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: .3),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    tabBar: TabBar(
                                        padding: const EdgeInsets.only(
                                            top: Dimensions.paddingSizeMini),
                                        unselectedLabelColor: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!
                                            .withValues(alpha: 0.4),
                                        controller:
                                            serviceTabController.controller!,
                                        labelColor: Get.isDarkMode
                                            ? Colors.white
                                            : Theme.of(context).primaryColor,
                                        labelStyle: robotoBold.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                        ),
                                        indicatorColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        indicatorPadding: const EdgeInsets.only(
                                            top: Dimensions.paddingSizeSmall),
                                        labelPadding: const EdgeInsets.only(
                                            bottom: Dimensions
                                                .paddingSizeExtraSmall),
                                        indicatorWeight: 2,
                                        onTap: (int? index) {
                                          switch (index) {
                                            case 0:
                                              serviceTabController
                                                  .updateServicePageCurrentState(
                                                      ServiceTabControllerState
                                                          .serviceOverview);
                                              break;
                                            case 1:
                                              serviceTabController
                                                          .serviceDetailsTabs()
                                                          .length >
                                                      2
                                                  ? serviceTabController
                                                      .updateServicePageCurrentState(
                                                          ServiceTabControllerState
                                                              .faq)
                                                  : serviceTabController
                                                      .updateServicePageCurrentState(
                                                          ServiceTabControllerState
                                                              .review);
                                              break;
                                            case 2:
                                              serviceTabController
                                                  .updateServicePageCurrentState(
                                                      ServiceTabControllerState
                                                          .review);
                                              break;
                                          }
                                        },
                                        tabs: serviceTabController
                                            .serviceDetailsTabs()),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        //Tab Bar View
                        GetBuilder<ServiceTabController>(
                          initState: (state) {
                            Get.find<ServiceTabController>().getServiceReview(
                                serviceController.service!.id!, 1);
                          },
                          builder: (controller) {
                            Widget tabBarView = TabBarView(
                              controller: controller.controller,
                              children: [
                                SingleChildScrollView(
                                    child: ServiceOverview(
                                        description: service.description!)),
                                if (Get.find<ServiceDetailsController>()
                                    .service!
                                    .faqs!
                                    .isNotEmpty)
                                  const SingleChildScrollView(
                                      child: ServiceDetailsFaqSection()),
                                if (controller.reviewList != null)
                                  SingleChildScrollView(
                                    child: ServiceDetailsReview(
                                      serviceID: serviceController.service!.id!,
                                    ),
                                  )
                                else
                                  const EmptyReviewWidget()
                              ],
                            );

                            if (ResponsiveHelper.isMobile(context)) {
                              return Expanded(
                                child: tabBarView,
                              );
                            } else {
                              return SizedBox(
                                height: 500,
                                child: tabBarView,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return NoDataScreen(
                text: 'no_service_available'.tr,
                type: NoDataType.service,
              );
            }
          } else {
            return const ServiceDetailsShimmerWidget();
          }
        },
      ),
    );
  }
}

Widget rateCardButton(BuildContext context, serviceid) {
  return GestureDetector(
    onTap: () {
      // Navigate to Rate Card Screen
      Get.to(RateCardApp(serviceid));
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          // Left Icon
          Image.asset(
            "assets/landingservices/nvfix4ulogo.png",
            height: 50,
            width: 50,
            color: Colors.deepOrange,
          ),

          const SizedBox(width: 10),

          // Title
          const Expanded(
            child: Text(
              "Standard rate card",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Arrow Icon
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.grey,
          )
        ],
      ),
    ),
  );
}

class RateCardApp extends StatelessWidget {
  final String serviceid;
  RateCardApp(this.serviceid);
  @override
  Widget build(BuildContext context) {
    return RateCardPage(
      serviceId: serviceid,
    );
  }
}

class RateCardController extends GetxController {
  var sections = <_RateSection>[].obs;
  var loading = true.obs;
  final String serviceId;

  RateCardController(this.serviceId);

  @override
  void onInit() {
    super.onInit();
    fetchRateCard();
  }

  Future<void> fetchRateCard() async {
    try {
      loading.value = true;

      // SharedPreferences & API Client
      final prefs = await SharedPreferences.getInstance();
      final apiClient = ApiClient(
        appBaseUrl: AppConstants.baseUrl,
        sharedPreferences: prefs,
      );

      // 1️⃣ Get category ID for the service
      final String cateUrl = '/api/v1/customer/service-category/$serviceId';
      final respom = await apiClient.getData(cateUrl);

      String? categoryId;
      if (respom != null && respom.body['status'] == true) {
        categoryId = respom.body['category_id'] as String?;
        print('✅ Category ID: $categoryId');
      } else {
        print('❌ Failed to get category_id');
        return;
      }

      // 2️⃣ Fetch rate card using the categoryId
      final String rateCardUrl =
          '/api/v1/serviceman/category/$categoryId/rate-card';
      final response = await apiClient.getData(rateCardUrl);

      if (response.statusCode == 200) {
        final json = response.body;

        final respCategoryId = json['category_id'] as String? ?? "";
        final apiItems = json['items'] as List<dynamic>? ?? [];

        // Map items only if categoryId matches
        List<_RateItem> convertedItems = [];
        print(json);
        if ((respCategoryId).toLowerCase() ==
            (categoryId ?? "").toLowerCase()) {
          convertedItems = apiItems.map((item) {
            return _RateItem(
              item['item_name'] ?? "",
              "₹${item['item_price'] ?? 0}",
              item['hsn_code'] ?? "",
            );
          }).toList();
          print('✅ Mapped items: $convertedItems');
        }

        // Update sections
        sections.value = [
          _RateSection(title: "Rate Card", items: convertedItems)
        ];
      } else {
        print("❌ Error fetching rate card: ${response.statusText}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    } finally {
      loading.value = false;
    }
  }
}

// -------------------- Models --------------------

class _RateSection {
  final String title;
  final List<_RateItem> items;

  _RateSection({required this.title, required this.items});
}

class _RateItem {
  final String desc;
  final String price;
  final String hsnCode;

  _RateItem(this.desc, this.price, this.hsnCode);

  @override
  String toString() {
    return '$_RateItem(desc: $desc, price: $price, hsnCode: $hsnCode)';
  }
}

class RateCardPage extends StatelessWidget {
  final String serviceId;
  RateCardPage({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final RateCardController controller =
        Get.put(RateCardController(serviceId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
        title: Text('VFix4U', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rate Card',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              for (var s in controller.sections)
                Column(
                  children: [
                    _SectionCard(section: s),
                    SizedBox(height: 18),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _SectionCard extends StatefulWidget {
  final _RateSection section;
  const _SectionCard({Key? key, required this.section}) : super(key: key);

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  // bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final hasItems = widget.section.items.isNotEmpty;

    return Material(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(widget.section.title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
              // trailing: Icon(
              //     hasItems
              //         ? (expanded
              //             ? Icons.keyboard_arrow_up
              //             : Icons.keyboard_arrow_down)
              //         : Icons.chevron_right,
              //     color: Colors.white),
              // onTap:
              //     hasItems ? () => setState(() => expanded = !expanded) : null,
            ),
            if (!hasItems)
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Center(
                  child: Text("No Rate Card Available For This Product"),
                ),
              ),
            if (hasItems)
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Column(
                  children: [
                    // Header
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300))),
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('Products',
                                style: TextStyle(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center),
                          )),
                          Container(
                              width: 1,
                              height: 24,
                              color: Colors.grey.shade200),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('HSN',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center),
                          )),
                          Container(
                              width: 1,
                              height: 24,
                              color: Colors.grey.shade200),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Service Charge',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )),
                        ],
                      ),
                    ),

                    // Items
                    for (var item in widget.section.items)
                      Column(
                        children: [
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(item.desc,
                                    textAlign: TextAlign.center),
                              )),
                              Container(
                                  width: 1,
                                  height: 24,
                                  color: Colors.grey.shade200),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(item.hsnCode,
                                    textAlign: TextAlign.center),
                              )),
                              Container(
                                  width: 1,
                                  height: 24,
                                  color: Colors.grey.shade200),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(item.price,
                                    textAlign: TextAlign.center),
                              )),
                            ],
                          ),
                          Divider(color: Colors.grey.shade200, height: 24),
                        ],
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
