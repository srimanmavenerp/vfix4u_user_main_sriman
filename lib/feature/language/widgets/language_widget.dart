import 'package:Vfix4u/common/models/language_model.dart';
import 'package:Vfix4u/common/widgets/ripple_button.dart';
import 'package:Vfix4u/feature/language/controller/localization_controller.dart';
import 'package:Vfix4u/feature/splash/controller/theme_controller.dart';
import 'package:Vfix4u/utils/dimensions.dart';
import 'package:Vfix4u/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;

  const LanguageWidget({
    super.key,
    required this.languageModel,
    required this.localizationController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = localizationController.selectedIndex == index;

    return GestureDetector(
      onTap: () {
        localizationController.setSelectIndex(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeLarge,
            horizontal: Dimensions.paddingSizeExtraLarge),
        margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Get.isDarkMode
                  ? Colors.grey.withOpacity(0.2)
                  : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: Get.find<ThemeController>().darkTheme ? null : shadow,
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            languageModel.languageName!,
            textAlign: TextAlign.center,
            style: robotoMedium.copyWith(
              fontSize: 16,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ),
      ),
    );
  }
}
