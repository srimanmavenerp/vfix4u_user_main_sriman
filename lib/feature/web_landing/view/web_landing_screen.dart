// import 'dart:async';
// import 'package:Vfix4u/common/widgets/custom_image.dart';
// import 'package:Vfix4u/common/widgets/custom_shaking_widget.dart';
// import 'package:Vfix4u/common/widgets/footer_base_view.dart';
// import 'package:Vfix4u/feature/language/controller/localization_controller.dart';
// import 'package:Vfix4u/common/models/config_model.dart';
// import 'package:Vfix4u/feature/splash/controller/splash_controller.dart';
// import 'package:Vfix4u/feature/web_landing/controller/web_landing_controller.dart';
// import 'package:Vfix4u/feature/web_landing/widget/live_chat_button.dart';
// import 'package:Vfix4u/feature/web_landing/widget/web_landing_search_box.dart';
// import 'package:Vfix4u/feature/web_landing/widget/web_landing_shimmer.dart';
// import 'package:Vfix4u/feature/web_landing/widget/web_mid_section.dart';
// import 'package:Vfix4u/utils/dimensions.dart';
// import 'package:Vfix4u/utils/images.dart';
// import 'package:Vfix4u/utils/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import '../widget/testimonial_widget.dart';

// class WebLandingPage extends StatefulWidget {
//   final bool? fromSignUp;
//   final String? route;
//   final GlobalKey<CustomShakingWidgetState>? shakeKey;

//   const WebLandingPage(
//       {super.key,
//       required this.fromSignUp,
//       required this.route,
//       this.shakeKey});

//   @override
//   State<WebLandingPage> createState() => _WebLandingPageState();
// }

// class _WebLandingPageState extends State<WebLandingPage> {
//   final ConfigModel _config = Get.find<SplashController>().configModel;
//   Timer? _timer;
//   @override
//   void initState() {
//     super.initState();
//     Get.find<WebLandingController>().getWebLandingContent(reload: true);
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<WebLandingController>(
//       builder: (webLandingController) {
//         if (webLandingController.webLandingContent != null) {
//           var textContent = {
//             for (var e in webLandingController.webLandingContent!.textContent!)
//               e.keyName: e.liveValues
//           };

//           return FooterBaseView(
//             bottomPadding: false,
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: Dimensions.paddingSizeLarge),
//                   WebLandingSearchSection(
//                     textContent: textContent,
//                     fromSignUp: widget.fromSignUp,
//                     route: widget.route,
//                     shakeKey: widget.shakeKey,
//                   ),
//                   const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
//                   WebMidSection(
//                     textContent: textContent,
//                     featureImage: webLandingController
//                         .webLandingContent?.featureSectionImage,
//                   ),
//                   const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
//                   TestimonialWidget(
//                     webLandingController: webLandingController,
//                     textContent: textContent,
//                   ),
//                   const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width > 800
//                         ? 570
//                         : MediaQuery.of(context).size.width > 500
//                             ? 500
//                             : 600, // adjust height for smaller screens
//                     child: Center(
//                       child: ConstrainedBox(
//                         constraints:
//                             BoxConstraints(maxWidth: Dimensions.webMaxWidth),
//                         child: LayoutBuilder(
//                           builder: (context, constraints) {
//                             final isSmallWidth = constraints.maxWidth < 800;

