import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/product_widget.dart';

import 'package:flutter_lovexa_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/utill/images.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/product_shimmer_widget.dart';

import '../../../theme/controllers/theme_controller.dart';
import '../../product/domain/models/home_category_product_model.dart';

class SubCategoryScreen extends StatefulWidget {
  final HomeCategoryProduct? homSubcat;
  final bool isBrand;
  final int? id;
  final String? name;
  final String? image;
  const SubCategoryScreen(
      {super.key,
      this.homSubcat,
      required this.isBrand,
      required this.id,
      required this.name,
      this.image});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final ScrollController _scrollController = ScrollController();

  // @override
  // void initState() {
  //   // Provider.of<ProductController>(context, listen: false)
  //   //     .initBrandOrCategoryProductList(
  //   //         isBrand: widget.isBrand, id: widget.id, offset: 1, isUpdate: false);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeController>(context, listen: false).darkTheme
              ? Colors.black
              : Colors.white,
      appBar: CustomAppBar(
        title: widget.name),
      body: Expanded(
        child: Consumer<ProductController>(
          builder: (context, productController, child) {
            print(
                ":::::::::::::::::: ${productController.brandOrCategoryProductList?.products?.length}");
            if (productController.brandOrCategoryProductList == null)
              return ProductShimmer(
                isHomePage: false,
                isEnabled: productController.brandOrCategoryProductList == null,
              );

            return (productController
                        .brandOrCategoryProductList?.products?.isNotEmpty ??
                    false)
                ? PaginatedListView(
                    scrollController: _scrollController,
                    onPaginate: (offset) async {
                      await productController.initBrandOrCategoryProductList(
                          isBrand: widget.isBrand,
                          id: widget.id,
                          offset: offset ?? 1);
                    },
                    limit: productController.brandOrCategoryProductList?.limit,
                    totalSize:
                        productController.brandOrCategoryProductList?.totalSize,
                    offset:
                        productController.brandOrCategoryProductList?.offset,
                    itemView: Expanded(
                      child: MasonryGridView.count(
                        shrinkWrap: true,
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall)
                            .copyWith(top: Dimensions.paddingSizeExtraSmall),
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 480 ? 3 : 2,
                        itemCount: widget.homSubcat?.products?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return ProductWidget(
                              productModel: widget.homSubcat!.products![index]);
                        },
                      ),
                    ),
                  )
                : productController.brandOrCategoryProductList == null
                    ? ProductShimmer(
                        isHomePage: false,
                        isEnabled:
                            productController.brandOrCategoryProductList ==
                                null)
                    : const NoInternetOrDataScreenWidget(
                        isNoInternet: false,
                        icon: Images.noProduct,
                        message: 'no_product_found',
                      );
          },
        ),
      ),
    );
  }
}

