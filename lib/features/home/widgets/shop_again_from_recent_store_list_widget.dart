import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/home/widgets/shop_again_from_recent_store_widget.dart';
import 'package:provider/provider.dart';

import '../../../theme/controllers/theme_controller.dart';

class ShopAgainFromRecentStoreListWidget extends StatelessWidget {
  final bool isHome;
  const ShopAgainFromRecentStoreListWidget({super.key, this.isHome = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeController>(context, listen: false).darkTheme
              ? Colors.black
              : Colors.white,
      appBar: CustomAppBar(
        title: getTranslated('recent_store', context),
      ),
      body: Consumer<SellerProductController>(
          builder: (context, shopAgainProvider, _) {
        return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: shopAgainProvider.shopAgainFromRecentStoreList.length,
            itemBuilder: (context, index) {
              return ShopAgainFromRecentStoreWidget(
                  shopAgainFromRecentStoreModel:
                      shopAgainProvider.shopAgainFromRecentStoreList[index]);
            });
      }),
    );
  }
}