//                             return isSmallWidth
//                                 ? Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       // Image
//                                       CustomImage(
//                                         height: 200,
//                                         width: 200,
//                                         image: webLandingController
//                                                 .webLandingContent
//                                                 ?.downloadSectionImage ??
//                                             "",
//                                         fit: BoxFit.fitHeight,
//                                       ),
//                                       const SizedBox(
//                                           height: Dimensions.paddingSizeLarge),
//                                       // Download section
//                                       if (_config.content!.appUrlAndroid !=
//                                               null ||
//                                           _config.content!.appUrlIos != null)
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Container(
//                                                     width: 50,
//                                                     height: 2,
//                                                     color: Get.isDarkMode
//                                                         ? Colors.white
//                                                         : Colors.black),
//                                                 const SizedBox(width: 8),
//                                                 Text(
//                                                   textContent[
//                                                           'download_section_title'] ??
//                                                       "",
//                                                   style: robotoBold.copyWith(
//                                                       fontSize: Dimensions
//                                                           .fontSizeExtraLarge),
//                                                 ),
//                                               ],
//                                             ),
//                                             const SizedBox(
//                                                 height: Dimensions
//                                                     .paddingSizeSmall),
//                                             SizedBox(
//                                               width: 300,
//                                               child: Text(
//                                                 textContent[
//                                                         'download_section_description'] ??
//                                                     "",
//                                                 style: robotoRegular.copyWith(
//                                                   color: Theme.of(context)
//                                                       .textTheme
//                                                       .bodyLarge
//                                                       ?.color,
//                                                   fontSize: Dimensions
//                                                       .fontSizeDefault,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ),
//                                             const SizedBox(
//                                                 height: Dimensions
//                                                     .paddingSizeLarge),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 if (_config.content!
//                                                         .appUrlAndroid !=
//                                                     null)
//                                                   InkWell(
//                                                     onTap: () async {
//                                                       if (await canLaunchUrlString(
//                                                           _config.content!
//                                                               .appUrlAndroid!)) {
//                                                         launchUrlString(_config
//                                                             .content!
//                                                             .appUrlAndroid!);
//                                                       }
//                                                     },
//                                                     child: Image.asset(
//                                                         Images.playStoreIcon,
//                                                         height: 45),
//                                                   ),
//                                                 if (_config.content!
//                                                             .appUrlAndroid !=
//                                                         null &&
//                                                     _config.content!
//                                                             .appUrlIos !=
//                                                         null)
//                                                   const SizedBox(
//                                                       width: Dimensions
//                                                           .paddingSizeDefault),
//                                                 if (_config
//                                                         .content!.appUrlIos !=
//                                                     null)
//                                                   InkWell(
//                                                     onTap: () async {
//                                                       if (await canLaunchUrlString(
//                                                           _config.content!
//                                                               .appUrlIos!)) {
//                                                         launchUrlString(_config
//                                                             .content!
//                                                             .appUrlIos!);
//                                                       }
//                                                     },
//                                                     child: Image.asset(
//                                                         Images.appStoreIcon,
//                                                         height: 45),
//                                                   ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                     ],
//                                   )
//                                 : Row(
//                                     mainAxisAlignment: _config
//                                                     .content!.appUrlAndroid ==
//                                                 null &&
//                                             _config.content!.appUrlIos == null
//                                         ? MainAxisAlignment.center
//                                         : MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       // Image
//                                       CustomImage(
//                                         height: Dimensions
//                                             .webLandingDownloadImageHeight,
//                                         width: Dimensions
//                                             .webLandingDownloadImageHeight,
//                                         image: webLandingController
//                                                 .webLandingContent
//                                                 ?.downloadSectionImage ??
//                                             "",
//                                         fit: BoxFit.fitHeight,
//                                       ),
//                                       // Download section
//                                       if (_config.content!.appUrlAndroid !=
//                                               null ||
//                                           _config.content!.appUrlIos != null)
//                                         Flexible(
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Container(
//                                                       width: 50,
//                                                       height: 2,
//                                                       color: Get.isDarkMode
//                                                           ? Colors.white
//                                                           : Colors.black),
//                                                   const SizedBox(width: 8),
//                                                   Text(
//                                                     textContent[
//                                                             'download_section_title'] ??
//                                                         "",
//                                                     style: robotoBold.copyWith(
//                                                         fontSize: Dimensions
//                                                             .fontSizeExtraLarge),
//                                                   ),
//                                                 ],
//                                               ),
//                                               const SizedBox(
//                                                   height: Dimensions
//                                                       .paddingSizeSmall),
//                                               Text(
//                                                 textContent[
//                                                         'download_section_description'] ??
//                                                     "",
//                                                 style: robotoRegular.copyWith(
//                                                   color: Theme.of(context)
//                                                       .textTheme
//                                                       .bodyLarge
//                                                       ?.color,
//                                                   fontSize: Dimensions
//                                                       .fontSizeDefault,
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                   height: Dimensions
//                                                       .paddingSizeLarge),
//                                               Row(
//                                                 children: [
//                                                   if (_config.content!
//                                                           .appUrlAndroid !=
//                                                       null)
//                                                     InkWell(
//                                                       onTap: () async {
//                                                         if (await canLaunchUrlString(
//                                                             _config.content!
//                                                                 .appUrlAndroid!)) {
//                                                           launchUrlString(_config
//                                                               .content!
//                                                               .appUrlAndroid!);
//                                                         }
//                                                       },
//                                                       child: Image.asset(
//                                                           Images.playStoreIcon,
//                                                           height: 45),
//                                                     ),
//                                                   if (_config.content!
//                                                               .appUrlAndroid !=
//                                                           null &&
//                                                       _config.content!
//                                                               .appUrlIos !=
//                                                           null)
//                                                     const SizedBox(
//                                                         width: Dimensions
//                                                             .paddingSizeDefault),
//                                                   if (_config
//                                                           .content!.appUrlIos !=
//                                                       null)
//                                                     InkWell(
//                                                       onTap: () async {
//                                                         if (await canLaunchUrlString(
//                                                             _config.content!
//                                                                 .appUrlIos!)) {
//                                                           launchUrlString(
//                                                               _config.content!
//                                                                   .appUrlIos!);
//                                                         }
//                                                       },
//                                                       child: Image.asset(
//                                                           Images.appStoreIcon,
//                                                           height: 45),
//                                                     ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                     ],
//                                   );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: Dimensions.webMaxWidth,
//                     height: Dimensions.webLandingContactUsHeight,
//                     color: Get.isDarkMode
//                         ? Colors.grey.withValues(alpha: 0.1)
//                         : Theme.of(context).primaryColorLight,
//                     margin: const EdgeInsets.only(
//                         bottom: Dimensions.paddingSizeTextFieldGap),
//                     padding: const EdgeInsets.symmetric(horizontal: 70),
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Align(
//                           alignment: Alignment.center,
//                           child: SizedBox(
//                             child: Align(
//                               alignment:
//                                   Get.find<LocalizationController>().isLtr
//                                       ? Alignment.centerLeft
//                                       : Alignment.centerRight,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   if (textContent['web_bottom_title'] != null &&
//                                       textContent['web_bottom_title'] != '')
//                                     Text(
//                                       textContent['web_bottom_title']!,
//                                       style: robotoBold.copyWith(fontSize: 16),
//                                     ),
//                                   const SizedBox(
//                                     height: Dimensions.paddingSizeDefault,
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       LiveChatButton(
//                                         title: 'chat'.tr,
//                                         iconData: Icons.message,
//                                         isBorderActive: false,
//                                       ),
//                                       const SizedBox(
//                                           width: Dimensions.paddingSizeDefault),
//                                       LiveChatButton(
//                                         title: Get.find<SplashController>()
//                                             .configModel
//                                             .content!
//                                             .businessPhone!,
//                                         iconData: Icons.call,
//                                         isBorderActive: true,
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           right: Get.find<LocalizationController>().isLtr
//                               ? 0
//                               : null,
//                           left: Get.find<LocalizationController>().isLtr
//                               ? null
//                               : 0,
//                           top: -65.0,
//                           child: CustomImage(
//                             image: webLandingController
//                                     .webLandingContent?.supportSectionImage ??
//                                 "",
//                             fit: BoxFit.cover,
//                             width: Dimensions.supportLogoWidth,
//                             height: Dimensions.supportLogoHeight,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         } else {
//           return const WebLandingShimmer();
//         }
//       },
//     );
//   }
// }

// class CustomPath extends CustomClipper<Path> {
//   final bool? isRtl;
//   CustomPath({required this.isRtl});

//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     if (isRtl!) {
//       path
//         ..moveTo(0, size.height)
//         ..lineTo(size.width, size.height)
//         ..lineTo(size.width * 0.7, 0)
//         ..lineTo(0, 0)
//         ..close();
//     } else {
//       path
//         ..moveTo(0, size.height)
//         ..lineTo(size.width * 0.3, 0)
//         ..lineTo(size.width, 0)
//         ..lineTo(size.width, size.height)
//         ..close();
//     }
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }import 'package:flutter/material.dart';
import 'package:Vfix4u/common/widgets/custom_app_bar.dart';
import 'package:Vfix4u/helper/route_helper.dart';
import 'package:Vfix4u/utils/core_export.dart';
import 'package:flutter/foundation.dart';
// import 'dart:html' as html; // Only for Web
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebLandingPage extends StatelessWidget {
  const WebLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, c) {
          final double w = c.maxWidth;
          final bool mobile = w < 600;
          final bool tablet = w >= 600 && w < 1024;

          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: mobile ? 16 : 40,
                      vertical: mobile ? 24 : 50,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xFFF36A14), // Strong color at bottom
                          Colors.white, // Transparent at top (alpha = 0x00)
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const HeroContent(),
                        const SizedBox(height: 40),
                        ServiceGrid(mobile: mobile, tablet: tablet),
                      ],
                    ),
                  ),

                  // Banner with mockup
                  const BannerWidget(
                    imageUrl: "",
                  ),

                  // Company logos
                  CompanyGrid(mobile: mobile, tablet: tablet),

                  // Informational Banner
                  const WebBanner(),

                  // Footer with contact and social icons
                  const VFix4UHomePage(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class HeroContent extends StatelessWidget {
  const HeroContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 853,
      height: 255,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800, // Extra Bold
              fontSize: 70,
              height: 1.0, // line-height 100%
              letterSpacing: 0,
            ),
            children: [
              TextSpan(
                text: 'Your ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: 'Trusted',
                style: TextStyle(color: Color(0xFFF36A14)),
              ),
              TextSpan(
                text: ' Partner for\n',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: 'Computer Services\n',
                style: TextStyle(color: Color(0xFFF36A14)),
              ),
              TextSpan(
                text: 'VFix4U',
                style: TextStyle(color: Color(0xFFF36A14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BannerWidget extends StatelessWidget {
  final String imageUrl;

  const BannerWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final bool mobile = width < 600;
    final bool tablet = width >= 600 && width < 1024;

    double spacing = mobile ? 16 : 50;
    double mobileImgWidth = mobile
        ? 160
        : tablet
            ? 250
            : 320;

    Future<void> openAppStore({required String platform}) async {
      String url = '';
      // only web
      // if (kIsWeb) {
      //   url = platform.toLowerCase() == 'android'
      //       ? 'https://play.google.com/store/apps/details?id=com.vfix4u.com.vfix4u&pcampaignid=web_share'
      //       : 'https://apps.apple.com/in/app/vfix4u-user/id6747245503';
      //   html.window.open(url, '_blank');
      //   return;
      // }
      if (platform.toLowerCase() == 'android') {
        url =
            'https://play.google.com/store/apps/details?id=com.vfix4u.com.vfix4u&pcampaignid=web_share';
      } else if (platform.toLowerCase() == 'ios') {
        url = 'https://apps.apple.com/in/app/vfix4u-user/id6747245503';
      }
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mobile ? 16 : 40, vertical: mobile ? 24 : 50),
      child: Flex(
        direction: mobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'VFix4U\nFast, Trusted\nIT Services \nBooking',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: mobile
                        ? 22
                        : tablet
                            ? 28
                            : 50,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    storeButton(
                        image: "assets/images/play_store.png",
                        onTap: () => openAppStore(platform: 'android')),
                    const SizedBox(width: 10),
                    storeButton(
                        image: "assets/images/app_store.png",
                        onTap: () => openAppStore(platform: 'ios')),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: mobile ? 24 : 0, width: mobile ? 0 : 40),
          Expanded(
            flex: 1,
            child: Center(
              child: Image.asset(
                "assets/landingservices/mobile.png",
                width: mobileImgWidth,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function outside build
  Widget storeButton({required String image, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(
        image,
        width: 190,
        height: 130,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
      ),
    );
  }
}

class ServiceGrid extends StatelessWidget {
  final bool mobile;
  final bool tablet;

  const ServiceGrid({
    super.key,
    required this.mobile,
    required this.tablet,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      "assets/landingservices/laptop.jpg",
      "assets/landingservices/desktop.jpg",
      "assets/landingservices/cctv.jpg",
      "assets/landingservices/projector.jpg",
      "assets/landingservices/printer.jpg",
      "assets/landingservices/router.jpg",
      "assets/landingservices/ups.jpg",
      "assets/landingservices/ac.jpg",
    ];

    final List<String> names = [
      "Laptop",
      "Desktop",
      "CCTV",
      "Projector",
      "Printer",
      "Router",
      "UPS Service",
      "AC Service",
    ];

    final List<Map<String, String>> categories = [
      {"id": "6d559ada-b844-4733-bfa9-9bf02e80ebe9"}, // Laptop
      {"id": "9aed7f4c-10b2-4218-a30b-32708cf1eeb7"}, // Desktop
      {"id": "b7b6c2dd-0984-46a1-bbba-b67791df5ac1"}, // CCTV
      {"id": "5ce5dd8c-ca7c-4e46-a7d9-91350dd54d60"}, // Projector
      {"id": "d3c01f71-1785-448f-a915-70d766000952"}, // Printer
      {"id": "b2460078-75c9-4b4a-961d-d5be9430ff4f"}, // Router
      {"id": "c09d12a6-6ffc-4e35-9f60-76ae9a52d3e9"}, // UPS Service
      {"id": "d9e57ac5-2b02-444a-91a6-7b9a84357888"}, // AC Service
    ];

    /// ---- Service Card ----
    Widget serviceCard(String imagePath, String name, int index) {
      return MouseRegion(
        cursor: SystemMouseCursors.click, // POINTER CURSOR 👈
        child: GestureDetector(
          onTap: () {
            Get.toNamed(
              RouteHelper.getCategoryProductRoute(
                categories[index]["id"]!,
                name,
                index.toString(),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                width: mobile
                    ? 140
                    : tablet
                        ? 180
                        : 220,
                height: mobile
                    ? 140
                    : tablet
                        ? 180
                        : 220,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(33),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(33),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.broken_image),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  fontSize: mobile
                      ? 14
                      : tablet
                          ? 16
                          : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final row1Items = items.sublist(0, 3);
    final row2Items = items.sublist(3);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          /// ---- FIRST ROW ----
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              row1Items.length,
              (index) => serviceCard(row1Items[index], names[index], index),
            ),
          ),
          const SizedBox(height: 16),

          /// ---- SECOND ROW ----
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              row2Items.length,
              (index) => serviceCard(
                row2Items[index],
                names[index + 3],
                index + 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompanyGrid extends StatelessWidget {
  final bool mobile;
  final bool tablet;

  const CompanyGrid({
    super.key,
    required this.mobile,
    required this.tablet,
  });

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = mobile ? 2 : (tablet ? 3 : 5);

    final List<String> companyLogos = [
      "assets/landingservices/s7.png",
      "assets/landingservices/s5.png",
      "assets/landingservices/s10.jpg",
      "assets/landingservices/s8.png",
      "assets/landingservices/s2.png",
      "assets/landingservices/s1.png",
      "assets/landingservices/s4.png",
      "assets/landingservices/s6.png",
      "assets/landingservices/s3.png",
      "assets/landingservices/s9.png",
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 211 / 143, // Fixed aspect ratio as per design

        children: List.generate(companyLogos.length, (index) {
          final logoPath = companyLogos[index];

          return Container(
            width: 211,
            height: 143,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Image.asset(
                logoPath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image,
                    size: 40, color: Colors.grey),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// INFO BANNER
class WebBanner extends StatelessWidget {
  const WebBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final bool mobile = MediaQuery.of(context).size.width < 600;
    final double menuFontSize = mobile ? 14 : 25;
    final double screenWidth = MediaQuery.of(context).size.width;

    final menuItems = ["Home", "About Us", "Services", "Contact"];
    final Map<String, String> menuLinks = {
      "Home": RouteHelper.getMainRoute('home',
          previousAddress: null, showServiceNotAvailableDialog: 'null'),
      "About Us": RouteHelper.getHtmlRoute('about_us'),
      "Services": RouteHelper.allServiceScreenRoute('all_service'),
      "Contact": RouteHelper.getSupportRoute(),
    };
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color.fromARGB(0, 241, 168, 129)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // -------------------------oo
          // Main Heading
          // -------------------------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Your Computer Help, Just a\nTap Away – VFix4U.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth < 600
                    ? 20
                    : screenWidth < 1200
                        ? 28
                        : 45,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // -------------------------
          // Subtitle Text
          // -------------------------
          Text(
            "\"Your devices, our priority.\nInstant repair booking with VFIX4U expert support\"",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 50),

          // -------------------------
          // CTA Button
          // -------------------------
          ElevatedButton(
            onPressed: () {
              Get.toNamed(menuLinks["Home"]!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 230, 112, 39),
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              "Book now",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Column(
            children: [
              // Full-width image
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  "assets/landingservices/car2.png",
                  fit: BoxFit.fitWidth,
                ),
              ),

              // Orange → White Gradient Section
              Container(
                margin: EdgeInsets.all(0), // neg
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 231, 118, 48),
                      Color.fromARGB(0, 241, 168, 129),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100), // Optional spacing
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Experience seamless Services with the VFix4U Mobile App. Easily book trusted\n IT service professionals, track your appointments, receive timely reminders,\n and make secure payments for both hardware and software repairs.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Space before logo
                    Center(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double imageWidth = constraints.maxWidth * 0.40;
                          imageWidth = imageWidth.clamp(100, 400);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Image.asset(
                              "assets/landingservices/nvfix4ulogo.png",
                              width: imageWidth,
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20), // Space before menu items
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        children: menuItems
                            .map(
                              (item) => InkWell(
                                onTap: () {
                                  final link = menuLinks[item];
                                  if (link != null) {
                                    Get.toNamed(link);
                                  }
                                },
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: menuFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class VFix4UHomePage extends StatelessWidget {
  const VFix4UHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    final double horizontalPadding = isMobile ? 16 : 40;
    final double verticalPadding = isMobile ? 24 : 30;
    final double iconSize = isMobile ? 24 : 30;
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Phone
                GestureDetector(
                  onTap: _launchPhone,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/landingservices/call.png",
                          height: iconSize, width: iconSize),
                      const SizedBox(height: 6),
                      Text(
                        'VFix4U\n+91 84999 55909',
                        style: TextStyle(
                            fontSize: isMobile ? 14 : 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 100),

                // Location
                Expanded(
                  child: GestureDetector(
                    onTap: _launchMap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/landingservices/map.png",
                            height: iconSize, width: iconSize),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            'VFix4U\n4th Floor, Church Colony Rd, beside Heritage Food Limited, \nbeside Sai Baba Temple Industrial Park, Laxmi Narayan \nNagar Colony, Uppal, Hyderabad, Telangana 500039',
                            style: TextStyle(
                                fontSize: isMobile ? 12 : 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 100),

                // Email
                GestureDetector(
                  onTap: _launchEmail,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/landingservices/msg.png",
                          height: iconSize, width: iconSize),
                      const SizedBox(height: 6),
                      Text('contact@vfix4u.com',
                          style: TextStyle(
                              fontSize: isMobile ? 14 : 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Social Media Icons
          Center(
            child: Wrap(
              spacing: 16,
              children: [
                GestureDetector(
                  onTap: () => openLink(
                      "https://www.linkedin.com/company/vfix4u/posts/?feedView=all"),
                  child: ImageIcon(
                    AssetImage("assets/landingservices/linkedin.png"),
                    size: 24,
                  ),
                ),
                GestureDetector(
                  onTap: () => openLink("https://www.instagram.com/vfix.4u/"),
                  child: ImageIcon(
                    AssetImage("assets/landingservices/insta.png"),
                    size: 24,
                  ),
                ),
                GestureDetector(
                  onTap: () => openLink(
                      "https://www.facebook.com/profile.php?id=61560558600643"),
                  child: ImageIcon(
                    AssetImage("assets/landingservices/facebook.png"),
                    size: 24,
                  ),
                ),
                GestureDetector(
                  onTap: () => openLink("https://x.com/vfix4uapp"),
                  child: ImageIcon(
                    AssetImage("assets/landingservices/x.png"),
                    size: 24,
                  ),
                ),
                GestureDetector(
                  onTap: () => openLink("https://wa.me/918499955909"),
                  child: ImageIcon(
                    AssetImage("assets/landingservices/whatsapp.png"),
                    size: 24,
                  ),
                ),
                GestureDetector(
                  onTap: () => openLink("https://www.youtube.com/@VFix4u"),
                  child: ImageIcon(
                    AssetImage("assets/landingservices/youtube.png"),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Footer Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "VFix4U",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: isMobile ? 12 : 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'All rights reserved By ©MAKS VFIX4U IT SOLUTIONS LLP 2025',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: isMobile ? 12 : 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "VFix4U",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: isMobile ? 12 : 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void openLink(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

void _launchPhone() async {
  final Uri uri = Uri.parse('tel:+918499955909');
  if (!await launchUrl(uri)) throw 'Could not launch $uri';
}

void _launchEmail() async {
  final Uri uri = Uri.parse('mailto:contact@vfix4u.com');
  if (!await launchUrl(uri)) throw 'Could not launch $uri';
}

void _launchMap() async {
  final Uri uri = Uri.parse('https://maps.app.goo.gl/TUjNSi2ksUrbX5Jk9');
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $uri';
  }
}
