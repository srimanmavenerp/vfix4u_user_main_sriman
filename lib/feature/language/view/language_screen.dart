import 'package:get/get.dart';
import 'package:Vfix4u/utils/core_export.dart';

class LanguageScreen extends StatefulWidget {
  final String? fromPage;

  const LanguageScreen({super.key, this.fromPage});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<LocalizationController>().filterLanguage(
        shouldUpdate: false, isChooseLanguage: true, fromPage: widget.fromPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:
          ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
      appBar: widget.fromPage != "fromOthers"
          ? CustomAppBar(title: "language".tr)
          : null,
      body: GetBuilder<LocalizationController>(
        builder: (localizationController) {
          return FooterBaseView(
            isScrollView: (ResponsiveHelper.isMobile(context) ||
                    ResponsiveHelper.isTab(context))
                ? false
                : true,
            isCenter: true,
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (widget.fromPage != "fromSettingsPage")
                                Image.asset(
                                  Images.newlogo,
                                  width: Dimensions.logoSize,
                                ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraMoreLarge),
                              Text(
                                'select_language'.tr,
                                style: robotoMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),
                              SingleChildScrollView(
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          ResponsiveHelper.isDesktop(context)
                                              ? 600 // Limit width for desktop
                                              : 400,
                                    ),
                                    child: ListView.builder(
                                      itemCount: localizationController
                                          .languages.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: Dimensions.paddingSizeLarge,
                                        horizontal:
                                            Dimensions.paddingSizeDefault,
                                      ),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical:
                                                Dimensions.paddingSizeSmall,
                                          ),
                                          child: Center(
                                            child: LanguageWidget(
                                              languageModel:
                                                  localizationController
                                                      .languages[index],
                                              localizationController:
                                                  localizationController,
                                              index: index,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              Text(
                                'you_can_change_language'.tr,
                                style: robotoRegular.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(0.5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Save Button at bottom
                  Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: SafeArea(
                      child: CustomButton(
                        onPressed: () {
                          Get.find<SplashController>()
                              .disableShowInitialLanguageScreen();
                          localizationController.setLanguage(
                            Locale(
                              localizationController
                                  .languages[
                                      localizationController.selectedIndex]
                                  .languageCode!,
                              localizationController
                                  .languages[
                                      localizationController.selectedIndex]
                                  .countryCode,
                            ),
                            isInitial: true,
                          );
                          if (Get.find<SplashController>()
                                  .isShowOnboardingScreen() &&
                              !kIsWeb) {
                            Get.offNamed(RouteHelper.onBoardScreen);
                          } else {
                            Get.offAllNamed(RouteHelper.getMainRoute("home"));
                          }
                        },
                        buttonText: 'save'.tr,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
