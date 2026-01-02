import 'package:Vfix4u/common/models/api_response_model.dart';
import 'package:Vfix4u/common/repo/data_sync_repo.dart';
import 'package:Vfix4u/utils/core_export.dart';

class BannerRepo extends DataSyncRepo {
  BannerRepo(
      {required super.apiClient,
      required SharedPreferences super.sharedPreferences});

  Future<ApiResponseModel<T>> getBannerList<T>(
      {required DataSourceEnum source}) async {
    return await fetchData<T>(AppConstants.bannerUri, source);
  }
}
