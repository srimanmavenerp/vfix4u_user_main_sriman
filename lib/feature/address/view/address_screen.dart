import 'package:get/get.dart';
import 'package:Vfix4u/utils/core_export.dart';

class AddressScreen extends StatefulWidget {
  final String? fromPage;
  const AddressScreen({super.key, this.fromPage});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch address list when screen initializes
    Get.find<LocationController>()
        .getAddressList(fromCheckout: widget.fromPage == "checkout");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'my_address'.tr),
      endDrawer:
          ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
      body: GetBuilder<LocationController>(builder: (locationController) {
        List<AddressModel>? addressList = locationController.addressList;
        List<AddressModel> zoneBasedAddress = [];

        if (addressList != null && addressList.isNotEmpty) {
          var currentZoneId = locationController.getUserAddress()?.zoneId;
          zoneBasedAddress = addressList
              .where((element) => element.zoneId == currentZoneId)
              .toList();
        }

        if (widget.fromPage == "checkout") {
          addressList = zoneBasedAddress;
        }

        AddressModel? selectedAddress = locationController.selectedAddress;

        if (addressList != null) {
          return FooterBaseView(
            isCenter: (addressList.isEmpty),
            child: WebShadowWrap(
              child: Column(
                children: [
                  // Add address button for desktop
                  if (ResponsiveHelper.isDesktop(context))
                    Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            width: 200,
                            buttonText: 'add_new_address'.tr,
                            onPressed: () => Get.toNamed(
                              RouteHelper.getAddAddressRoute(
                                  widget.fromPage == 'checkout'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  // Address grid or no-data screen
                  if (addressList.isNotEmpty)
                    RefreshIndicator(
                      onRefresh: () async {
                        await locationController.getAddressList(
                          fromCheckout: widget.fromPage == "checkout",
                        );
                      },
                      child: SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                ResponsiveHelper.isMobile(context) ? 1 : 2,
                            childAspectRatio:
                                ResponsiveHelper.isMobile(context) ? 4 : 6,
                            crossAxisSpacing: Dimensions.paddingSizeExtraLarge,
                            mainAxisExtent: Dimensions.addressItemHeight,
                            mainAxisSpacing:
                                ResponsiveHelper.isDesktop(context) ||
                                        ResponsiveHelper.isTab(context)
                                    ? Dimensions.paddingSizeExtraLarge
                                    : 2.0,
                          ),
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          itemCount: addressList.length,
                          itemBuilder: (context, index) {
                            return AddressWidget(
                              selectedUserAddressId: selectedAddress?.id,
                              address: addressList![index],
                              fromAddress: true,
                              fromCheckout: widget.fromPage == 'checkout',
                              isSelected:
                                  addressList[index].id == selectedAddress?.id,
                              onTap: () async {
                                print('Clicked address:');
                                Get.dialog(const CustomLoader(),
                                    barrierDismissible: false);
                                AddressModel address = addressList![index];
                                await locationController.setAddressIndex(
                                    address,
                                    fromAddressScreen: false);
                                // If you want to navigate or update after selection, call your navigation or update logic here.
                                // For example, if you want to mimic access_location_screen:
                                locationController.saveAddressAndNavigate(
                                  address,
                                  false, // or widget.fromSignUp if available
                                  null, // or widget.route if available
                                  false, // or widget.route != null if available
                                  true,
                                );
                                Get.back();
                              },
                              onEditPressed: () {
                                Get.toNamed(
                                  RouteHelper.getEditAddressRoute(
                                      addressList![index], false),
                                );
                              },
                              onRemovePressed: () {
                                if (Get.isSnackbarOpen) Get.back();
                                Get.dialog(ConfirmationDialog(
                                  icon: Images.warning,
                                  description:
                                      'are_you_sure_want_to_delete_address'.tr,
                                  onYesPressed: () {
                                    Navigator.of(context).pop();
                                    Get.dialog(const CustomLoader(),
                                        barrierDismissible: false);
                                    locationController
                                        .deleteUserAddressByID(
                                            addressList![index])
                                        .then((response) {
                                      Get.back();
                                      customSnackBar(
                                        response.message!.tr.capitalizeFirst,
                                        type: ToasterMessageType.success,
                                      );
                                    });
                                  },
                                ));
                              },
                            );
                          },
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: Get.height * 0.6,
                      child: Center(
                        child: NoDataScreen(
                          text: 'no_address_found'.tr,
                          type: NoDataType.address,
                        ),
                      ),
                    ),

                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CustomLoader());
        }
      }),
      floatingActionButton: (!ResponsiveHelper.isDesktop(context) &&
              Get.find<AuthController>().isLoggedIn())
          ? GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.getAddAddressRoute(
                    widget.fromPage == 'checkout'));
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: Get.isDarkMode ? null : shadow,
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius:
                      BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
                ),
                height: Dimensions.addAddressHeight,
                width: Dimensions.addAddressWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 20),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text(
                      'add_new_address'.tr,
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
