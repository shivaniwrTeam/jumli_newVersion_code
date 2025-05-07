import 'package:eClassify/utils/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetApiKeysCubit extends Cubit<GetApiKeysState> {
  GetApiKeysCubit() : super(GetApiKeysInitial());

  Future<void> fetch() async {
    try {
      emit(GetApiKeysInProgress());
      Map<String, dynamic> result = await Api.get(url: Api.getPaymentSettingsApi);
      var data = result['data'] ?? {};

      emit(GetApiKeysSuccess(
        razorPayApiKey: _getData(data, 'Razorpay', 'api_key'),
        razorPayCurrency: _getData(data, 'Razorpay', 'currency_code'),
        razorPayStatus: _getIntData(data, 'Razorpay', 'status'),
        payStackApiKey: _getData(data, 'Paystack', 'api_key'),
        payStackCurrency: _getData(data, 'Paystack', 'currency_code'),
        payStackStatus: _getIntData(data, 'Paystack', 'status'),
        stripeCurrency: _getData(data, 'Stripe', 'currency_code'),
        stripePublishableKey: _getData(data, 'Stripe', 'api_key'),
        stripeStatus: _getIntData(data, 'Stripe', 'status'),
        phonePeKey: _getData(data, 'PhonePe', 'api_key'),
        phonePeCurrency: _getData(data, 'PhonePe', 'currency_code'),
        phonePeStatus: _getIntData(data, 'PhonePe', 'status'),
        flutterWaveKey: _getData(data, 'flutterwave', 'api_key'),
        flutterWaveCurrency: _getData(data, 'flutterwave', 'currency_code'),
        flutterWaveStatus: _getIntData(data, 'flutterwave', 'status'),
        bankAccountHolder: _getData(data, 'bankTransfer', 'account_holder_name'),
        bankAccountNumber: _getData(data, 'bankTransfer', 'account_number'),
        bankName: _getData(data, 'bankTransfer', 'bank_name'),
        bankIfscSwiftCode: _getData(data, 'bankTransfer', 'ifsc_swift_code'),
        bankTransferStatus: _getIntData(data, 'bankTransfer', 'status'),
      ));
    } catch (e, stackTrace) {
      emit(GetApiKeysFail(e.toString()));
    }
  }

  String _getData(Map<String, dynamic> data, String type, String key, {String defaultValue = ''}) =>
      data[type]?[key]?.toString() ?? defaultValue;

  int _getIntData(Map<String, dynamic> data, String type, String key, {int defaultValue = 0}) =>
      int.tryParse(_getData(data, type, key, defaultValue: defaultValue.toString())) ?? defaultValue;
}

abstract class GetApiKeysState {}

class GetApiKeysInitial extends GetApiKeysState {}

class GetApiKeysInProgress extends GetApiKeysState {}

class GetApiKeysFail extends GetApiKeysState {
  final String error;
  GetApiKeysFail(this.error);
}

class GetApiKeysSuccess extends GetApiKeysState {
  final String? razorPayApiKey, razorPayCurrency, payStackApiKey, payStackCurrency,
      stripeCurrency, stripePublishableKey, phonePeKey, phonePeCurrency,
      flutterWaveKey, flutterWaveCurrency, bankAccountHolder, bankAccountNumber,
      bankName, bankIfscSwiftCode;

  final int razorPayStatus, payStackStatus, stripeStatus, phonePeStatus,
      flutterWaveStatus, bankTransferStatus;

  GetApiKeysSuccess({
    this.razorPayApiKey,
    this.razorPayCurrency,
    this.payStackApiKey,
    this.payStackCurrency,
    this.stripeCurrency,
    this.stripePublishableKey,
    this.phonePeKey,
    this.phonePeCurrency,
    this.flutterWaveKey,
    this.flutterWaveCurrency,
    this.bankAccountHolder,
    this.bankAccountNumber,
    this.bankName,
    this.bankIfscSwiftCode,
    this.razorPayStatus = 0,
    this.payStackStatus = 0,
    this.stripeStatus = 0,
    this.phonePeStatus = 0,
    this.flutterWaveStatus = 0,
    this.bankTransferStatus = 0,
  });
}
