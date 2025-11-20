import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String? buttonText;
  final bool? transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final IconData? icon;
  final String? assetIcon;
  final Color? backgroundColor;
  final bool showBorder;
  final bool isLoading;
  final Color? textColor;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.transparent = false,
    this.margin,
    this.width,
    this.height,
    this.fontSize,
    this.radius = 5,
    this.icon,
    this.assetIcon,
    this.backgroundColor,
    this.isLoading = false,
    this.textColor,
    this.showBorder = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final ButtonStyle buttonStyle = TextButton.styleFrom(
      backgroundColor: backgroundColor ??
          (onPressed != null
              ? (transparent! ? Colors.transparent : theme.primaryColor)
              : theme.disabledColor),
      foregroundColor: textColor ?? theme.colorScheme.onPrimary,
      minimumSize: Size(
        width ?? Dimensions.webMaxWidth,
        height ?? (ResponsiveHelper.isDesktop(context) ? 50 : 45),
      ),
      padding: EdgeInsets.zero,
      side: showBorder ? BorderSide(color: theme.primaryColor) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius!),
      ),
    );

    return Center(
      child: SizedBox(
        width: width ?? Dimensions.webMaxWidth,
        child: Padding(
          padding: margin ?? EdgeInsets.zero,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Icon(
                      icon,
                      color: transparent!
                          ? Colors.white
                          : theme.colorScheme.onPrimary,
                      size: 18,
                    ),
                  ),
                if (assetIcon != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall),
                    child: Image.asset(
                      assetIcon!,
                      height: 16,
                      width: 16,
                    ),
                  ),
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeEight),
                    child: SizedBox(
                      height: fontSize ?? Dimensions.fontSizeDefault,
                      width: fontSize ?? Dimensions.fontSizeDefault,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: transparent!
                            ? Colors.white
                            : theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                Text(
                  isLoading ? "loading".tr : buttonText ?? '',
                  textAlign: TextAlign.center,
                  style: textStyle ??
                      robotoMedium.copyWith(
                        color: transparent!
                            ? Colors.white
                            : textColor ?? theme.colorScheme.onPrimary,
                        fontSize: fontSize ?? Dimensions.fontSizeDefault,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
