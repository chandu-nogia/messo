import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/slider_product_shimmer_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/product/screens/view_all_product_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/paginated_list_view_widget.dart';
import '../../../common/basewidget/product_filter_dialog_widget.dart';
import '../../../common/basewidget/product_widget.dart';
import '../../../common/basewidget/scrollbar_widget.dart';
import '../../../common/basewidget/show_custom_snakbar_widget.dart';
import '../../../localization/language_constrants.dart';
import '../../../main.dart';
import '../../../theme/controllers/theme_controller.dart';
import '../../../utill/custom_themes.dart';
import '../../brand/controllers/brand_controller.dart';
import '../../brand/domain/models/brand_model.dart';
import '../../category/controllers/category_controller.dart';
import '../../category/domain/models/category_model.dart';
import '../../home/screens/home_screens.dart';
import '../../home/screens/product_for_you.dart';
import '../../product_details/controllers/product_details_controller.dart';
import '../../search_product/controllers/search_product_controller.dart';
import '../../search_product/widgets/search_filter_bottom_sheet_widget.dart';
import '../domain/models/product_model.dart';
import 'products_list_widget.dart';

class LatestProductListWidget extends StatefulWidget {
  const LatestProductListWidget({super.key});

  @override
  State<LatestProductListWidget> createState() =>
      _LatestProductListWidgetState();
}

class _LatestProductListWidgetState extends State<LatestProductListWidget> {
  // @override
  // void initState() {
  //   Provider.of<ProductController>(context, listen: false)
  //       .getLatestProductListApis(1);
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(builder: (context, prodProvider, child) {
      List<Product>? productList = [];
      productList = prodProvider.latestProductList;
      return (prodProvider.latestProductList?.isNotEmpty ?? false)
          ? Column(children: [
              TitleRowWidget(
                // title: getTranslated('latest_products', context),
                title:
                    homeTitleModel.latestProductsHeading ?? "Latest Products",
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AllProductScreen(
                            productType: ProductType.latestProduct))),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),

                shrinkWrap: true,
                // controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                ).copyWith(top: Dimensions.paddingSizeExtraSmall),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 480 ? 3 : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: MediaQuery.of(context).size.height / 3.3,
                  // childAspectRatio:
                  //     0.75, // Adjust to match your design
                ),
                itemCount: productList!.length > 10 ? 10 : productList.length,
                itemBuilder: (context, index) {
                  return ProductWidget(
                    productModel: productList![index],
                  );
                },
              )
              // ProductListWidget(
              //   isHomePage: false,
              //   productType: ProductType.latestProduct,
              //   // scrollController: _scrollController
              // )
            ])
          : prodProvider.latestProductList == null
              ? const SliderProductShimmerWidget()
              : const SizedBox();
    });
  }
}

