import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_lovexa_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/widgets/featured_deal_list_widget.dart';
import 'package:provider/provider.dart';

class FeaturedDealScreenView extends StatelessWidget {
  const FeaturedDealScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Provider.of<ThemeController>(context, listen: false).darkTheme
                ? Colors.black
                : Colors.white,
        body: Column(children: [
          CustomAppBar(title: getTranslated('featured_deals', context)),
          Expanded(
              child: RefreshIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                  onRefresh: () async =>
                      await Provider.of<FeaturedDealController>(context,
                              listen: false)
                          .getFeaturedDealList(true),
                  child: const Padding(
                      padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: FeaturedDealsListWidget(isHomePage: false))))
        ]));
  }
}
