import 'package:eClassify/utils/api.dart';
import 'package:eClassify/utils/constant.dart';
import 'package:eClassify/utils/login/lib/login_status.dart';
import 'package:eClassify/utils/login/lib/login_system.dart';
import 'package:eClassify/utils/login/lib/payloads.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneLogin extends LoginSystem {
  String? verificationId;
  String? phoneNumber;

  @override
  Future<UserCredential?> login() async {
    try {
      emit(MProgress());
      // (state);

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId ?? "",
          smsCode: (payload as PhoneLoginPayload).getOTP()!);

      UserCredential userCredential =
      await firebaseAuth.signInWithCredential(credential);

      emit(MSuccess());

      return userCredential;
    } catch (e) {
      emit(MFail(e));
    }
    return null;
  }

  @override
  Future<void> requestVerification() async {
    emit(MOtpSendInProgress());

    if (Constant.otpServiceProvider == 'twilio') {
      try {
        final twilio = await getTwilioOtp();
        super.requestVerification();
      } on ApiException catch (e) {
        emit(MFail(e.errorMessage));
      } catch (e) {
        emit(MFail("Something went wrong"));
      }
      return;
    }

    await FirebaseAuth.instance
        .verifyPhoneNumber(
      timeout: Duration(
        seconds: Constant.otpTimeOutSecond,
      ),
      phoneNumber:
      "+${(payload as PhoneLoginPayload)
          .countryCode}${(payload as PhoneLoginPayload).phoneNumber}",
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        emit(MFail(e));
      },
      codeSent: (String verificationId, int? resendToken) {
        super.requestVerification();
        forceResendingToken = resendToken;
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      forceResendingToken: forceResendingToken,
    )
        .then((value) {});
  }

  Future<Map<String, dynamic>> getTwilioOtp() async {
    phoneNumber = (payload as PhoneLoginPayload).countryCode +
        (payload as PhoneLoginPayload).phoneNumber;
    final parameters = {
      'number':
      "${(payload as PhoneLoginPayload)
          .countryCode}${(payload as PhoneLoginPayload).phoneNumber}",
    };
    final response =
    await Api.get(url: Api.getTwilioOtp, queryParameters: parameters);

    return response;
  }

  @override
  void onEvent(MLoginState state) {}
}
