import 'dart:io';
import 'package:eClassify/data/repositories/subscription_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BankTransferUpdateState {}

class BankTransferUpdateInitial extends BankTransferUpdateState {}

class BankTransferUpdateInProgress extends BankTransferUpdateState {}

class BankTransferUpdateInSuccess extends BankTransferUpdateState {
  final String responseMessage;
  final int transactionId;

  BankTransferUpdateInSuccess(this.responseMessage, this.transactionId);
}

class BankTransferUpdateFailure extends BankTransferUpdateState {
  final dynamic error;

  BankTransferUpdateFailure(this.error);
}

class BankTransferUpdateCubit extends Cubit<BankTransferUpdateState> {
  BankTransferUpdateCubit() : super(BankTransferUpdateInitial());
  SubscriptionRepository repository = SubscriptionRepository();

  void bankTransferUpdate(
      {required String paymentTransactionId,
      required File paymentReceipt}) async {
    try {
      emit(BankTransferUpdateInProgress());

      var response = await repository.updateBankTransfer(
          paymentTransactionId: paymentTransactionId,
          paymentReceipt: paymentReceipt);
      if (response["error"] == false) {
        emit(BankTransferUpdateInSuccess(response["message"],response["data"]["id"]));
      } else {
        emit(BankTransferUpdateFailure(response["message"]));
      }
    } catch (e) {
      emit(BankTransferUpdateFailure(e));
    }
  }
}
