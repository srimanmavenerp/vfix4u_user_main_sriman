import 'dart:convert';
import 'package:demandium/common/models/api_response_model.dart';
import 'package:demandium/common/repo/data_sync_repo.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo extends DataSyncRepo {
  CartRepo(
      {required super.apiClient,
      required SharedPreferences super.sharedPreferences});

  Future<Response> addToCartListToServer(CartModelBody cartModel) async {
    final response =
        await apiClient.postData(AppConstants.addToCart, cartModel.toJson());
    print('Response cartttttttttttt: $response');
    return response;
  }

  Future<ApiResponseModel<T>> getCartListFromServer<T>(
      {required DataSourceEnum source}) async {
    final response = await fetchData<T>(
      "${AppConstants.getCartList}&&guest_id=${Get.find<SplashController>().getGuestId()}",
      source,
    );
    print('Fetched cart list guesttttttttttttttttttt : $response');
    return response;
  }

  Future<Response> removeCartFromServer(String cartID) async {
    return await apiClient.deleteData(
        "${AppConstants.removeCartItem}$cartID?guest_id=${Get.find<SplashController>().getGuestId()}");
  }

  Future<Response> removeAllCartFromServer() async {
    return await apiClient.deleteData(
        "${AppConstants.removeAllCartItem}?guest_id=${Get.find<SplashController>().getGuestId()}");
  }

  Future<Response> updateCartQuantity(String cartID, int quantity) async {
    return await apiClient.putData(
        "${AppConstants.updateCartQuantity}$cartID?guest_id=${Get.find<SplashController>().getGuestId()}",
        {'quantity': quantity});
  }

  Future<Response> updateProvider(String providerId) async {
    return await apiClient.postData(AppConstants.updateCartProvider, {
      'provider_id': providerId,
      "_method": "put",
      "guest_id": Get.find<SplashController>().getGuestId()
    });
  }

  Future<Response> getProviderBasedOnSubcategory(String subcategoryId) async {
    return await apiClient.getData(
        "${AppConstants.getProviderBasedOnSubcategory}?sub_category_id=$subcategoryId");
  }

  Future<Response> addRebookToServer(String bookingId) async {
    return await apiClient.postData(AppConstants.rebookApi, {
      'booking_id': bookingId,
      'guest_id': Get.find<SplashController>().getGuestId()
    });
  }

  // Save cart
  Future<void> saveCartListToLocal(List<Map<String, dynamic>> cartList) async {
    try {
      await sharedPreferences!.setString('cart_list', jsonEncode(cartList));
      print('Cart list saved to local storage: $cartList');
    } catch (e) {
      print('Error saving cart list to local storage: $e');
    }
  }

  //  local storage
  Future<List<Map<String, dynamic>>?> getCartListFromLocal() async {
    try {
      final cartJson = sharedPreferences!.getString('cart_list');
      if (cartJson != null) {
        final List<dynamic> cartList = jsonDecode(cartJson);
        print('Cart list retrieved from local storage: $cartList');
        return cartList.cast<Map<String, dynamic>>();
      }
      print('No cart list found in local storage');
      return null;
    } catch (e) {
      print('Error retrieving cart list from local storage: $e');
      return null;
    }
  }

  // Clear

  Future<void> clearCartListFromLocal() async {
    try {
      await sharedPreferences!.remove('cart_list');
      print('Cart list cleared from local storage');
    } catch (e) {
      print('Error clearing cart list from local storage: $e');
    }
  }
}
