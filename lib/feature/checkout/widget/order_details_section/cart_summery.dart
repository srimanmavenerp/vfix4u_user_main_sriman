// import 'package:get/get.dart';
// import 'package:Vfix4u/utils/core_export.dart';

// class CartSummery extends StatelessWidget {
//   const CartSummery({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CheckOutController>(builder: (checkoutController) {
//       return GetBuilder<ScheduleController>(builder: (scheduleController) {
//         return GetBuilder<CartController>(builder: (cartController) {
//           int scheduleDaysCount = scheduleController.scheduleDaysCount > 0
//               ? scheduleController.scheduleDaysCount
//               : 1;

//           ConfigModel configModel = Get.find<SplashController>().configModel;
//           List<CartModel> cartList = cartController.cartList;
//           bool walletPaymentStatus = cartController.walletPaymentStatus;
//           int applicableCouponCount =
//               CheckoutHelper.getNumberOfDaysForApplicableCoupon(
//                       pickedScheduleDays: scheduleDaysCount) ??
//                   1;
//           double additionalCharge = CheckoutHelper.getAdditionalCharge();
//           bool isPartialPayment = CheckoutHelper.checkPartialPayment(
//               walletBalance: cartController.walletBalance,
//               bookingAmount: cartController.totalPrice);
//           double paidAmount = CheckoutHelper.calculatePaidAmount(
//               walletBalance: cartController.walletBalance,
//               bookingAmount: cartController.totalPrice);
//           double subTotalPrice = CheckoutHelper.calculateSubTotal(
//               cartList: cartList, daysCount: scheduleDaysCount);
//           double disCount = CheckoutHelper.calculateDiscount(
//               cartList: cartList,
//               discountType: DiscountType.general,
//               daysCount: scheduleDaysCount);
//           double campaignDisCount = CheckoutHelper.calculateDiscount(
//               cartList: cartList,
//               discountType: DiscountType.campaign,
//               daysCount: scheduleDaysCount);
//           double couponDisCount = CheckoutHelper.calculateDiscount(
//               cartList: cartList,
//               discountType: DiscountType.coupon,
//               daysCount: applicableCouponCount);
//           double referDisCount = cartController.referralAmount;
//           double vat = CheckoutHelper.calculateVat(
//               cartList: cartList, daysCount: scheduleDaysCount);
//           double grandTotal = CheckoutHelper.calculateGrandTotal(
//               cartList: cartList,
//               referralDiscount: referDisCount,
//               daysCount: scheduleDaysCount);
//           double dueAmount = CheckoutHelper.calculateDueAmount(
//               cartList: cartList,
//               walletPaymentStatus: walletPaymentStatus,
//               walletBalance: cartController.walletBalance,
//               bookingAmount: cartController.totalPrice,
//               referralDiscount: referDisCount,
//               daysCount: scheduleDaysCount);
//           double totalSavings = disCount + referDisCount + campaignDisCount + couponDisCount;
//           Future.delayed(const Duration(milliseconds: 200), () {
//             cartController.updateTotalPrice = grandTotal;
//             cartController.update();
//           });

//           return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: Dimensions.paddingSizeDefault,
//                         horizontal: Dimensions.paddingSizeDefault),
//                     child: Text('cart_summary'.tr,
//                         style: robotoMedium.copyWith(
//                             fontSize: Dimensions.fontSizeDefault))),
//                 Padding(
//                   padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
//                   child: Column(children: [
//                     ListView.builder(
//                       itemCount: cartList.length,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         double totalCost =
//                             (cartList.elementAt(index).serviceCost.toDouble() *
//                                     cartList.elementAt(index).quantity) *
//                                 scheduleDaysCount;
//                         return Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               RowText(
//                                   title:
//                                       cartList.elementAt(index).service!.name!,
//                                   quantity: cartList.elementAt(index).quantity,
//                                   price: totalCost),
//                               SizedBox(
//                                 width: Get.width / 2.5,
//                                 child: Text(
//                                   cartList.elementAt(index).variantKey,
//                                   style: robotoMedium.copyWith(
//                                       color: Theme.of(context)
//                                           .textTheme
//                                           .bodyLarge!
//                                           .color!
//                                           .withValues(alpha: .4),
//                                       fontSize: Dimensions.fontSizeSmall),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: Dimensions.paddingSizeDefault,
//                               )
//                             ]);
//                       },
//                     ),