String? selectedCategory;
// filter_for_you() {
//   // final FeatchController productController = Get.put(FeatchController());
//   return Container(
//     height: 40,
//     decoration: BoxDecoration(
//       color:
//           Provider.of<ThemeController>(GetCtx.context!, listen: false).darkTheme
//               ? Color.fromARGB(255, 41, 41, 41)
//               : Colors.white,
//       boxShadow: [
//         BoxShadow(
//           color: Provider.of<ThemeController>(GetCtx.context!, listen: false)
//                   .darkTheme
//               ? Colors.black
//               : const Color.fromARGB(255, 212, 212, 212).withOpacity(0.5),
//           spreadRadius: 1,
//           blurRadius: 5,
//           offset: Offset(0, 3),
//         ),
//       ],
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         InkWell(
//           onTap: () {
//             showModalBottomSheet(
//                 context: GetCtx.context!,
//                 isScrollControlled: true,
//                 backgroundColor:
//                     Provider.of<ThemeController>(GetCtx.context!, listen: false)
//                             .darkTheme
//                         ? Colors.black
//                         : Colors.white,
//                 builder: (context) => SearchFilterBottomSheet()
//                 // SortByWidget()
//                 );
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Sort', style: TextStyle(fontSize: 14)),
//               SizedBox(width: 5),
//               Icon(Icons.sort),
//             ],
//           ),
//         ),
//         Container(color: Colors.grey, width: 0.1),
//         Consumer<ProductDetailsController>(
//           builder: (context, details, child) => InkWell(
//             onTap: () {
//               showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       backgroundColor:
//                           Provider.of<ThemeController>(context, listen: false)
//                                   .darkTheme
//                               ? Colors.black
//                               : Colors.white,
//                       builder: (context) =>
//                           ProductFilterDialog(fromShop: false))
//                   .then((selectedCategory) {
//                 if (selectedCategory != null) {
//                   // Handle selected category after closing the modal

//                   print("Selected Category: $selectedCategory");
//                 }
//               });
//             },
//             child: const Row(
//               children: [
//                 Text(
//                   'Category ',
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 Icon(Icons.keyboard_arrow_down, size: 20),
//               ],
//             ),
//           ),
//         ),
//         Container(color: Colors.grey, width: 0.1),
//         InkWell(
//             onTap: () {
//               showModalBottomSheet(
//                   context: GetCtx.context!,
//                   isScrollControlled: true,
//                   backgroundColor: Provider.of<ThemeController>(GetCtx.context!,
//                               listen: false)
//                           .darkTheme
//                       ? Colors.black
//                       : Colors.white,
//                   builder: (context) => brandSelectedfn());
//             },
//             child: const Row(
//               children: const [
//                 Text('Brand', style: TextStyle(fontSize: 14)),
//                 Icon(Icons.keyboard_arrow_down, size: 20),
//               ],
//             )),
//       ],
//     ),
//   );
// }
filter_for_you() {
  return Container(
    height: 40,
    decoration: BoxDecoration(
      color:
          Provider.of<ThemeController>(GetCtx.context!, listen: false).darkTheme
              ? Color.fromARGB(255, 41, 41, 41)
              : Colors.white,
      boxShadow: [
        BoxShadow(
          color: Provider.of<ThemeController>(GetCtx.context!, listen: false)
                  .darkTheme
              ? Colors.black
              : const Color.fromARGB(255, 212, 212, 212).withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: GetCtx.context!,
                isScrollControlled: true,
                backgroundColor:
                    Provider.of<ThemeController>(GetCtx.context!, listen: false)
                            .darkTheme
                        ? Colors.black
                        : Colors.white,
                builder: (context) => SearchFilterBottomSheet(value: true),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sort', style: TextStyle(fontSize: 14)),
                SizedBox(width: 5),
                Icon(Icons.sort),
              ],
            ),
          ),
        ),
        Container(color: Colors.grey, width: 0.5, height: 20),
        Expanded(
          child: Consumer<ProductDetailsController>(
            builder: (context, details, child) => InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor:
                        Provider.of<ThemeController>(context, listen: false)
                                .darkTheme
                            ? Colors.black
                            : Colors.white,
                    builder: (context) => categoryFilter()
                    // ProductForYouFilterDialog(
                    //   fromShop: false,
                    //   value: true,
                    // ),
                    ).then((selectedCategory) {
                  if (selectedCategory != null) {
                    print("Selected Category: $selectedCategory");
                  }
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Category ',
                    style: TextStyle(fontSize: 14),
                  ),
                  Icon(Icons.keyboard_arrow_down, size: 20),
                ],
              ),
            ),
          ),
        ),
        Container(color: Colors.grey, width: 0.5, height: 20),
        Expanded(
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: GetCtx.context!,
                isScrollControlled: true,
                backgroundColor:
                    Provider.of<ThemeController>(GetCtx.context!, listen: false)
                            .darkTheme
                        ? Colors.black
                        : Colors.white,
                builder: (context) => BrandBottomSheetFilter(),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Brand', style: TextStyle(fontSize: 14)),
                Icon(Icons.keyboard_arrow_down, size: 20),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class BrandBottomSheetFilter extends StatelessWidget {
  const BrandBottomSheetFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProductController>(
      builder: (context, searchProductController, child) =>
          Consumer<BrandController>(
        builder: (context, brandProvider, child) => Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              const SizedBox(height: 10),
              Center(
                  child: Container(
                      width: 35,
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeDefault),
                          color: Theme.of(context)
                              .hintColor
                              .withValues(alpha: .5)))),
              Padding(
                  padding:
                      const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                  child: Text(getTranslated('brand', context) ?? '',
                      style: titilliumSemiBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge))),
              Divider(
                  color: Theme.of(context).hintColor.withValues(alpha: .25),
                  thickness: .5),
              if (brandProvider.brandList.isNotEmpty)
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(minHeight: 40.0, maxHeight: 350.0),
                  child: SizedBox(
                    child: RepaintBoundary(
                      child: ScrollbarWidget(
                        child: ListView.builder(
                            itemCount: brandProvider.brandList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return CategoryFilterItem(
                                  title: brandProvider.brandList[index].name,
                                  checked:
                                      brandProvider.brandList[index].checked!,
                                  onTap: () =>
                                      brandProvider.checkedToggleBrand(index));
                            }),
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        // width: 130,
                        child: CustomButton(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .tertiaryContainer
                                .withValues(alpha: .5),
                            textColor: Provider.of<ThemeController>(context,
                                        listen: false)
                                    .darkTheme
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            radius: 8,
                            buttonText: getTranslated('clear', context),
                            onTap: () {
                              final pagination =
                                  Get.put(SearchPaginationController());
                              pagination.clearFilter();
                            })),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                    child: CustomButton(
                        radius: 8,
                        onTap: () {
                          List<int> selectedBrandIdsList = [];
                          for (BrandModel brand in brandProvider.brandList) {
                            if (brand.checked!) {
                              selectedBrandIdsList.add(brand.id!);
                            }
                          }
                          String selectedBrandId =
                              selectedBrandIdsList.isNotEmpty
                                  ? jsonEncode(selectedBrandIdsList)
                                  : '[]';

                          if (brandProvider.selectedBrandIds.isNotEmpty) {
                            final pagination =
                                Get.put(SearchPaginationController());
                            pagination.brandId.value = selectedBrandId;
                            pagination.resetPagination();
                            pagination.pagingController.refresh();
                            pagination.pagingController.fetchNextPage();
                            scrollTarget();

                            Navigator.pop(context);
                          } else {
                            showCustomSnackBar(
                                '${getTranslated('Please select at least one brand', context)}',
                                context,
                                isToaster: true);
                          }
                        },
                        buttonText: "Apply"),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}

categoryFilter() {
  return Consumer<BrandController>(
    builder: (context, brandProvider, child) =>
        Consumer<SearchProductController>(
      builder: (context, searchProvider, child) => Consumer<CategoryController>(
        builder: (context, categoryProvider, child) => Container(
          height: MediaQuery.of(context).size.height / 1.6,
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Center(
                  child: Container(
                      width: 35,
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeDefault),
                          color: Theme.of(context)
                              .hintColor
                              .withValues(alpha: .5)))),
              SizedBox(height: 10),
              // Static Heading
              Text(
                getTranslated('CATEGORY', context) ?? '',
                style: titilliumSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
              Divider(
                color: Theme.of(context).hintColor.withOpacity(0.25),
                thickness: 0.5,
              ),

              // Scrollable ListView
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 15),
                  child: ScrollbarWidget(
                    child: ListView.builder(
                      itemCount: categoryProvider.categoryList.length,
                      itemBuilder: (context, index) {
                        return CategoryFilterItem(
                          title: categoryProvider.categoryList[index].name,
                          checked:
                              categoryProvider.categoryList[index].isSelected!,
                          onTap: () =>
                              categoryProvider.checkedToggleCategory(index),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Static Apply Button
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        // width: 130,
                        child: CustomButton(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .tertiaryContainer
                                .withValues(alpha: .5),
                            textColor: Provider.of<ThemeController>(context,
                                        listen: false)
                                    .darkTheme
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            radius: 8,
                            buttonText: getTranslated('clear', context),
                            onTap: () {
                              final pagination =
                                  Get.put(SearchPaginationController());
                              pagination.clearFilter();
                            })),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        if (categoryProvider.selectedCategoryIds.isNotEmpty) {
                          List<int> selectedCategoryIdsList = [];
                          for (CategoryModel category
                              in categoryProvider.categoryList) {
                            if (category.isSelected!) {
                              selectedCategoryIdsList.add(category.id!);
                            }
                          }
                          String selectedCategoryId =
                              selectedCategoryIdsList.isNotEmpty
                                  ? jsonEncode(selectedCategoryIdsList)
                                  : '[]';
                          final pagination =
                              Get.put(SearchPaginationController());
                          pagination.categoryId.value = selectedCategoryId;
                          pagination.resetPagination();
                          pagination.pagingController.refresh();
                          pagination.pagingController.fetchNextPage();

                          scrollTarget();
                          Navigator.pop(context);
                        } else {
                          showCustomSnackBar(
                              '${getTranslated('Please select at least one category', context)}',
                              context,
                              isToaster: true);
                        }
                      },
                      buttonText: "Apply",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

BuildContext? _findContextByKey(Key key) {
  BuildContext? foundContext;
  void visitor(Element element) {
    if (element.widget.key == key) {
      foundContext = element;
    } else {
      element.visitChildren(visitor);
    }
  }

  WidgetsBinding.instance.renderViewElement!.visitChildren(visitor);
  return foundContext;
}

scrollTarget() {
  // final context = GlobleKeys().targetKey.;
  final context = _findContextByKey(GlobleKeys().targetKey);
  if (context != null) {
    Scrollable.ensureVisible(
      context,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
