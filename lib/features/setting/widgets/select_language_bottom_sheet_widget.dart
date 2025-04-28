import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/app_constants.dart';
import 'package:flutter_lovexa_ecommerce/utill/custom_themes.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../language/language.dart';

// int selectedIndex = 0;

class SelectLanguageBottomSheetWidget extends StatefulWidget {
  const SelectLanguageBottomSheetWidget({super.key});

  @override
  State<SelectLanguageBottomSheetWidget> createState() =>
      _SelectLanguageBottomSheetWidgetState();
}

class _SelectLanguageBottomSheetWidgetState
    extends State<SelectLanguageBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    final LanguageController langController = Get.find();

    // final SplashController splashController =
    //     Provider.of<SplashController>(context, listen: false);
    // final ProductController productController =
    //     Provider.of<ProductController>(context, listen: false);
    return Consumer<LocalizationController>(
        builder: (context, localizationProvider, _) {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 40, top: 15),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(Dimensions.paddingSizeDefault))),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: .5),
                    borderRadius: BorderRadius.circular(20))),
            const SizedBox(
              height: 40,
            ),
            Text(
              getTranslated('select_language', context)!,
              style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: Dimensions.paddingSizeSmall,
                  bottom: Dimensions.paddingSizeLarge),
              child: Text(
                  '${getTranslated('choose_your_language_to_proceed', context)}'),
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AppConstants.languages.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        setState(() {
                          langController.selectIndex.value = index;
                          print(
                              "value language :::: ${langController.selectIndex.value}");
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              Dimensions.paddingSizeDefault,
                              0,
                              Dimensions.paddingSizeDefault,
                              Dimensions.paddingSizeSmall),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeExtraSmall),
                                  color:
                                      langController.selectIndex.value == index
                                          ? Theme.of(context)
                                              .primaryColor
                                              .withValues(alpha: .1)
                                          : Theme.of(context).cardColor),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeDefault,
                                      vertical: Dimensions.paddingSizeSmall),
                                  child: Row(children: [
                                    SizedBox(
                                        width: 25,
                                        child: Image.asset(AppConstants
                                            .languages[index].imageUrl!)),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeSmall),
                                        child: Text(AppConstants
                                            .languages[index].languageName!))
                                  ])))));
                }),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Dimensions.paddingSizeSmall,
                Dimensions.paddingSizeSmall,
                Dimensions.paddingSizeSmall,
                0,
              ),
              child: CustomButton(
                  buttonText: '${getTranslated('select', context)}',
                  onTap: () {
                    // Provider.of<LocalizationController>(context, listen: false).setLanguage(Locale(
                    //     AppConstants.languages[selectedIndex].languageCode!,
                    //     AppConstants.languages[selectedIndex].countryCode));
                    // Provider.of<CategoryController>(context, listen: false).getCategoryList(true);
                    // productController.getHomeCategoryProductList(true);
                    // Provider.of<ShopController>(context, listen: false).getTopSellerList(true, 1, type: "top");
                    // Provider.of<BrandController>(context, listen: false).getBrandList(true);
                    // productController.getLatestProductList(1, reload: true);
                    // productController.getFeaturedProductList('1', reload: true);
                    // Provider.of<FeaturedDealController>(context, listen: false).getFeaturedDealList(true);
                    // productController.getLProductList('1', reload: true);
                    // Provider.of<FlashDealController>(context, listen: false).getFlashDealList(true, true);
                    // productController.getRecommendedProduct();
                    // productController.getJustForYouProduct();

                    // if(splashController.configModel?.activeTheme == "theme_fashion") {
                    //   productController.getMostSearchingProduct(1);
                    // }

                    // if (selectedIndex == 0) {
                    //   locale = Locale('en', 'US');
                    //   selectedIndex = 0;
                    // }
                    // else if (selectedIndex == 1) {
                    //   locale = Locale('ar', 'US');
                    //   selectedIndex = 1;
                    // } else if (selectedIndex == 2) {
                    //   locale = Locale('hi', 'US');
                    //   selectedIndex = 2;
                    // } else if (selectedIndex == 3) {
                    //   locale = Locale('bn', 'US');
                    //   selectedIndex = 3;
                    // } else if (selectedIndex == 4) {
                    //   locale = Locale('es', 'US');
                    //   selectedIndex = 4;
                    // }
                    if (langController.selectIndex.value == 0) {
                      langController.changeLanguage('en');
                      // locale = Locale('en', 'US');
                      // langController.selectIndex.value = 0;
                    } else {
                      langController.changeLanguage('hi');
                      // locale = Locale('hi', 'US');
                      // langController.selectIndex.value = 1;
                    }

                    // Get.updateLocale(locale);
                    // setState(() {});

                    Navigator.pop(context);
                  }),
            )
          ]),
        ),
      );
    });
  }
}
