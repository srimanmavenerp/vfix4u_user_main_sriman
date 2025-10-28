import 'package:demandium/feature/checkout/widget/coupon_bottom_sheet_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class ApplyVoucher extends StatelessWidget {
  const ApplyVoucher({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponController>(
      builder: (couponController) {
        int couponCount = couponController.activeCouponList?.length ?? 0;

        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeDefault,
              horizontal: Dimensions.paddingSizeDefault),
          margin: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.isDesktop(context)
                  ? 0
                  : Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
            color: Theme.of(context).cardColor,
            border: Border.all(
                color: Theme.of(context).hintColor.withOpacity(0.3),
                width: 0.5),
          ),
          child: Center(
              child: GestureDetector(
                  onTap: () async {
                    if (ResponsiveHelper.isDesktop(context)) {
                      Get.dialog(const Center(
                          child: CouponBottomSheetWidget(orderAmount: 100)));
                    } else {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (c) =>
                              const CouponBottomSheetWidget(orderAmount: 100));
                    }
                  },
                 child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    RichText(
      text: TextSpan(
        style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
        children: [
          TextSpan(text: '${'add_coupon'.tr} '),
          TextSpan(
            text: '($couponCount ${'available'.tr})',
            style: TextStyle(color: const Color.fromARGB(255, 43, 202, 49)), // Green for count
          ),
        ],
      ),
    ),
    Text(
      'add_plus'.tr,
      style: robotoBold.copyWith(
        color: Get.isDarkMode
            ? Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6)
            : Theme.of(context).primaryColor,
      ),
    ),
  ],
)
)),
        );
      },
    );
  }
}
