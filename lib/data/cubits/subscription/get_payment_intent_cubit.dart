import 'package:eClassify/data/repositories/advertisement_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GetPaymentIntentState {}

class GetPaymentIntentInitial extends GetPaymentIntentState {}

class GetPaymentIntentInProgress extends GetPaymentIntentState {}

class GetPaymentIntentInSuccess extends GetPaymentIntentState {
  final dynamic paymentIntent;
  final String? message;

  GetPaymentIntentInSuccess(this.paymentIntent, this.message);
}

class GetPaymentIntentFailure extends GetPaymentIntentState {
  final dynamic error;

  GetPaymentIntentFailure(this.error);
}

class GetPaymentIntentCubit extends Cubit<GetPaymentIntentState> {
  GetPaymentIntentCubit() : super(GetPaymentIntentInitial());
  AdvertisementRepository repository = AdvertisementRepository();

  void getPaymentIntent(
      {required int packageId, required String paymentMethod}) async {
    emit(GetPaymentIntentInProgress());

    repository
        .getPaymentIntent(packageId: packageId, paymentMethod: paymentMethod)
        .then((value) {
      if (value['error'] == false) {

        emit(GetPaymentIntentInSuccess(
            value['data']['payment_intent'], value['message']));
      } else {
        emit(GetPaymentIntentFailure(value['message']));
      }
    }).catchError((e) {
      emit(GetPaymentIntentFailure(e.toString()));
    });
  }
}
