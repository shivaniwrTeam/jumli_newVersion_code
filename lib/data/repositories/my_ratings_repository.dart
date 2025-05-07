import 'package:eClassify/utils/api.dart';
import 'package:eClassify/data/model/data_output.dart';
import 'package:eClassify/data/model/my_review_model.dart';

class MyRatingsRepository {
  Future<DataOutput<MyReviewModel>> fetchMyRatingsAllRatings(
      {required int page}) async {
    try {
      Map<String, dynamic> parameters = {"page": page};

      Map<String, dynamic> response =
          await Api.get(url: Api.getMyReviewApi, queryParameters: parameters);

      int totalRatings = response["data"]["ratings"]["total"] ?? 0;

      List<MyReviewModel> userRatings =
          (response["data"]["ratings"]["data"] as List)
              .map((e) => MyReviewModel.fromJson(e))
              .toList();
      double? averageRatings;

      if (response["data"]["average_rating"] != null) {
        averageRatings = (response["data"]["average_rating"] as num).toDouble();
      }

      return DataOutput(
        total: totalRatings,
        modelList: userRatings,
        extraData: ExtraData(
          data: averageRatings,
        ),
      );
    } catch (error) {

      rethrow;
    }
  }
}
