import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/banner/domain/models/banner_model.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';

import '../../../theme/controllers/theme_controller.dart';
import '../../../utill/dimensions.dart';

class SingleBannersWidget extends StatelessWidget {
  final BannerModel? bannerModel;
  final double? height;
  final bool noRadius;
  const SingleBannersWidget(
      {super.key, this.bannerModel, this.height, this.noRadius = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<BannerController>(
          builder: (context, footerBannerProvider, child) {
            return InkWell(
                onTap: () {
                  footerBannerProvider.clickBannerRedirect(
                      context,
                      bannerModel?.resourceId,
                      bannerModel?.resourceType == 'product'
                          ? bannerModel?.product
                          : null,
                      bannerModel?.resourceType);
                },
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height:
                            height ?? MediaQuery.of(context).size.width / 2.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(noRadius
                                ? const Radius.circular(0)
                                : const Radius.circular(5))),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                                Radius.circular(noRadius ? 0 : 5)),
                            child: CustomImageWidget(
                                image:
                                    '${bannerModel?.photoFullUrl?.path}')))));
          },
        ),
      ],
    );
  }
}

class MainSectionBanner extends StatelessWidget {
  const MainSectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Column(children: [
      Consumer<BannerController>(
        builder: (context, bannerProvider, child) {
          List<BannerModel> bannerList = [];

          if ((bannerProvider.mainSectionBanner2?.length ?? 0) > 1) {
            bannerList = bannerProvider.mainSectionBanner2 ?? [];
          }

          return bannerList.length == 1
              ? SingleBannersWidget(bannerModel: bannerList[0])
              : bannerList.length > 1
                  ? Stack(
                      children: [
                        SizedBox(
                            height: width * 0.4,
                            width: width,
                            child: Column(children: [
                              SizedBox(
                                height: width * 0.33,
                                width: width,
                                child: CarouselSlider.builder(
                                  options: CarouselOptions(
                                      aspectRatio: 4 / 1,
                                      viewportFraction: 0.8,
                                      autoPlay: true,
                                      pauseAutoPlayOnTouch: true,
                                      pauseAutoPlayOnManualNavigate: true,
                                      pauseAutoPlayInFiniteScroll: true,
                                      enlargeFactor: .2,
                                      enlargeCenterPage: true,
                                      disableCenter: true,
                                      onPageChanged: (index, reason) {
                                        Provider.of<BannerController>(context,
                                                listen: false)
                                            .onChangeFooterBannerIndex(index);
                                      }),
                                  itemCount: bannerList.length,
                                  itemBuilder: (context, index, _) {
                                    return InkWell(
                                      onTap: () {
                                        if (bannerList[index].resourceId !=
                                            null) {
                                          bannerProvider.clickBannerRedirect(
                                              context,
                                              bannerList[index].resourceId,
                                              bannerList[index].resourceType ==
                                                      'product'
                                                  ? bannerList[index].product
                                                  : null,
                                              bannerList[index].resourceType);
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.paddingSizeSmall),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions
                                                            .paddingSizeSmall),
                                                color: Provider.of<ThemeController>(
                                                            context,
                                                            listen: false)
                                                        .darkTheme
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                        .withValues(alpha: .1)
                                                    : Theme.of(context)
                                                        .primaryColor
                                                        .withValues(
                                                            alpha: .05)),
                                            child: CustomImageWidget(
                                                image: '${bannerList[index].photoFullUrl?.path}')),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ])),
                        if (bannerList.isNotEmpty)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 7,
                                  width: 7,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: bannerList.map((banner) {
                                    int index = bannerList.indexOf(banner);
                                    return index ==
                                            bannerProvider.footerBannerIndex
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 6.0),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Text(
                                              "${bannerList.indexOf(banner) + 1}/ ${bannerList.length}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          )
                                        : const SizedBox();
                                  }).toList(),
                                ),
                                Container(
                                  height: 7,
                                  width: 7,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    )
                  : const SizedBox();
        },
      ),
      const SizedBox(height: 5),
    ]);
  }
}
