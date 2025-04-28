import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/product/domain/models/product_model.dart';

import 'package:flutter_lovexa_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_lovexa_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/product_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../home/widgets/featured_product_widget.dart';

class BestSellingScreen extends StatelessWidget {
  final bool isHomePage;
  final ProductType productType;
  // final ScrollController? scrollController;

  BestSellingScreen({
    super.key,
    required this.isHomePage,
    required this.productType,
    // this.scrollController
  });

  // final ScrollController _scrollController = ScrollController();
  final featuredController = Get.put(BestSellingProductController());

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, prodProvider, child) {
        List<Product>? productList = [];

        if (productType == ProductType.latestProduct) {
          productList = prodProvider.lProductList;
        } else if (productType == ProductType.featuredProduct) {
          productList = prodProvider.featuredProductList;
        } else if (productType == ProductType.topProduct) {
          productList = prodProvider.latestProductList;
        } else if (productType == ProductType.bestSelling) {
          productList = prodProvider.latestProductList;
        } else if (productType == ProductType.newArrival) {
          productList = prodProvider.latestProductList;
        } else if (productType == ProductType.justForYou) {
          productList = prodProvider.justForYouProduct;
        }

        return Column(children: [
          // (productList != null && productList.isNotEmpty)
          //     ?
          //     : SizedBox(),
          !prodProvider.filterFirstLoading
              ? (productList != null && productList.isNotEmpty)
                  ? Container(
                      height: ResponsiveHelper.isTab(context)
                          ? MediaQuery.of(context).size.width * .58
                          : MediaQuery.of(context).size.height / 3.8,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemExtent: 130,
                        shrinkWrap: true,
                        controller: featuredController.scrollController,
                        itemCount: isHomePage
                            ? productList.length > 4
                                ? 4
                                : productList.length
                            : productList.length,
                        itemBuilder: (context, index) {
                          featuredController.productList.value = productList!;
                          // productList = productController.featuredProductList!;
                          return ProductWidget(
                              productModel: productList[index]);
                        },
                      ),
                    )
                  : SizedBox(




                    
                    
                  )
              // const NoInternetOrDataScreenWidget (isNoInternet: false)
              : ProductShimmer(
                  isHomePage: isHomePage, isEnabled: prodProvider.firstLoading),
          // prodProvider.filterIsLoading
          //     ? Center(
          //         child: Padding(
          //         padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
          //         child: CircularProgressIndicator(
          //             valueColor: AlwaysStoppedAnimation<Color>(
          //                 Theme.of(context).primaryColor)),
          //       ))
          //     : const SizedBox.shrink()
        ]);
      },
    );
  }
}
