import 'dart:async';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:device_region/device_region.dart';
import 'package:eClassify/app/app_theme.dart';
import 'package:eClassify/app/routes.dart';
import 'package:eClassify/data/cubits/auth/authentication_cubit.dart';
import 'package:eClassify/data/cubits/system/app_theme_cubit.dart';
import 'package:eClassify/data/helper/widgets.dart';

import 'package:eClassify/ui/theme/theme.dart';
import 'package:eClassify/utils/api.dart';
import 'package:eClassify/utils/app_icon.dart';
import 'package:eClassify/utils/constant.dart';
import 'package:eClassify/utils/custom_text.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:eClassify/utils/helper_utils.dart';
import 'package:eClassify/utils/login/lib/login_status.dart';
import 'package:eClassify/utils/login/lib/payloads.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';

class MobileSignUpScreen extends StatefulWidget {
  final String? mobile;
  final String? countryCode;

  const MobileSignUpScreen({super.key, this.mobile, this.countryCode});

  @override
  State<MobileSignUpScreen> createState() => MobileSignUpScreenState();

  static MaterialPageRoute route(RouteSettings routeSettings) {
    Map? args = routeSettings.arguments as Map?;
    return MaterialPageRoute(
        builder: (_) => MobileSignUpScreen(
              mobile: args?['mobile'],
              countryCode: args?['countryCode'],
            ));
  }
}

class MobileSignUpScreenState extends State<MobileSignUpScreen> {
  // final TextEditingController mobileTextController = TextEditingController();
  bool isOtpSent = false;
  String? phone, otp, countryName, flagEmoji;
  bool isResendEnabled = false;
  int _start = 60;
  Timer? _resendTimer;
  late Size size;
  CountryService countryCodeService = CountryService();
  bool isLoginButtonDisabled = true;
  final _formKey = GlobalKey<FormState>();

  //TextEditingController _otpController = TextEditingController();

  bool isObscure = true;
  late PhoneLoginPayload phoneLoginPayload =
      PhoneLoginPayload(widget.mobile!, widget.countryCode!);
  bool isBack = false;
  String signature = "";

  @override
  void initState() {
    super.initState();
    getSignature();

    context.read<AuthenticationCubit>().init();
    context.read<AuthenticationCubit>().listen((MLoginState state) {
      if (state is MFail) {
        Widgets.hideLoder(context);
        //}
      }
    });
  }

