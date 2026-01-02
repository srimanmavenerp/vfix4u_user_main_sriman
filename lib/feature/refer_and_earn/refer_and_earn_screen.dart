import 'package:Vfix4u/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Add http package
import 'dart:convert';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final TextEditingController _refCodeController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final userController = Get.find<UserController>();
    userController.getUserInfo(reload: false);
    _refCodeController.text = userController.userInfoModel?.referCode ?? "";
  }

  @override
  void dispose() {
    _refCodeController.dispose();
    super.dispose();
  }

  Future<void> _updateRefCode() async {
    if (_refCodeController.text.trim().isEmpty) {
      customSnackBar('please_enter_ref_code'.tr,
          type: ToasterMessageType.error);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse('https://vfix4u.com/api/v1/customer/auth/update-ref-code'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Get.find<AuthController>().getUserToken()}',
        },
        body: jsonEncode({'ref_code': _refCodeController.text.trim()}),
      );

      if (response.statusCode == 200) {
        final userController = Get.find<UserController>();
        userController.userInfoModel?.referCode =
            _refCodeController.text.trim();
        customSnackBar('ref_code_updated_success'.tr,
            type: ToasterMessageType.success);
      } else {
        final error =
            jsonDecode(response.body)['message'] ?? 'error_occurred'.tr;
        customSnackBar(error, type: ToasterMessageType.error);
      }
    } catch (e) {
      customSnackBar('error_occurred'.tr, type: ToasterMessageType.error);
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> shareItem = [Images.share];
    final List<String> hintList = [
      'invite_your_friends'.tr,
      '${'they_register'.tr} ${AppConstants.appName} ${'with_special_offer'.tr}',
      'you_made_your_earning'.tr
    ];

    return CustomPopScopeWidget(
      onPopInvoked: () {
        Get.toNamed(RouteHelper.getInitialRoute());
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'refer_and_earn'.tr),
        endDrawer:
            ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
        body: GetBuilder<UserController>(
          builder: (userController) {
            return Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: ExpandableBottomSheet(
                  background: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraLarge),
                            child: Image.asset(Images.referAndEarn,
                                height: Get.height * 0.2),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Text(
                            'invite_friend_and_businesses'.tr,
                            textAlign: TextAlign.center,
                            style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeOverLarge,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Text(
                            'copy_your_code'.tr,
                            textAlign: TextAlign.center,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault),
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),

                          /// Editable Referral Code Field
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeLarge),
                            child: TextField(
                              controller: _refCodeController,
                              decoration: InputDecoration(
                                labelText: 'your_personal_code'.tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          /// Submit button
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _updateRefCode,
                              child: _isSubmitting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white),
                                    )
                                  : Text('submit'.tr),
                            ),
                          ),

                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),
                          Text('or_share'.tr,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge)),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: shareItem
                                  .map((item) => GestureDetector(
                                        onTap: () => Share.share(
                                          Get.find<SplashController>()
                                                      .configModel
                                                      .content
                                                      ?.appUrlAndroid !=
                                                  null
                                              ? '${AppConstants.appName} ${'referral_code'.tr}: ${_refCodeController.text} \n${'download_app_from_this_link'.tr}: ${Get.find<SplashController>().configModel.content?.appUrlAndroid}'
                                              : '${AppConstants.appName} ${'referral_code'.tr}: ${_refCodeController.text}',
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .paddingSizeExtraSmall),
                                          child: Image.asset(item,
                                              height: 50, width: 50),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  persistentContentHeight: 80,
                  expandableContent: ReferHintView(hintList: hintList),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