//                     Divider(
//                         color: Theme.of(context)
//                             .textTheme
//                             .bodyLarge!
//                             .color!
//                             .withValues(alpha: .6)),
//                     const SizedBox(height: Dimensions.paddingSizeExtraSmall),

//                     RowText(title: 'total'.tr, price: subTotalPrice),
//                     (configModel.content?.additionalChargeLabelName != "" &&
//                             configModel.content?.additionalCharge == 1)
//                         ? GetBuilder<CheckOutController>(builder: (controller) {
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Row(
//                                     children: [
//                                       Flexible(
//                                           child: Text(
//                                         configModel.content
//                                                 ?.additionalChargeLabelName ??
//                                             "",
//                                         style: robotoRegular.copyWith(
//                                             fontSize:
//                                                 Dimensions.fontSizeDefault),
//                                         overflow: TextOverflow.ellipsis,
//                                       )),
//                                     ],
//                                   ),
//                                 ),
//                                 Text(
//                                   "(+) ${PriceConverter.convertPrice(additionalCharge, isShowLongPrice: true)}",
//                                   style: robotoRegular.copyWith(
//                                       fontSize: Dimensions.fontSizeDefault),
//                                 )
//                               ],
//                             );
//                           })
//                         : const SizedBox(),

//                     // RowText(title: 'vat'.tr, price: vat),
//                     RowText(title: 'discount'.tr, price: disCount),
//                     RowText(title: 'coupon_discount'.tr, price: couponDisCount),
//                     RowText(
//                         title: 'campaign_discount'.tr, price: campaignDisCount),
//                     RowText(
//                         title: 'sub_total'.tr,
//                         price: subTotalPrice - disCount-couponDisCount-campaignDisCount),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Flexible(
//                                   child: Text(
//                                 "GST",
//                                 style: robotoRegular.copyWith(
//                                     fontSize: Dimensions.fontSizeDefault),
//                                 overflow: TextOverflow.ellipsis,
//                               )),
//                             ],
//                           ),
//                         ),
//                         Text(
//                           "(+) ${PriceConverter.convertPrice(vat, isShowLongPrice: true)}",
//                           style: robotoRegular.copyWith(
//                               fontSize: Dimensions.fontSizeDefault),
//                         )
//                       ],
//                     ),
//                     if (referDisCount > 0)
//                       RowText(
//                           title: 'referral_discount'.tr, price: referDisCount),

// // Divider
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: Dimensions.paddingSizeSmall),
//                       child: Divider(
//                         color: Theme.of(context)
//                             .textTheme
//                             .bodyLarge!
//                             .color!
//                             .withOpacity(0.6),
//                       ),
//                     ),

// // Woho Message

// // Grand Total and Wallet Details
//                     RowText(title: 'grand_total'.tr, price: grandTotal),

//                     if (Get.find<CartController>().walletPaymentStatus)
//                       RowText(title: 'paid_by_wallet'.tr, price: paidAmount),

//                     if (Get.find<CartController>().walletPaymentStatus &&
//                         isPartialPayment)
//                       RowText(title: 'due_amount'.tr, price: dueAmount),
//                     if (totalSavings > 0)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: Text(
//                         '🎉 Wola! You saved ₹${totalSavings.toStringAsFixed(2)}/- on this service!',
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ]),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: Dimensions.paddingSizeSmall,
//                       vertical: Dimensions.paddingSizeSmall),
//                   child: ConditionCheckBox(
//                     checkBoxValue: checkoutController.acceptTerms,
//                     onTap: (bool? value) {
//                       checkoutController.toggleTerms();
//                     },
//                   ),
//                 ),
//               ]);
//         });
//       });
//     });
//   }
// }
import 'package:get/get.dart';
import 'package:Vfix4u/utils/core_export.dart';

