import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/utill/images.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../theme/controllers/theme_controller.dart';
import '../../category/controllers/category_controller.dart';
import '../../category/domain/models/category_model.dart';
import '../../category/screens/category_screen.dart';
import '../../home/screens/bottomsheet.dart';
import '../../search_product/controllers/search_product_controller.dart';

class BrandAndCategoryProductScreen extends StatefulWidget {
  final bool isBrand;
  final int? id;
  final String? name;
  final String? image;
  const BrandAndCategoryProductScreen(
      {super.key,
      required this.isBrand,
      required this.id,
      required this.name,
      this.image});

  @override
  State<BrandAndCategoryProductScreen> createState() =>
      _BrandAndCategoryProductScreenState();
}

class _BrandAndCategoryProductScreenState
    extends State<BrandAndCategoryProductScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    print("brand or category id ::::::::: ${widget.id}");
    if (widget.isBrand == true) {
      Provider.of<SearchProductController>(context, listen: false)
          .brandProductApi(
              query: '', brandIds: '[${widget.id.toString()}]', offset: 1);
    } else {
      Provider.of<ProductController>(context, listen: false)
          .initBrandOrCategoryProductList(
              isBrand: widget.isBrand,
              id: widget.id,
              offset: 1,
              isUpdate: false);
    }
    super.initState();
  }

  String? title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeController>(context, listen: false).darkTheme
              ? Colors.black
              : Colors.white,
      appBar: CustomAppBar(
          reset: searchButton(context),
          showResetIcon: true,
          title: title != null ? title : widget.name),
      body: Consumer<CategoryController>(
        builder: (context, categoryProvider, child) => Row(
          children: [
            widget.isBrand == true
                ? SizedBox()
                : Container(
                    width: 80,
                    margin: const EdgeInsets.only(top: 3),
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[
                                  Provider.of<ThemeController>(context)
                                          .darkTheme
                                      ? 700
                                      : 200]!,
                              spreadRadius: 1,
                              blurRadius: 1)
                        ]),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: categoryProvider
                            .categoryList[
                                categoryProvider.categorySelectedIndex]
                            .subCategories!
                            .length,
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          SubCategory subCate = categoryProvider
                              .categoryList[
                                  categoryProvider.categorySelectedIndex]
                              .subCategories![index];
                          print(
                              " list ::::::: ${categoryProvider.categoryList[categoryProvider.categorySelectedIndex].subCategories!.length}");
                          // CategoryModel category =
                          //     categoryProvider.categoryList[index];
                          return InkWell(
                              onTap: () {
                                title = subCate.name;
                                Provider.of<ProductController>(context,
                                        listen: false)
                                    .initBrandOrCategoryProductList(
                                  isBrand: false,
                                  id: subCate.id!,
                                  offset: 1,
                                );
                                categoryProvider
                                    .changeSubCatSelectedIndex(index);

                                setState(() {});
                              },
                              child: CategoryItem(
                                  title: subCate.name,
                                  icon: subCate.image!.path,
                                  isSelected:
                                      categoryProvider.subCatSelectedIndex ==
                                          index));
                        })),
            Container(
              child: Expanded(
                child: Consumer<SearchProductController>(
                  builder: (context, searchValue, child) =>
                      Consumer<ProductController>(
                    builder: (context, productController, child) {
                      if (productController.brandOrCategoryProductList ==
                          null) {
                        return ProductShimmer(
                            isHomePage: false,
                            isEnabled:
                                productController.brandOrCategoryProductList ==
                                    null);
                      }

                      return (productController
                              .brandOrCategoryProductList!.products!.isNotEmpty)
                          ? PaginatedListView(
                              scrollController: _scrollController,
                              onPaginate: (offset) async {
                                if (widget.isBrand == true) {
                                  Provider.of<SearchProductController>(context,
                                          listen: false)
                                      .brandProductApi(
                                          query: '',
                                          brandIds: '[${widget.id.toString()}]',
                                          offset: offset!);
                                } else {
                                  await productController
                                      .initBrandOrCategoryProductList(
                                          isBrand: widget.isBrand,
                                          id: widget.id,
                                          offset: offset ?? 1);
                                }
                              },
                              limit: productController
                                  .brandOrCategoryProductList?.limit,
                              totalSize: productController
                                  .brandOrCategoryProductList?.totalSize,
                              offset: productController
                                  .brandOrCategoryProductList?.offset,
                              itemView: Expanded(
                                  child: GridView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall,
                                ).copyWith(
                                    top: Dimensions.paddingSizeExtraSmall),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      MediaQuery.of(context).size.width > 480
                                          ? 3
                                          : 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  mainAxisExtent: widget.isBrand == true
                                      ? MediaQuery.of(context).size.height / 3.3
                                      : MediaQuery.of(context).size.height /
                                          3.8,
                                  // childAspectRatio:
                                  //     0.75, // Adjust to match your design
                                ),
                                itemCount: productController
                                        .brandOrCategoryProductList
                                        ?.products
                                        ?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  return ProductWidget(
                                    productModel: productController
                                        .brandOrCategoryProductList!
                                        .products![index],
                                  );
                                },
                              )),
                            )
                          : productController.brandOrCategoryProductList == null
                              ? ProductShimmer(
                                  isHomePage: false,
                                  isEnabled: productController
                                          .brandOrCategoryProductList ==
                                      null)
                              : const NoInternetOrDataScreenWidget(
                                  isNoInternet: false,
                                  icon: Images.noProduct,
                                  message: 'no_product_found',
                                );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
