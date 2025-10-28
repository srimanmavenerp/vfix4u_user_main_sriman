import 'dart:convert';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PopupBannerController extends GetxController {
  var banners = <dynamic>[].obs;
  var isLoading = true.obs;
  final storage = GetStorage();

  int _callCount = 0;
  DateTime _firstCallTime = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  /// Fetch banners from API with rate-limiting
  Future<void> fetchBanners() async {
    // Reset counter every minute
    if (DateTime.now().difference(_firstCallTime).inMinutes >= 1) {
      _callCount = 0;
      _firstCallTime = DateTime.now();
    }

    if (_callCount >= 5) {
      print("API call limit reached: 5 per minute");
      return;
    }

    _callCount++;

    try {
      isLoading(true);
      final response = await http
          .get(Uri.parse('https://vfix4u.com/api/v1/banner/get-offers'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        banners.value = data;
      } else {
        print("Failed to fetch banners: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching banners: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Show popup banner if available
  void showBannerPopup() {
    if (banners.isEmpty) return;

    List<String> seenBanners = storage.read<List<String>>('seen_banners') ?? [];

    final popupBanner = banners.firstWhere(
      (b) => b['show_in_popup'] == 1 && !seenBanners.contains(b['id']),
      orElse: () => null,
    );

    if (popupBanner != null) {
      Future.delayed(Duration.zero, () {
        Get.dialog(
          Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(8),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            'https://vfix4u.com/storage/app/public/banner/${popupBanner['banner_image']}',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.error, color: Colors.red),
                              );
                            },
                          ),
                        ),
                      ),

                      // Gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black54, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  popupBanner['banner_title'] ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Get.back();
                                  seenBanners.add(popupBanner['id']);
                                  storage.write('seen_banners', seenBanners);
                                  await navigateFromBanner(
                                    popupBanner['resource_type'] ?? '',
                                    popupBanner['resource_id'] ?? '',
                                    popupBanner['redirect_link'] ?? '',
                                    popupBanner['resource_id'] ?? '',
                                  );
                                },
                                child: Text(
                                  'Explore',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      seenBanners.add(popupBanner['id']);
                      storage.write('seen_banners', seenBanners);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          barrierDismissible: true,
        );
      });
    }
  }

  /// Navigation based on banner type
  Future<void> navigateFromBanner(
    String resourceType,
    String bannerID,
    String link,
    String resourceID, {
    String categoryName = '',
  }) async {
    switch (resourceType) {
      case 'category':
        Get.toNamed(
          RouteHelper.subCategoryScreenRoute(categoryName, resourceID, 0),
        );
        break;
      case 'service':
        Get.toNamed(RouteHelper.getServiceRoute(resourceID));
        break;
      case 'link':
        if (link.isNotEmpty && await canLaunchUrl(Uri.parse(link))) {
          await launchUrl(Uri.parse(link));
        }
        break;
      default:
        print("No navigation defined for this banner type.");
    }
  }
}
