import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subTitle;
  final bool? isBackButtonExist;
  final Function()? onBackPressed;
  final bool? showCart;
  final bool? centerTitle;
  final Color? bgColor;
  final Widget? actionWidget;
  final GlobalKey<CustomShakingWidgetState>? shakeKey;
  final bool isBackgroundTransparent;

  const CustomAppBar({
    super.key,
    required this.title,
    this.isBackButtonExist = true,
    this.onBackPressed,
    this.showCart = false,
    this.centerTitle = true,
    this.bgColor,
    this.actionWidget,
    this.subTitle,
    this.shakeKey,
    this.isBackgroundTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? WebMenuBar(searchbarShakeKey: shakeKey)
        : AppBar(
            backgroundColor: isBackgroundTransparent
                ? Colors.transparent
                : Get.isDarkMode
                    ? Theme.of(context).cardColor.withValues(alpha: .2)
                    : Theme.of(context).primaryColor,
            centerTitle: centerTitle,
            shape: Border(
                bottom: BorderSide(
                    width: .4,
                    color: Theme.of(context)
                        .primaryColorLight
                        .withValues(alpha: .2))),
            elevation: 0,
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).primaryColorLight),
                ),
                if (subTitle != null)
                  Text(
                    subTitle!,
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).primaryColorLight),
                  ),
              ],
            ),
            leading: isBackButtonExist!
                ? IconButton(
                    hoverColor: Colors.transparent,
                    icon: Icon(Icons.arrow_back_ios,
                        color: isBackgroundTransparent
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).primaryColorLight),
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    onPressed: () => onBackPressed != null
                        ? onBackPressed!()
                        : Navigator.of(context).canPop()
                            ? Navigator.pop(context)
                            : Get.offAllNamed(RouteHelper.getInitialRoute()),
                  )
                : const SizedBox(),
            actions: showCart!
                ? [
                    IconButton(
                      onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                      icon: CartWidget(
                          color: Get.isDarkMode
                              ? Theme.of(context).primaryColorLight
                              : Colors.white,
                          size: Dimensions.cartWidgetSize),
                    )
                  ]
                : actionWidget != null
                    ? [actionWidget!]
                    : null,
          );
  }

  @override
  Size get preferredSize => Size(
      Dimensions.webMaxWidth,
      ResponsiveHelper.isDesktop(Get.context)
          ? Dimensions.preferredSizeWhenDesktop
          : Dimensions.preferredSize);
}

///////////////////////////////web
// import 'dart:async';
// import 'dart:html' as html;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:demandium/utils/core_export.dart';

// class rxboolController extends GetxController {
//   RxBool isTrue = true.obs;
//   void showWebHeader(bool value) {
//     isTrue.value = value;
//   }
// }

// class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
//   final String? title;
//   final String? subTitle;
//   final bool? isBackButtonExist;
//   final Function()? onBackPressed;
//   final bool? showCart;
//   final bool? centerTitle;
//   final Color? bgColor;
//   final Widget? actionWidget;
//   final GlobalKey<CustomShakingWidgetState>? shakeKey;
//   final bool isBackgroundTransparent;

//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.isBackButtonExist = true,
//     this.onBackPressed,
//     this.showCart = false,
//     this.centerTitle = true,
//     this.bgColor,
//     this.actionWidget,
//     this.subTitle,
//     this.shakeKey,
//     this.isBackgroundTransparent = false,
//   });

//   @override
//   State<CustomAppBar> createState() => _CustomAppBarState();
//   @override
//   Size get preferredSize => Size.fromHeight(
//         ResponsiveHelper.isDesktop(Get.context) ? 100 : 80,
//       );
// }

// class _CustomAppBarState extends State<CustomAppBar> {
//   late final rxboolController toggleController;
//   late Timer _urlCheckTimer;
//   String _lastUrl = "";

//   @override
//   void initState() {
//     super.initState();
//     toggleController = Get.put(rxboolController());

//     // Initial check
//     _checkBaseUrl();

//     // Listen for browser back/forward
//     html.window.onPopState.listen((_) => _checkBaseUrl());

//     // Listen for hash changes
//     html.window.onHashChange.listen((_) => _checkBaseUrl());

//     // Polling for pushState / Flutter navigation
//     _lastUrl = html.window.location.href;
//     _urlCheckTimer =
//         Timer.periodic(const Duration(milliseconds: 200), (_) => _pollUrl());
//   }

//   void _pollUrl() {
//     final currentUrl = html.window.location.href;
//     if (currentUrl != _lastUrl) {
//       _lastUrl = currentUrl;
//       _checkBaseUrl();
//     }
//   }

//   void _checkBaseUrl() {
//     String normalizeUrl(String url) =>
//         url.endsWith('/') ? url.substring(0, url.length - 1) : url;

//     final fullUrl = normalizeUrl(html.window.location.href);
//     final uri = Uri.parse(fullUrl);
//     final baseUrl =
//         "${uri.scheme}://${uri.host}${uri.port != 0 ? ':${uri.port}' : ''}";
//     final baseUrlNormalized = normalizeUrl(baseUrl);

//     if (fullUrl == baseUrlNormalized) {
//       if (toggleController.isTrue.value != false) {
//         toggleController.showWebHeader(false);
//       }
//       print("✅ Base URL matched. Header hidden.");
//     } else {
//       if (!toggleController.isTrue.value) {
//         toggleController.showWebHeader(true);
//       }
//       print("❌ Base URL did not match. Header shown.");
//     }
//   }

//   @override
//   void dispose() {
//     _urlCheckTimer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isWebHeaderVisible = toggleController.isTrue.value;

