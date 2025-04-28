import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/widgets/flash_deals_list_widget.dart';
import 'package:provider/provider.dart';

import '../../../theme/controllers/theme_controller.dart';

class FlashDealScreenView extends StatefulWidget {
  const FlashDealScreenView({super.key});
  @override
  State<FlashDealScreenView> createState() => _FlashDealScreenViewState();
}

class _FlashDealScreenViewState extends State<FlashDealScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Provider.of<ThemeController>(context, listen: false).darkTheme
                ? Colors.black
                : Colors.white,
        body: Column(children: [
          // CustomAppBar(title: getTranslated('flash_deal', context)?.toUpperCase()),

          SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: TitleRowWidget(
                      title:
                          getTranslated('flash_deal', context)?.toUpperCase(),
                      eventDuration:
                          Provider.of<FlashDealController>(context).duration,
                      isFlash: true,
                      isBackExist: true),
                )),
          ),
          Expanded(
              child: RefreshIndicator(
                  onRefresh: () async => await Provider.of<FlashDealController>(
                          context,
                          listen: false)
                      .getFlashDealList(true, false),
                  child:  Padding(
                      padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: FlashDealsListWidget(isHomeScreen: false))))
        ]));
  }
}
