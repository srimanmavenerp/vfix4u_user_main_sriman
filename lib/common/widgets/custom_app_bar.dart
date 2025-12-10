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
// mobile
// --------------------------------------------------
//  SAFE WEB HELPERS (WORKS ON MOBILE & WEB)
// --------------------------------------------------

import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

// Web-only helpers
String getCurrentUrl() {
  if (kIsWeb) {
    return Uri.base.toString(); // Safe alternative to dart:html
  }
  return "";
}

void setupWebListeners(Function() onChange) {
  if (kIsWeb) {
    // Works on Flutter web WITHOUT dart:html
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Browser back/forward buttons
      htmlPopStateListener = (event) => onChange();

      // hashchange listener not available without dart:html
      // but Uri.base updates on navigation so polling solves this
    });
  }
}

dynamic htmlPopStateListener;

// --------------------------------------------------
//  YOUR CONTROLLER
// --------------------------------------------------
class RxBoolController extends GetxController {
  var showHeader = false.obs;

  void setHeader(bool value) => showHeader.value = !value;
}

class HeaderMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final toggleController = Get.find<RxBoolController>();
    toggleController.setHeader(route != RouteHelper.initial);
    return null;
  }
}

class HeaderRouteObserver extends GetObserver {
  final RxBoolController toggleController;

  HeaderRouteObserver(this.toggleController);

  @override
  void didPush(Route route, Route? previousRoute) {
    _updateHeader(route.settings.name);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _updateHeader(previousRoute?.settings.name);
    super.didPop(route, previousRoute);
  }

  void _updateHeader(String? routeName) {
    if (routeName == RouteHelper.initial) {
      toggleController.setHeader(false);
      print("Header hidden");
    } else {
      toggleController.setHeader(true);
      print("Header shown");
    }
  }
}

// --------------------------------------------------
//  MAIN APP BAR
// --------------------------------------------------
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(
        ResponsiveHelper.isDesktop(Get.context) ? 100 : 80,
      );
}

class _CustomAppBarState extends State<CustomAppBar> {
  late final RxBoolController toggleController;

  @override
  void initState() {
    super.initState();

    // Initialize the controller
    toggleController = Get.put(RxBoolController());

    // Initial header check
    _updateHeader();
  }

  /// Update header visibility based on current route
  void _updateHeader() {
    final currentRoute = Get.currentRoute;

    // Hide header on main URL, show on all other routes
    if (currentRoute == RouteHelper.initial) {
      toggleController.setHeader(false);
      print("Header hidden (main URL)");
    } else {
      toggleController.setHeader(true);
      print("Header shown (not main URL)");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return Obx(() => toggleController.showHeader.value
          ? WebHeader(isMobile: MediaQuery.of(context).size.width < 800)
          : WebMenuBar());
    }

    return AppBar(
      backgroundColor: widget.isBackgroundTransparent
          ? Colors.transparent
          : Get.isDarkMode
              ? Theme.of(context).cardColor.withOpacity(.2)
              : Theme.of(context).primaryColor,
      centerTitle: widget.centerTitle,
      elevation: 0,
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title!,
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          if (widget.subTitle != null)
            Text(
              widget.subTitle!,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
        ],
      ),
      leading: widget.isBackButtonExist!
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: widget.isBackgroundTransparent
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).primaryColorLight),
              onPressed: () => widget.onBackPressed != null
                  ? widget.onBackPressed!()
                  : Navigator.of(context).canPop()
                      ? Navigator.pop(context)
                      : Get.offAllNamed(RouteHelper.getInitialRoute()),
            )
          : const SizedBox(),
      actions: widget.showCart!
          ? [
              IconButton(
                onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                icon: CartWidget(
                  color: Get.isDarkMode
                      ? Theme.of(context).primaryColorLight
                      : Colors.white,
                  size: Dimensions.cartWidgetSize,
                ),
              ),
            ]
          : widget.actionWidget != null
              ? [widget.actionWidget!]
              : null,
    );
  }

  @override
  Size get preferredSize => Size(
        Dimensions.webMaxWidth,
        ResponsiveHelper.isDesktop(Get.context)
            ? Dimensions.preferredSizeWhenDesktop
            : Dimensions.preferredSize,
      );
}

class WebHeader extends StatelessWidget {
  final bool isMobile;
  final WebHeaderController controller = Get.put(WebHeaderController());

  WebHeader({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = isMobile ? 16 : 40;
    final double verticalPadding = isMobile ? 12 : 16;

    return Container(
      color: Colors.white,
      child: Center(
        child:

            //  ConstrainedBox(
            //   constraints: const BoxConstraints(
            //     maxWidth: 1200, // max width for large screens
            //   ),
            // child:
            Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          child: SizedBox(
            height: isMobile ? 70 : 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: () => Get.toNamed(RouteHelper.getInitialRoute()),
                    child: Image.asset(
                      "assets/landingservices/vfix4ulogo.png",
                      width: isMobile ? 120 : 180,
                      height: isMobile ? 50 : 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Navigation Items
                if (!isMobile)
                  Obx(
                    () => Row(
                      children: [
                        _navItem("Home", 1, RouteHelper.getMainRoute('home')),
                        _navItem("About Us", 2,
                            RouteHelper.getHtmlRoute('about_us')),
                        _navItem("Services", 3,
                            RouteHelper.allServiceScreenRoute('all_service')),
                        _navItem("Contact", 4, RouteHelper.getSupportRoute()),
                        _navItem(
                          "Provider",
                          5,
                          "https://vfix4u.com/provider/auth/sign-up",
                          isExternal: true,
                        ),
                        const SizedBox(width: 16),
                        _navButton("Login/Register"),
                      ],
                    ),
                  ),

                // Hamburger menu for mobile
                if (isMobile)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      iconSize: 30,
                      onPressed: () {
                        // TODO: Open drawer or popup menu for mobile
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }

  Widget _navItem(String title, int index, String route,
      {bool isExternal = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          controller.setActive(index);

          if (isExternal) {
            await launchUrl(
              Uri.parse(route),
              mode: LaunchMode.externalApplication,
              webOnlyWindowName: "_blank",
            );
          } else {
            Get.toNamed(route);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: controller.activeIndex.value == index
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _navButton(String title) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton(
        onPressed: () => Get.toNamed(RouteHelper.getSignInRoute()),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class WebHeaderController extends GetxController {
  var activeIndex = 0.obs;

  // Add this method so callers like controller.setActive(index) work
  void setActive(int index) {
    activeIndex.value = index;
  }
}