//     // Desktop header
//     if (ResponsiveHelper.isDesktop(context)) {
//       return !isWebHeaderVisible
//           ? WebHeader(isMobile: MediaQuery.of(context).size.width < 800)
//           : WebMenuBar();
//     }

//     return AppBar(
//       backgroundColor: widget.isBackgroundTransparent
//           ? Colors.transparent
//           : Get.isDarkMode
//               ? Theme.of(context).cardColor.withValues(alpha: .2)
//               : Theme.of(context).primaryColor,
//       centerTitle: widget.centerTitle,
//       shape: Border(
//           bottom: BorderSide(
//               width: .4,
//               color:
//                   Theme.of(context).primaryColorLight.withValues(alpha: .2))),
//       elevation: 0,
//       titleSpacing: 0,
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.title!,
//             style: robotoMedium.copyWith(
//                 fontSize: Dimensions.fontSizeLarge,
//                 color: Theme.of(context).primaryColorLight),
//           ),
//           if (widget.subTitle != null)
//             Text(
//               widget.subTitle!,
//               style: robotoRegular.copyWith(
//                   fontSize: Dimensions.fontSizeSmall,
//                   color: Theme.of(context).primaryColorLight),
//             ),
//         ],
//       ),
//       leading: widget.isBackButtonExist!
//           ? IconButton(
//               hoverColor: Colors.transparent,
//               icon: Icon(Icons.arrow_back_ios,
//                   color: widget.isBackgroundTransparent
//                       ? Theme.of(context).colorScheme.primary
//                       : Theme.of(context).primaryColorLight),
//               color: Theme.of(context).textTheme.bodyLarge!.color,
//               onPressed: () => widget.onBackPressed != null
//                   ? widget.onBackPressed!()
//                   : Navigator.of(context).canPop()
//                       ? Navigator.pop(context)
//                       : Get.offAllNamed(RouteHelper.getInitialRoute()),
//             )
//           : const SizedBox(),
//       actions: widget.showCart!
//           ? [
//               IconButton(
//                 onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
//                 icon: CartWidget(
//                     color: Get.isDarkMode
//                         ? Theme.of(context).primaryColorLight
//                         : Colors.white,
//                     size: Dimensions.cartWidgetSize),
//               )
//             ]
//           : widget.actionWidget != null
//               ? [widget.actionWidget!]
//               : null,
//     );
//   }

//   @override
//   Size get preferredSize => Size(
//       Dimensions.webMaxWidth,
//       ResponsiveHelper.isDesktop(Get.context)
//           ? Dimensions.preferredSizeWhenDesktop
//           : Dimensions.preferredSize);
// }

// class WebHeader extends StatelessWidget {
//   final bool isMobile;
//   final WebHeaderController controller = Get.put(WebHeaderController());

//   WebHeader({super.key, required this.isMobile});

//   @override
//   Widget build(BuildContext context) {
//     final List<String> nav = [
//       RouteHelper.getInitialRoute(),
//       RouteHelper.getMainRoute('home',
//           previousAddress: null, showServiceNotAvailableDialog: 'null'),
//       RouteHelper.getHtmlRoute('about_us'),
//       RouteHelper.allServiceScreenRoute('all_service'),
//       RouteHelper.getSupportRoute(),
//       "provider",
//       RouteHelper.getSignInRoute(),
//     ];

//     return Container(
//       height: 100,
//       padding:
//           EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 16),
//       color: Colors.white,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Logo with pointer cursor
//           MouseRegion(
//             cursor: SystemMouseCursors.click,
//             child: InkWell(
//               onTap: () => Get.toNamed(nav[0]),
//               child: Image.asset(
//                 "assets/landingservices/vfix4ulogo.png",
//                 width: 180,
//                 height: 100,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           if (!isMobile)
//             Obx(
//               () => Row(
//                 children: [
//                   _navItem("Home", 1, nav),
//                   _navItem("About Us", 2, nav),
//                   _navItem("Services", 3, nav),
//                   _navItem("Contact", 4, nav),
//                   _navItem("Provider", 5, nav),
//                   _navButton("Login/Register", nav),
//                 ],
//               ),
//             )
//           else
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.menu),
//             ),
//         ],
//       ),
//     );
//   }

//   /// ==============================
//   /// NAV ITEM WITH POINTER CURSOR
//   /// ==============================
//   Widget _navItem(String title, int index, List<String> nav) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: () async {
//           AddressModel? userAddress =
//               await Get.find<LocationController>().getUserAddress();

//           if (userAddress == null) {
//             Get.toNamed(
//               RouteHelper.getPickMapRoute(
//                   RouteHelper.home, true, 'false', null, null),
//             );

//             return;
//           }

//           controller.setActive(index);

//           if (nav[index] == "provider") {
//             final uri = Uri.parse("https://vfix4u.com/provider/auth/sign-up");
//             await launchUrl(
//               uri,
//               mode: LaunchMode.externalApplication,
//               webOnlyWindowName: '_blank',
//             );
//           } else {
//             Get.toNamed(nav[index]);
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: controller.activeIndex.value == index
//                       ? FontWeight.bold
//                       : FontWeight.normal,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// ==============================
//   /// LOGIN/REGISTER BUTTON + POINTER
//   /// ==============================
//   Widget _navButton(String title, List<String> nav) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: ElevatedButton(
//           onPressed: () {
//             controller.setActive(6);
//             Get.toNamed(nav[6]);
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.deepOrange,
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: Text(
//             title,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class WebHeaderController extends GetxController {
//   var activeIndex = 0.obs;
//   void setActive(int index) {
//     activeIndex.value = index;
//   }
// }
