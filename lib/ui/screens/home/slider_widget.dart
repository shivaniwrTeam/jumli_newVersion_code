

import 'dart:async';

import 'package:eClassify/app/routes.dart';
import 'package:eClassify/data/cubits/slider_cubit.dart';
import 'package:eClassify/data/helper/widgets.dart';
import 'package:eClassify/data/model/category_model.dart';
import 'package:eClassify/data/model/data_output.dart';
import 'package:eClassify/data/model/item/item_model.dart';
import 'package:eClassify/data/repositories/item/item_repository.dart';
import 'package:eClassify/ui/screens/home/home_screen.dart';
import 'package:eClassify/utils/helper_utils.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart' as urllauncher;
import 'package:url_launcher/url_launcher.dart';
// Import your SliderCubit and other necessary dependencies

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget>
    with AutomaticKeepAliveClientMixin {
  final ValueNotifier<int> _bannerIndex = ValueNotifier(0);
  late Timer _timer;
  int bannersLength = 0;
  final PageController _pageController = PageController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _startAutoSlider();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerIndex.dispose();
    _timer.cancel();
    _pageController.dispose(); // Dispose the PageController
  }

  void _startAutoSlider() {
    // Set up a timer to automatically change the banner index
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      final int nextPage = _bannerIndex.value + 1;
      if (nextPage < bannersLength) {
        _bannerIndex.value = nextPage;
      } else {
        _bannerIndex.value = 0;
      }
      _pageController.animateToPage(
        _bannerIndex.value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<SliderCubit, SliderState>(
      listener: (context, state) {
        // Handle state changes if needed
      },
      builder: (context, SliderState state) {
        if (state is SliderFetchSuccess && state.sliderlist.isNotEmpty) {
          bannersLength = state.sliderlist.length; // Update bannersLength
          return SizedBox(
            height: 170,
            child: PageView.builder(
              itemCount: bannersLength,
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                _bannerIndex.value =
                    index; // Update bannerIndex when page changes manually
              },
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    if (state.sliderlist[index].thirdPartyLink != "") {
                      await urllauncher.launchUrl(
                          Uri.parse(state.sliderlist[index].thirdPartyLink!),
                          mode: LaunchMode.externalApplication);
                    } else if (state.sliderlist[index].modelType!
                        .contains("Category")) {
                      if (state.sliderlist[index].model!.subCategoriesCount! >
                          0) {
                        Navigator.pushNamed(context, Routes.subCategoryScreen,
                            arguments: {
                              "categoryList": <CategoryModel>[],
                              "catName": state.sliderlist[index].model!.name,
                              "catId": state.sliderlist[index].modelId,
                              "categoryIds": [
                                state.sliderlist[index].model!.parentCategoryId
                                    .toString(),
                                state.sliderlist[index].modelId.toString()
                              ]
                            });
                      } else {
                        Navigator.pushNamed(context, Routes.itemsList,
                            arguments: {
                              'catID':
                                  state.sliderlist[index].modelId.toString(),
                              'catName': state.sliderlist[index].model!.name,
                              "categoryIds": [
                                state.sliderlist[index].modelId.toString()
                              ]
                            });
                      }
                    } else {
                      try {
                        ItemRepository fetch = ItemRepository();

                        Widgets.showLoader(context);

                        DataOutput<ItemModel> dataOutput =
                            await fetch.fetchItemFromItemId(
                                state.sliderlist[index].modelId!);

                        Future.delayed(
                          Duration.zero,
                          () {
                            Widgets.hideLoder(context);
                            Navigator.pushNamed(context, Routes.adDetailsScreen,
                                arguments: {
                                  "model": dataOutput.modelList[0],
                                });
                          },
                        );
                      } catch (e) {
                        Widgets.hideLoder(context);
                        HelperUtils.showSnackBarMessage(context, e.toString());
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: sidePadding),
                    width: MediaQuery.of(context).size.width - 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: UiUtils.getImage(
                          state.sliderlist[index].image ?? "",
                          fit: BoxFit.fill),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