  void startResendOtpTimer() {
    setState(() {
      _start = 60;
      isResendEnabled = false;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          isResendEnabled = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> getSignature() async {
    signature = await SmsAutoFill().getAppSignature;
    SmsAutoFill().listenForCode;
    setState(() {});
  }

  /// it will return user's sim cards country code
  Future<Country> getSimCountry() async {
    List<Country> countryList = countryCodeService.getAll();
    String? simCountryCode;

    try {
      simCountryCode = await DeviceRegion.getSIMCountryCode();
    } catch (e) {}

    Country simCountry = countryList.firstWhere(
      (element) {
        if (Constant.isDemoModeOn) {
          return countryList.any(
            (element) => element.phoneCode == Constant.defaultCountryCode,
          );
        } else {
          return element.phoneCode == simCountryCode;
        }
      },
      orElse: () {
        return countryList
            .where(
              (element) => element.phoneCode == Constant.defaultCountryCode,
            )
            .first;
      },
    );

    if (Constant.isDemoModeOn) {
      simCountry = countryList
          .where((element) => element.phoneCode == Constant.demoCountryCode)
          .first;
    }

    return simCountry;
  }

  @override
  void dispose() {
    _resendTimer?.cancel();

    //mobileTextController.dispose();
    SmsAutoFill().unregisterListener();

    super.dispose();
  }

  void _onTapContinue() {
    phoneLoginPayload = PhoneLoginPayload(widget.mobile!, widget.countryCode!);

    context
        .read<AuthenticationCubit>()
        .setData(payload: phoneLoginPayload, type: AuthenticationType.phone);
    context.read<AuthenticationCubit>().verify();
    isOtpSent = true;
    startResendOtpTimer();

    setState(() {});
  }

  Future<void> sendVerificationCode() async {
    final form = _formKey.currentState;

    if (form == null) return;
    form.save();
    //checkbox value should be 1 before Login/SignUp
    if (form.validate()) {
      _onTapContinue();
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(
        context: context,
        statusBarColor: context.color.backgroundColor,
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: PopScope(
            canPop: isBack,
            onPopInvokedWithResult: (didPop, result) {
              if (isOtpSent) {
                setState(() {
                  isOtpSent = false;
                });
              } else {
                setState(() {
                  isBack = true;
                });
                return;
              }

              setState(() {
                isBack = false;
              });
              return;
            },
            child: AnnotatedRegion(
              value: SystemUiOverlayStyle(
                statusBarColor: context.color.backgroundColor,
              ),
              child: Scaffold(
                backgroundColor: context.color.backgroundColor,
                bottomNavigationBar:
                    !isOtpSent ? termAndPolicyTxt() : SizedBox.shrink(),
                body: Builder(builder: (context) {
                  return Form(
                    key: _formKey,
                    child: isOtpSent ? verifyOTPWidget() : buildLoginWidget(),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailSignUp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 36,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText("signupWithLbl".translate(context),
                color: context.color.textColorDark.withValues(alpha: 0.7)),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.signupMainScreen);
              },
              child: CustomText(
                "emailLbl".translate(context),
                color: context.color.territoryColor,
                showUnderline: true,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildLoginWidget() {
    return SingleChildScrollView(
      child: SizedBox(
        height: context.screenHeight - 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: FittedBox(
                    fit: BoxFit.none,
                    child: MaterialButton(
                      onPressed: () {
                        HelperUtils.killPreviousPages(context, Routes.main,
                            {"from": "login", "isSkipped": true});
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      color: context.color.forthColor.withValues(alpha: 0.102),
                      elevation: 0,
                      height: 28,
                      minWidth: 64,
                      child: CustomText(
                        "skip".translate(context),
                        color: context.color.forthColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 66,
              ),
              CustomText(
                "welcome".translate(context),
                fontSize: context.font.extraLarge,
                color: context.color.textDefaultColor,
              ),
              const SizedBox(
                height: 8,
              ),
              CustomText(
                "signUpToeClassify".translate(context),
                fontSize: context.font.large,
                color: context.color.textColorDark,
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 18),
                decoration: BoxDecoration(
                    color: context.color.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: context.color.textLightColor
                            .withValues(alpha: 0.18))),
                child: Row(
                  children: [
                    // Display the country code as text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomText(
                        "+${widget.countryCode}",
                        fontSize: context.font.large,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: CustomText(
                        widget.mobile!,
                        fontSize: context.font.large,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 46,
              ),
              UiUtils.buildButton(context,
                  onPressed: sendVerificationCode,
                  buttonTitle: "verifyMobileNumberLbl".translate(context),
                  radius: 10,
                  disabledColor: const Color.fromARGB(255, 104, 102, 106)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (Constant.emailAuthentication == '1') emailSignUp(),
                  if (Constant.googleAuthentication == "1" ||
                      Constant.appleAuthentication == "1")
                    googleAndAppleAuth(),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText("alreadyHaveAcc".translate(context),
                          color: context.color.textColorDark
                              .withValues(alpha: 0.7)),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.login);
                        },
                        child: CustomText(
                          "login".translate(context),
                          showUnderline: true,
                          color: context.color.territoryColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget googleAndAppleAuth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 24,
        ),
        if (Constant.googleAuthentication == "1")
          UiUtils.buildButton(context,
              prefixWidget: Padding(
                padding: EdgeInsetsDirectional.only(end: 10.0),
                child:
                    UiUtils.getSvg(AppIcons.googleIcon, width: 22, height: 22),
              ),
              showElevation: false,
              buttonColor: secondaryColor_,
              border: context.watch<AppThemeCubit>().state.appTheme !=
                      AppTheme.dark
                  ? BorderSide(
                      color:
                          context.color.textDefaultColor.withValues(alpha: 0.5))
                  : null,
              textColor: textDarkColor, onPressed: () {
            context.read<AuthenticationCubit>().setData(
                payload: GoogleLoginPayload(), type: AuthenticationType.google);
            context.read<AuthenticationCubit>().authenticate();
          },
              radius: 8,
              height: 46,
              buttonTitle: "continueWithGoogle".translate(context)),
        if (Constant.appleAuthentication == "1" && Platform.isIOS) ...[
          const SizedBox(
            height: 12,
          ),
          UiUtils.buildButton(context,
              prefixWidget: Padding(
                padding: EdgeInsetsDirectional.only(end: 10.0),
                child:
                    UiUtils.getSvg(AppIcons.appleIcon, width: 22, height: 22),
              ),
              showElevation: false,
              buttonColor: secondaryColor_,
              border: context.watch<AppThemeCubit>().state.appTheme !=
                      AppTheme.dark
                  ? BorderSide(
                      color:
                          context.color.textDefaultColor.withValues(alpha: 0.5))
                  : null,
              textColor: textDarkColor, onPressed: () {
            context.read<AuthenticationCubit>().setData(
                payload: AppleLoginPayload(), type: AuthenticationType.apple);
            context.read<AuthenticationCubit>().authenticate();
          },
              height: 46,
              radius: 8,
              buttonTitle: "continueWithApple".translate(context)),
        ]
      ],
    );
  }

  Widget termAndPolicyTxt() {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 20.0, start: 25.0, end: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText("bySigningUpLoggingIn".translate(context),
              color: context.color.textLightColor.withValues(alpha: 0.8),
              fontSize: context.font.small,
              textAlign: TextAlign.center),
          const SizedBox(
            height: 3,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
                child: CustomText(
                  "termsOfService".translate(context),
                  showUnderline: true,
                  color: context.color.territoryColor,
                  fontSize: context.font.small,
                ),
                onTap: () => Navigator.pushNamed(
                        context, Routes.profileSettings, arguments: {
                      'title': "termsConditions".translate(context),
                      'param': Api.termsAndConditions
                    })),
            const SizedBox(
              width: 5.0,
            ),
            CustomText(
              "andTxt".translate(context),
              color: context.color.textLightColor.withValues(alpha: 0.8),
              fontSize: context.font.small,
            ),
            const SizedBox(
              width: 5.0,
            ),
            InkWell(
                child: CustomText(
                  "privacyPolicy".translate(context),
                  showUnderline: true,
                  color: context.color.territoryColor,
                  fontSize: context.font.small,
                ),
                onTap: () => Navigator.pushNamed(
                        context, Routes.profileSettings, arguments: {
                      'title': "privacyPolicy".translate(context),
                      'param': Api.privacyPolicy
                    })),
          ]),
        ],
      ),
    );
  }

  Widget otpInput() {
    return Center(
        child: PinFieldAutoFill(
            decoration: UnderlineDecoration(
              textStyle:
                  TextStyle(fontSize: 20, color: context.color.textColorDark),
              colorBuilder: FixedColorBuilder(context.color.territoryColor),
            ),
            currentCode: otp,
            codeLength: 6,
            onCodeChanged: (String? code) {
              otp = code;
            },
            onCodeSubmitted: (String code) {
              otp = code;
            }));
  }

  Widget verifyOTPWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: FittedBox(
                fit: BoxFit.none,
                child: MaterialButton(
                    onPressed: () {
                      HelperUtils.killPreviousPages(context, Routes.main,
                          {"from": "login", "isSkipped": true});
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    color: context.color.forthColor.withValues(alpha: 0.102),
                    elevation: 0,
                    height: 28,
                    minWidth: 64,
                    child: CustomText(
                      "skip".translate(context),
                      color: context.color.forthColor,
                    )),
              ),
            ),
          ),
          const SizedBox(
            height: 66,
          ),
          CustomText(
            "signInWithMob".translate(context),
            fontSize: context.font.extraLarge,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              CustomText(
                "+${phoneLoginPayload.countryCode}\t${phoneLoginPayload.phoneNumber}",
                fontSize: context.font.large,
              ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                  child: CustomText(
                    "change".translate(context),
                    showUnderline: true,
                    color: context.color.territoryColor,
                    fontSize: context.font.large,
                  ),
                  onTap: () => Navigator.pushNamed(context, Routes.login)),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          otpInput(),
          const SizedBox(
            height: 8,
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: isResendEnabled
                ? MaterialButton(
                    onPressed: () {
                      context.read<AuthenticationCubit>().setData(
                            payload: phoneLoginPayload,
                            type: AuthenticationType.phone,
                          );
                      context.read<AuthenticationCubit>().verify();
                      startResendOtpTimer();
                    },
                    child: CustomText("resendOTP".translate(context),
                        color: context.color.territoryColor),
                  )
                : CustomText(
                    "${"resendOtpIn".translate(context)} 0:${_start.toString().padLeft(2, '0')}",
                    color: context.color.textColorDark.withValues(alpha: 0.7),
                  ),
          ),
          const SizedBox(
            height: 19,
          ),
          UiUtils.buildButton(
            context,
            onPressed: () {
              if (otp!.trim().length < 6) {
                HelperUtils.showSnackBarMessage(
                    context, "pleaseEnterSixDigits".translate(context));
              } else {
                phoneLoginPayload.setOTP(otp!.trim());
                context.read<AuthenticationCubit>().authenticate();
              }
              //}
            },
            buttonTitle: "signIn".translate(context),
            radius: 8,
          ),
        ],
      ),
    );
  }
}
