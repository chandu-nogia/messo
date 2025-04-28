import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_lovexa_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../utill/dimensions.dart';

class ShopFeaturedProductViewList extends StatefulWidget {
  final ScrollController scrollController;
  final int sellerId;
  const ShopFeaturedProductViewList(
      {super.key, required this.scrollController, required this.sellerId});

  @override
  State<ShopFeaturedProductViewList> createState() =>
      _ShopFeaturedProductViewListState();
}

class _ShopFeaturedProductViewListState
    extends State<ShopFeaturedProductViewList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SellerProductController>(
        builder: (context, productController, _) {
      return productController.sellerWiseFeaturedProduct != null
          ? (productController.sellerWiseFeaturedProduct!.products != null &&
                  productController
                      .sellerWiseFeaturedProduct!.products!.isNotEmpty)
              ? PaginatedListView(
                  scrollController: widget.scrollController,
                  onPaginate: (offset) async =>
                      await productController.getSellerProductList(
                          widget.sellerId.toString(), offset!, ""),
                  totalSize:
                      productController.sellerWiseFeaturedProduct?.totalSize,
                  offset: productController.sellerWiseFeaturedProduct?.offset,
                  itemView: RepaintBoundary(
                      child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall,
                    ).copyWith(top: Dimensions.paddingSizeExtraSmall),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 480 ? 3 : 2,
                      mainAxisExtent: MediaQuery.of(context).size.height / 3.4,
                    ),
                    itemCount: productController
                        .sellerWiseFeaturedProduct?.products?.length,
                    itemBuilder: (context, index) {
                      return ProductWidget(
                          productModel: productController
                              .sellerWiseFeaturedProduct!.products![index]);
                    },
                  )
                      // MasonryGridView.count(
                      //   itemCount: productController.sellerWiseFeaturedProduct?.products?.length,
                      //   crossAxisCount: ResponsiveHelper.isTab(context)? 3: 2,
                      //   padding: const EdgeInsets.all(0),
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   shrinkWrap: true,
                      //   itemBuilder: (BuildContext context, int index) => ProductWidget(productModel: productController.sellerWiseFeaturedProduct!.products![index]),
                      // ),

                      ))
              : const SizedBox()
          : ProductShimmer(
              isEnabled: productController.sellerWiseFeaturedProduct == null,
              isHomePage: false);
    });
  }
}
