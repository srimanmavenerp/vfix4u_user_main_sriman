import 'package:Vfix4u/common/widgets/no_data_screen.dart';
import 'package:Vfix4u/feature/auth/controller/auth_controller.dart';
import 'package:Vfix4u/feature/cart/controller/cart_controller.dart';
import 'package:Vfix4u/feature/coupon/controller/coupon_controller.dart';
import 'package:Vfix4u/feature/coupon/model/coupon_model.dart';
import 'package:Vfix4u/feature/coupon/widgets/custom_coupon_snackber.dart';
import 'package:Vfix4u/feature/coupon/widgets/voucher.dart';
import 'package:Vfix4u/feature/splash/controller/theme_controller.dart';
import 'package:Vfix4u/helper/price_converter.dart';
import 'package:Vfix4u/helper/responsive_helper.dart';
import 'package:Vfix4u/utils/dimensions.dart';
import 'package:Vfix4u/utils/images.dart';
import 'package:Vfix4u/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponBottomSheetWidget extends StatefulWidget {
  final double orderAmount;
  const CouponBottomSheetWidget({super.key, required this.orderAmount});

  @override
  State<CouponBottomSheetWidget> createState() =>
      _CouponBottomSheetWidgetState();
}

class _CouponBottomSheetWidgetState extends State<CouponBottomSheetWidget> {
  TextEditingController couponTextController = TextEditingController();
  CouponModel? couponModel;
  int? couponIndex;

  Future<void> applyCouponAndHandle(
      String code, CouponModel? model, int? index) async {
    final couponController = Get.find<CouponController>();
    final cartController = Get.find<CartController>();
    final authController = Get.find<AuthController>();

    couponTextController.text = code;
    couponModel = model;
    couponIndex = index;

    if (code.isEmpty) {
      customCouponSnackBar("select_a_coupon", subtitle: 'select_a_coupon'.tr);
      return;
    }

    couponController.updateSelectedCouponIndex(index: index);

    if (!authController.isLoggedIn()) {
      customCouponSnackBar("sorry_you_can_not_use_coupon",
          subtitle: "please_login_to_use_coupon");
      return;
    }

    if (cartController.cartList.isEmpty) {
      customCouponSnackBar("oops",
          subtitle: "looks_like_no_service_is_added_to_your_cart");
      return;
    }

    bool addCoupon = false;
    if (model != null) {
      for (var cart in cartController.cartList) {
        if (cart.totalCost >= model.discount!.minPurchase!.toDouble()) {
          addCoupon = true;
          break;
        }
      }
    } else {
      addCoupon = true;
    }

    if (addCoupon) {
      final value = await couponController.applyCoupon(code);
      if (value.isSuccess!) {
        cartController.getCartListFromServer();
        Get.back();
        customCouponSnackBar("coupon_applied_successfully".tr,
            subtitle: "review_your_cart_for_applied_discounts".tr,
            isError: false);
      } else {
        customCouponSnackBar("can_not_apply_coupon",
            subtitle: "${value.message}");
      }
    } else {
      customCouponSnackBar("can_not_apply_coupon",
          subtitle:
              "${'valid_for_minimum_booking_amount_of'.tr} ${PriceConverter.convertPrice(model?.discount?.minPurchase ?? 0)} ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponController>(builder: (couponController) {
      bool isDesktop = ResponsiveHelper.isDesktop(context);
      List<CouponModel>? activeCouponList = couponController.activeCouponList;

      return Container(
        width: Dimensions.webMaxWidth / 2.5,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
          minHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(Dimensions.paddingSizeDefault),
            topRight: const Radius.circular(Dimensions.paddingSizeDefault),
            bottomLeft: isDesktop
                ? const Radius.circular(Dimensions.paddingSizeDefault)
                : Radius.zero,
            bottomRight: isDesktop
                ? const Radius.circular(Dimensions.paddingSizeDefault)
                : Radius.zero,
          ),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Spacer(),
                  if (!isDesktop)
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: Dimensions.paddingSizeDefault,
                          left: Dimensions.paddingSizeDefault),
                      child: Center(
                        child: Container(
                          width: 35,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeDefault),
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close,
                        color: Theme.of(context).disabledColor, size: 25),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeSmall),
                child: Text('available_promo'.tr,
                    style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge)),
              ),
              activeCouponList != null
                  ? activeCouponList.isNotEmpty
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: Dimensions.paddingSizeDefault),
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                      height: Dimensions.paddingSizeSmall),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: activeCouponList.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  //height: 150,
                                  child: Voucher(
                                    isExpired: false,
                                    couponModel: activeCouponList[index],
                                    index: index,
                                    fromCheckout: true,
                                    onTap: (CouponModel couponData) async {
                                      await applyCouponAndHandle(
                                        couponData.couponCode ?? '',
                                        couponData,
                                        index,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : NoDataScreen(text: 'no_coupon_available'.tr)
                  : const Expanded(
                      child: Center(child: CircularProgressIndicator())),
            ]),
      );
    });
  }
}
