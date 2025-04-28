import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_lovexa_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/slider_product_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/home/shimmers/flash_deal_shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utill/dimensions.dart';
import '../../home/widgets/featured_product_widget.dart';

class FlashDealsListWidget extends StatelessWidget {
  final bool isHomeScreen;
  FlashDealsListWidget({super.key, this.isHomeScreen = true});

  final featuredController = Get.put(FlashSellingProductController());
  @override
  Widget build(BuildContext context) {
    return isHomeScreen
        ? Consumer<FlashDealController>(
            builder: (context, flashDealController, child) {
            return flashDealController.flashDeal != null
                ? flashDealController.flashDealList.isNotEmpty
                    ? SizedBox(
                        height: ResponsiveHelper.isTab(context)
                            ? MediaQuery.of(context).size.width * .58
                            : MediaQuery.of(context).size.height / 3.8,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemExtent: 130,
                          shrinkWrap: true,
                          controller: featuredController.scrollController,
                          itemCount: flashDealController.flashDealList.isEmpty
                              ? 1
                              : flashDealController.flashDealList.length,
                          itemBuilder: (context, index) {
                            featuredController.productList.value =
                                flashDealController.flashDealList;
                            return SliderProductWidget(
                                product:
                                    flashDealController.flashDealList[index],
                                isCurrentIndex:
                                    index == flashDealController.currentIndex);
                          },
                        ),

                        // CarouselSlider.builder(
                        //   options: CarouselOptions(
                        //     viewportFraction:
                        //         ResponsiveHelper.isTab(context) ? .5 : .33,
                        //     autoPlay: true,
                        //     pauseAutoPlayOnTouch: true,
                        //     pauseAutoPlayOnManualNavigate: true,
                        //     enlargeFactor: 0.3,

                        //     // aspectRatio: 9.3,
                        //     // height: 25,
                        //     // enlargeCenterPage: true,
                        //     pauseAutoPlayInFiniteScroll: true,
                        //     // disableCenter: true,
                        //     onPageChanged: (index, reason) =>
                        //         flashDealController.setCurrentIndex(index),
                        //   ),
                        //   itemCount: flashDealController.flashDealList.isEmpty
                        //       ? 1
                        //       : flashDealController.flashDealList.length,
                        //   itemBuilder: (context, index, next) {
                        //     return SliderProductWidget(
                        //         product:
                        //             flashDealController.flashDealList[index],
                        //         isCurrentIndex:
                        //             index == flashDealController.currentIndex);
                        //   },
                        // ),
                      )
                    : const SizedBox()
                : const FlashDealShimmer();
          })
        : Consumer<FlashDealController>(
            builder: (context, flashDealController, child) {
              return flashDealController.flashDealList.isNotEmpty
                  ? RepaintBoundary(
                      child: GridView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      // controller: _scrollController,
                      padding: const EdgeInsets.symmetric()
                          .copyWith(top: Dimensions.paddingSizeExtraSmall),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 480 ? 3 : 2,
                        mainAxisExtent:
                            MediaQuery.of(context).size.height / 3.1,
                      ),
                      itemCount: flashDealController.flashDealList.length,
                      itemBuilder: (context, index) {
                        return ProductWidget(
                            productModel:
                                flashDealController.flashDealList[index]);
                      },
                    )
                      // MasonryGridView.count(
                      //   itemCount: flashDealController.flashDealList.length,
                      //   padding: const EdgeInsets.all(0),
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return ProductWidget(
                      //         productModel:
                      //             flashDealController.flashDealList[index]);
                      //   },
                      //   crossAxisCount: 2,
                      // ),
                      )
                  : const Center(child: CircularProgressIndicator());
            },
          );
  }
}
