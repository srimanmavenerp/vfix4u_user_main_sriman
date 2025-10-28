import 'dart:convert';
import 'dart:developer';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class PaymentScreen extends StatefulWidget {
  final String url;
  final String? fromPage;
  const PaymentScreen({super.key, required this.url, this.fromPage});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  String? selectedUrl;
  double value = 0.0;
  final bool _isLoading = true;
  PullToRefreshController? pullToRefreshController;
  late MyInAppBrowser browser;

  @override
  void initState() {
    super.initState();
    selectedUrl = widget.url;
    _initData(widget.fromPage ?? "");
    log(widget.url);
  }

  void _initData(String fromPage) async {
    browser = MyInAppBrowser(fromPage: fromPage);

    if (GetPlatform.isAndroid) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);

      bool swAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      bool swInterceptAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        ServiceWorkerController serviceWorkerController = ServiceWorkerController.instance();
        await serviceWorkerController.setServiceWorkerClient(ServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            if (kDebugMode) {
              print(request);
            }
            return null;
          },
        ));
      }
    }

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(selectedUrl!)),
      settings: InAppBrowserClassSettings(
        webViewSettings: InAppWebViewSettings(useShouldOverrideUrlLoading: true, useOnLoadResource: true),
        browserSettings: InAppBrowserSettings(hideUrlBar: true, hideToolbarTop: GetPlatform.isAndroid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: CustomAppBar(title: 'payment'.tr,),
      body: Center(
        child: Stack(
          children: [
            _isLoading ? Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary)),
            ) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class MyInAppBrowser extends InAppBrowser {
  final String fromPage;

  MyInAppBrowser({required this.fromPage});

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(url) async {
    if (kDebugMode) {
      print("\n\nStarted: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  void onExit() {
    if (_canRedirect) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const CustomPopScopeWidget(
            canPop: false,
            child: AlertDialog(
              contentPadding: EdgeInsets.all(Dimensions.paddingSizeSmall),
              content: PaymentFailedDialog(),
            ),
          );
        },
      );
    }

    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    String url = navigationAction.request.url.toString();

    if (kDebugMode) {
      print("\n\nOverride $url\n\n");
    }

    // Handle UPI URL scheme (upi://)
    if (url.startsWith("upi://")) {
      try {
        // Launch the UPI payment app using Intent (for Android)
        await launchUPIIntent(url);
        return NavigationActionPolicy.CANCEL; // Don't load this URL in the webview
      } catch (e) {
        if (kDebugMode) {
          print("Error launching UPI: $e");
        }
        return NavigationActionPolicy.ALLOW; // Let the WebView load the URL normally
      }
    }

    // Allow normal URL loading
    return NavigationActionPolicy.ALLOW;
  }

  // Function to launch the UPI Intent
  Future<void> launchUPIIntent(String url) async {
    try {
      // Check if the URL is a valid UPI URL
      Uri upiUri = Uri.parse(url);
      
      // Check if the system can handle the UPI Intent
      final bool isLaunched = await canLaunch(url);

      if (isLaunched) {
        // Launch the UPI app
        await launch(url);
      } else {
        // If no UPI app is available, log the error or show a message to the user
        print("No UPI app found.");
      }
    } catch (e) {
      print("Error while launching UPI: $e");
    }
  }

  @override
  void onLoadResource(resource) {}

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }

  void _pageRedirect(String url) async {
    if (kDebugMode) {
      print("inside_page_redirect");
    }
    printLog("url:$url");
    if (_canRedirect) {
      bool isSuccess = url.contains('success') && url.contains(AppConstants.baseUrl) && url.contains("flag");
      bool isFailed = url.contains('fail') && url.contains(AppConstants.baseUrl) && url.contains("flag");
      bool isCancel = url.contains('cancel') && url.contains(AppConstants.baseUrl) && url.contains("flag");

      if (kDebugMode) {
        print('This_called_1::::$url');
      }
      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        close();
      }

      if (isSuccess) {
        if (fromPage == "checkout") {
          String token = StringParser.parseString(url, "token");
          Get.find<CartController>().getCartListFromServer();
          Get.back();
          Get.offNamed(RouteHelper.getCheckoutRoute(RouteHelper.checkout, 'complete', 'null', token: token));
        } else if (fromPage == "custom-checkout") {
          Get.offNamed(RouteHelper.getOrderSuccessRoute('success'));
        } else if (fromPage == "add-fund") {
          Get.back();
          String uuid = const Uuid().v1();
          Get.offNamed(RouteHelper.getMyWalletScreen(flag: 'success', token: uuid));
        } else if (fromPage == "switch-payment-method") {
          Get.back();
          customSnackBar('your_payment_confirm_successfully'.tr, toasterTitle: 'payment_status'.tr, type: ToasterMessageType.success, duration: 4);
        } else if (fromPage == "repeat-booking") {
          Get.back();

          String? subBookingId;
          String? token = StringParser.parseString(url, "token");

          try {
            subBookingId = StringParser.parseString(utf8.decode(base64Url.decode(token)), "booking_repeat_id");
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
          if (subBookingId != null) {
            Get.find<BookingDetailsController>().getSubBookingDetails(bookingId: subBookingId);
          }
          customSnackBar("paid_successfully".tr, type: ToasterMessageType.success);
        }
      } else if (isFailed || isCancel) {
        if (fromPage == "add-fund") {
          Get.offNamed(RouteHelper.getMyWalletScreen(flag: 'failed'));
        } else if (fromPage == "repeat-booking") {
          Get.back();
          customSnackBar("payment_failed_try_again".tr, type: ToasterMessageType.error, showDefaultSnackBar: false);
        } else {
          Get.offNamed(RouteHelper.getOrderSuccessRoute('fail'));
        }
      }
    }
  }
}
