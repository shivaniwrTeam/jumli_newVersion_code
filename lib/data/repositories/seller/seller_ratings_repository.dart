import 'package:eClassify/data/model/data_output.dart';
import 'package:eClassify/data/model/seller_ratings_model.dart';
import 'package:eClassify/utils/api.dart';

class SellerRatingsRepository {
  Future<DataOutput<UserRatings>> fetchSellerRatingsAllRatings(
      {required int sellerId, required int page}) async {
    try {
      Map<String, dynamic> parameters = {"id": sellerId, "page": page};

      Map<String, dynamic> response =
          await Api.get(url: Api.getSellerApi, queryParameters: parameters);


      SellerRatingsModel sellerRatingsModel =
          SellerRatingsModel.fromJson(response["data"]);

      int totalRatings = sellerRatingsModel.ratings?.total ?? 0;
      List<UserRatings> userRatings =
          sellerRatingsModel.ratings?.userRatings ?? [];


      var seller = sellerRatingsModel.seller;

      return DataOutput(
        total: totalRatings,
        modelList: userRatings,
        extraData: ExtraData(
          data: seller,
        ),
      );
    } catch (error) {
      rethrow;
    }
  }
}
