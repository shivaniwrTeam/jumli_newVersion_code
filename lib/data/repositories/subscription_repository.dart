import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:eClassify/data/model/data_output.dart';
import 'package:eClassify/data/model/subscription_package_model.dart';
import 'package:eClassify/utils/api.dart';

class SubscriptionRepository {
  Future<DataOutput<SubscriptionPackageModel>> getSubscriptionPacakges(
      {required String type}) async {
    Map<String, dynamic> response = await Api.get(
        url: Api.getPackageApi,
        queryParameters: {if (Platform.isIOS) "platform": "ios", "type": type});

    List<SubscriptionPackageModel> modelList = (response['data'] as List)
        .map((element) => SubscriptionPackageModel.fromJson(element))
        .toList();
    List<SubscriptionPackageModel> combineList = [];
    List<SubscriptionPackageModel> activeModelList =
        modelList.where((item) => item.isActive == true).toList();
    combineList.addAll(activeModelList);
    List<SubscriptionPackageModel> inactiveModelList =
        modelList.where((item) => item.isActive == false).toList();
    combineList.addAll(inactiveModelList);

    return DataOutput(total: combineList.length, modelList: combineList);
  }

  Future<void> subscribeToPackage(
      int packageId, bool isPackageAvailable) async {
    try {
      Map<String, dynamic> parameters = {
        Api.packageId: packageId,
        if (isPackageAvailable) 'flag': 1,
      };

      await Api.post(url: Api.userPurchasePackageApi, parameter: parameters);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future updateBankTransfer(
      {required String paymentTransactionId, required File paymentReceipt}) async {
    try {
      Map<String, dynamic> parameters = {};
      parameters[Api.paymentTransectionId] = paymentTransactionId;

      MultipartFile image = await MultipartFile.fromFile(paymentReceipt.path,
          filename: path.basename(paymentReceipt.path));

      parameters[Api.paymentReceipt] = image;

      var response = await Api.post(
        url: Api.bankTransferUpdateApi,
        parameter: parameters,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