class CartSummery extends StatelessWidget {
  const CartSummery({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckOutController>(builder: (checkoutController) {
      return GetBuilder<ScheduleController>(builder: (scheduleController) {
        return GetBuilder<CartController>(builder: (cartController) {
          int scheduleDaysCount = scheduleController.scheduleDaysCount > 0
              ? scheduleController.scheduleDaysCount
              : 1;

          ConfigModel configModel = Get.find<SplashController>().configModel;

          List<CartModel> cartList = cartController.cartList;
          bool walletPaymentStatus = cartController.walletPaymentStatus;

          int applicableCouponCount =
              CheckoutHelper.getNumberOfDaysForApplicableCoupon(
                    pickedScheduleDays: scheduleDaysCount,
                  ) ??
                  1;

          double additionalCharge = CheckoutHelper.getAdditionalCharge();

          bool isPartialPayment = CheckoutHelper.checkPartialPayment(
            walletBalance: cartController.walletBalance,
            bookingAmount: cartController.totalPrice,
          );

          double paidAmount = CheckoutHelper.calculatePaidAmount(
            walletBalance: cartController.walletBalance,
            bookingAmount: cartController.totalPrice,
          );

          double subTotalPrice = CheckoutHelper.calculateSubTotal(
            cartList: cartList,
            daysCount: scheduleDaysCount,
          );

          double discount = CheckoutHelper.calculateDiscount(
            cartList: cartList,
            discountType: DiscountType.general,
            daysCount: scheduleDaysCount,
          );

          double campaignDiscount = CheckoutHelper.calculateDiscount(
            cartList: cartList,
            discountType: DiscountType.campaign,
            daysCount: scheduleDaysCount,
          );

          double couponDiscount = CheckoutHelper.calculateDiscount(
            cartList: cartList,
            discountType: DiscountType.coupon,
            daysCount: applicableCouponCount,
          );

          double referralDiscount = cartController.referralAmount;

          double vat = CheckoutHelper.calculateVat(
            cartList: cartList,
            daysCount: scheduleDaysCount,
          );

          double grandTotal = CheckoutHelper.calculateGrandTotal(
            cartList: cartList,
            referralDiscount: referralDiscount,
            daysCount: scheduleDaysCount,
          );

          double dueAmount = CheckoutHelper.calculateDueAmount(
            cartList: cartList,
            walletPaymentStatus: walletPaymentStatus,
            walletBalance: cartController.walletBalance,
            bookingAmount: cartController.totalPrice,
            referralDiscount: referralDiscount,
            daysCount: scheduleDaysCount,
          );

          double totalSavings =
              discount + referralDiscount + campaignDiscount + couponDiscount;

          Future.delayed(const Duration(milliseconds: 200), () {
            cartController.updateTotalPrice = grandTotal;
            cartController.update();
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Text(
                  'cart_summary'.tr,
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeDefault),
                ),
              ),

              /// Cart Items
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        final item = cartList[index];

                        double totalCost =
                            (item.serviceCost.toDouble() * item.quantity) *
                                scheduleDaysCount;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RowText(
                              title: item.service!.name!,
                              quantity: item.quantity,
                              price: totalCost,
                            ),
                            SizedBox(
                              width: Get.width / 2.5,
                              child: Text(
                                item.variantKey,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: robotoMedium.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(.4),
                                  fontSize: Dimensions.fontSizeSmall,
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeDefault),
                          ],
                        );
                      },
                    ),

                    Divider(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.6),
                    ),

                    /// Totals
                    RowText(title: 'total'.tr, price: subTotalPrice),

                    if (configModel.content?.additionalCharge == 1 &&
                        additionalCharge > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            configModel.content?.additionalChargeLabelName ??
                                "",
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault),
                          ),
                          Text(
                            "(+) ${PriceConverter.convertPrice(additionalCharge)}",
                          ),
                        ],
                      ),

                    if (discount > 0)
                      RowText(title: 'discount'.tr, price: discount),

                    if (couponDiscount > 0)
                      RowText(
                          title: 'coupon_discount'.tr, price: couponDiscount),

                    if (campaignDiscount > 0)
                      RowText(
                          title: 'campaign_discount'.tr,
                          price: campaignDiscount),

                    if (vat > 0) RowText(title: 'GST', price: vat),

                    if (referralDiscount > 0)
                      RowText(
                          title: 'referral_discount'.tr,
                          price: referralDiscount),

                    const Divider(),

                    /// Grand Total
                    RowText(title: 'grand_total'.tr, price: grandTotal),

                    if (walletPaymentStatus)
                      RowText(title: 'paid_by_wallet'.tr, price: paidAmount),

                    if (walletPaymentStatus && isPartialPayment)
                      RowText(title: 'due_amount'.tr, price: dueAmount),

                    /// Savings Banner
                    if (totalSavings > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          '🎉 Wola! You saved ₹${totalSavings.toStringAsFixed(2)}/- on this service!',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              /// Terms Checkbox
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: ConditionCheckBox(
                  checkBoxValue: checkoutController.acceptTerms,
                  onTap: (_) => checkoutController.toggleTerms(),
                ),
              ),
            ],
          );
        });
      });
    });
  }
}
