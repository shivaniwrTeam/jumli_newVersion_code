import 'dart:io';

import 'package:eClassify/data/cubits/subscription/bank_transfer_update_cubit.dart';
import 'package:eClassify/data/cubits/utility/fetch_transactions_cubit.dart';
import 'package:eClassify/data/helper/widgets.dart';
import 'package:eClassify/data/model/transaction_model.dart';
import 'package:eClassify/ui/screens/widgets/errors/no_data_found.dart';
import 'package:eClassify/ui/screens/widgets/errors/something_went_wrong.dart';
import 'package:eClassify/ui/screens/widgets/intertitial_ads_screen.dart';
import 'package:eClassify/ui/theme/theme.dart';
import 'package:eClassify/utils/constant.dart';
import 'package:eClassify/utils/custom_text.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:eClassify/utils/helper_utils.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  static Route route(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return const TransactionHistory();
      },
    );
  }

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  late final ScrollController _pageScrollController = ScrollController();
  File? receiptImage;
  bool isUploading = false;

  @override
  void initState() {
    AdHelper.loadInterstitialAd();
    context.read<FetchTransactionsCubit>().fetchTransactions();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void showPicker(String transactionId) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10)),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: CustomText("gallery".translate(context)),
                    onTap: () {
                      _imgFromGallery(ImageSource.gallery, transactionId);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: CustomText("camera".translate(context)),
                  onTap: () {
                    _imgFromGallery(ImageSource.camera, transactionId);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _imgFromGallery(ImageSource imageSource, String transactionId) async {
    if (isUploading) return; // Prevent multiple selections while uploading

    final pickedFile =
        await ImagePicker().pickImage(source: imageSource, imageQuality: 75);

    if (pickedFile != null) {
      receiptImage = File(pickedFile.path);

      isUploading = true; // Set flag to true before API call
      setState(() {}); // Update UI

      context.read<BankTransferUpdateCubit>().bankTransferUpdate(
          paymentTransactionId: transactionId, paymentReceipt: receiptImage!);
    } else {
      receiptImage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    AdHelper.showInterstitialAd();
    return Scaffold(
      backgroundColor: context.color.backgroundColor,
      appBar: UiUtils.buildAppBar(context,
          showBackButton: true, title: "transactionHistory".translate(context)),
      body: RefreshIndicator(
        color: context.color.territoryColor,
        onRefresh: () async {
          context.read<FetchTransactionsCubit>().fetchTransactions();
        },
        child: BlocListener<BankTransferUpdateCubit, BankTransferUpdateState>(
          listener: (context, state) {
            if (state is BankTransferUpdateInSuccess) {
              isUploading = false; // Reset flag after upload completes
              setState(() {});

              context
                  .read<FetchTransactionsCubit>()
                  .updateTransactionStatus(state.transactionId);
              Widgets.hideLoder(context);
              HelperUtils.showSnackBarMessage(context, state.responseMessage);
            }
            if (state is BankTransferUpdateFailure) {
              isUploading = false; // Reset flag after upload completes
              setState(() {});
              Widgets.hideLoder(context);
              HelperUtils.showSnackBarMessage(context, state.error.toString());
            }
            if (state is BankTransferUpdateInProgress) {
              Widgets.showLoader(context);
            }
          },
          child: BlocBuilder<FetchTransactionsCubit, FetchTransactionsState>(
            builder: (context, state) {
              if (state is FetchTransactionsInProgress) {
                return Center(
                  child: UiUtils.progress(),
                );
              }
              if (state is FetchTransactionsFailure) {
                return const SomethingWentWrong();
              }
              if (state is FetchTransactionsSuccess) {
                if (state.transactionModel.isEmpty) {
                  return NoDataFound(
                    onTap: () {
                      context
                          .read<FetchTransactionsCubit>()
                          .fetchTransactions();
                    },
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _pageScrollController,
                        itemCount: state.transactionModel.length,
                        itemBuilder: (context, index) {
                          TransactionModel transaction =
                              state.transactionModel[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 7.0, horizontal: 16),
                            child: Container(
                                // height: 100,
                                decoration: BoxDecoration(
                                    color: context.color.secondaryColor,
                                    border: Border.all(
                                        color: context.color.borderColor,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: customTransactionItem(
                                    context, transaction)),
                          );
                        },
                      ),
                    ),
                    if (state.isLoadingMore) UiUtils.progress()
                  ],
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget customTransactionItem(
      BuildContext context, TransactionModel transaction) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 16, 12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 41,
              decoration: BoxDecoration(
                color: context.color.territoryColor,
                borderRadius: const BorderRadiusDirectional.only(
                  topEnd: Radius.circular(4),
                  bottomEnd: Radius.circular(4),
                ),
              ),
              // padding: const EdgeInsets.symmetric(vertical: 2.0),
              // margin: EdgeInsets.all(4),
              // height:,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: context.color.territoryColor
                            .withValues(alpha: 0.1)),
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                    child: CustomText(
                      transaction.paymentGateway!,
                      fontSize: context.font.small,
                      color: context.color.territoryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 2,
                        child: CustomText(
                          transaction.orderId != null
                              ? transaction.orderId.toString()
                              : "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(width: 7),
                      GestureDetector(
                        onTap: () async {
                          await HapticFeedback.vibrate();
                          var clipboardData =
                              ClipboardData(text: transaction.orderId ?? "");
                          Clipboard.setData(clipboardData).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    CustomText("copied".translate(context)),
                              ),
                            );
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: context.color.secondaryColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: context.color.borderColor,
                                  width: 1.5)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.copy,
                              size: context.font.larger,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    transaction.createdAt.toString().formatDate(),
                    fontSize: context.font.small,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  "${Constant.currencySymbol}\t${transaction.amount}",
                  fontWeight: FontWeight.w700,
                  color: context.color.territoryColor,
                ),
                const SizedBox(
                  height: 6,
                ),
                statusAndAttachment(transaction)
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget statusAndAttachment(TransactionModel transaction) {
    if (transaction.paymentGateway == "BankTransfer" &&
        transaction.paymentStatus == 'pending')
      return UiUtils.buildButton(context, onPressed: () {
        if (isUploading) {
          return;
        } else {
          showPicker(transaction.id.toString());
        }
      },
          buttonTitle: "uploadReceipt".translate(context),
          width: 30,
          height: 35,
          fontSize: 12,
          radius: 5,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5));
    else
      return CustomText(transaction.paymentStatus!.toString().firstUpperCase());
  }
}
