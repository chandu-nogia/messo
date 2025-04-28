// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_lovexa_ecommerce/helper/responsive_helper.dart';
// import 'package:flutter_lovexa_ecommerce/features/search_product/controllers/search_product_controller.dart';
// import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/paginated_list_view_widget.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/product_widget.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';

// import '../../brand/controllers/brand_controller.dart';
// import '../controllers/voice_controller.dart';

// class HomeFilterScreen extends StatefulWidget {
//   final ScrollController? scrollController;

//   const HomeFilterScreen({super.key, this.scrollController});

//   @override
//   State<HomeFilterScreen> createState() => _HomeFilterScreenState();
// }

// class _HomeFilterScreenState extends State<HomeFilterScreen> {
//   // ScrollController scrollController = ScrollController();
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//       child: Consumer<SearchProductController>(
//           builder: (context, searchProductController, _) {
//         return PaginatedListView(
//             scrollController: widget.scrollController!,
//             onPaginate: (offset) async {
//               print("paggination :::::::::::: ${offset!}");
//               final brandId =
//                   Provider.of<BrandController>(context, listen: false)
//                       .selectedBrandIds;
//               final authorId =
//                   Provider.of<SearchProductController>(context, listen: false)
//                       .selectedAuthorIds;

//               String selectedBrandId =
//                   brandId.isNotEmpty ? jsonEncode(brandId) : '[]';
//               String selectedAuthorId =
//                   authorId.isNotEmpty ? jsonEncode(authorId) : '[]';
//               final catId = Get.put(VoiceSearchController());
//               String selectCatId = catId.selectCatId.value.isNotEmpty
//                   ? jsonEncode(catId.selectCatId.value)
//                   : '[]';
//               await searchProductController.searchProduct(
//                   categoryIds: selectCatId,
//                   brandIds: selectedBrandId,
//                   authorIds: selectedAuthorId,
//                   query: "",
//                   offset: offset);
//             },
//             totalSize: searchProductController.searchedProduct?.totalSize,
//             offset: searchProductController.searchedProduct?.offset,
//             itemView: RepaintBoundary(
//                 child: MasonryGridView.count(
//                     physics: const NeverScrollableScrollPhysics(),
//                     padding: const EdgeInsets.all(0),
//                     crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
//                     shrinkWrap: true,
//                     itemCount: searchProductController
//                         .searchedProduct!.products!.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return ProductWidget(
//                           productModel: searchProductController
//                               .searchedProduct!.products![index]);
//                     })));
//       }),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_lovexa_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../data/model/api_response.dart';
import '../../../helper/api_checker.dart';
import '../../../main.dart';
import '../../brand/controllers/brand_controller.dart';
import '../../product/domain/models/product_model.dart';
import '../controllers/voice_controller.dart';

class HomeFilterScreen extends StatefulWidget {
  final String? query;
  final ScrollController? scrollController;

  const HomeFilterScreen({super.key, this.scrollController, this.query});

  @override
  State<HomeFilterScreen> createState() => _HomeFilterScreenState();
}

class _HomeFilterScreenState extends State<HomeFilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Consumer<SearchProductController>(
          builder: (context, searchProductController, _) {
        final searchedProduct = searchProductController.searchedProductfry;
        final productList = searchedProduct?.products ?? [];
        print("product list 2 ::::: ${productList.length}");

        return searchedProduct == null || searchedProduct.products == null
            ? const Center(
                child: Text(
                  "No products found",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            : PaginatedListView(
                scrollController: widget.scrollController!,
                onPaginate: (offset) async {
                  // final PaginationController paginationController =
                  //     Get.put(PaginationController());
                  // paginationController.isLoading.value = true;
                  print("Pagination :::::::::::: ${offset!}");
                  final brandId =
                      Provider.of<BrandController>(context, listen: false)
                          .selectedBrandIds;
                  final authorId = Provider.of<SearchProductController>(context,
                          listen: false)
                      .selectedAuthorIds;

                  String selectedBrandId =
                      brandId.isNotEmpty ? jsonEncode(brandId) : '[]';
                  String selectedAuthorId =
                      authorId.isNotEmpty ? jsonEncode(authorId) : '[]';
                  final catId = Get.put(VoiceSearchController());
                  String selectCatId = catId.selectCatId.value.isNotEmpty
                      ? jsonEncode(catId.selectCatId.value)
                      : '[]';

                  await searchProductController.searchProductForYou(
                      categoryIds: selectCatId,
                      brandIds: selectedBrandId,
                      authorIds: selectedAuthorId,
                      query: widget.query ?? "",
                      sort: searchProductController.sortText ?? '',
                      offset: offset);
                },
                totalSize: searchedProduct.totalSize ?? 0,
                offset: searchedProduct.offset ?? 0,
                itemView: productList.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "No products available",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          RepaintBoundary(
                            child: MasonryGridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              crossAxisCount:
                                  ResponsiveHelper.isTab(context) ? 3 : 2,
                              shrinkWrap: true,
                              itemCount: productList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ProductWidget(
                                    productModel: productList[index]);
                              },
                            ),
                          ),
                          // CustomButton(buttonText: "Continous"),
                        ],
                      ),
              );
      }),
    );
  }
}

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_lovexa_ecommerce/helper/responsive_helper.dart';
// import 'package:flutter_lovexa_ecommerce/features/search_product/controllers/search_product_controller.dart';
// import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/paginated_list_view_widget.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/product_widget.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';

// import '../../brand/controllers/brand_controller.dart';
// import '../controllers/voice_controller.dart';

// class HomeFilterScreen extends StatefulWidget {
//   final ScrollController? scrollController;

//   const HomeFilterScreen({super.key, this.scrollController});

//   @override
//   State<HomeFilterScreen> createState() => _HomeFilterScreenState();
// }

// class _HomeFilterScreenState extends State<HomeFilterScreen> {
//   // ScrollController scrollController = ScrollController();
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//       child: Consumer<SearchProductController>(
//           builder: (context, searchProductController, _) {
//         return PaginatedListView(
//             scrollController: widget.scrollController!,
//             onPaginate: (offset) async {
//               print("paggination :::::::::::: ${offset!}");
//               final brandId =
//                   Provider.of<BrandController>(context, listen: false)
//                       .selectedBrandIds;
//               final authorId =
//                   Provider.of<SearchProductController>(context, listen: false)
//                       .selectedAuthorIds;

//               String selectedBrandId =
//                   brandId.isNotEmpty ? jsonEncode(brandId) : '[]';
//               String selectedAuthorId =
//                   authorId.isNotEmpty ? jsonEncode(authorId) : '[]';
//               final catId = Get.put(VoiceSearchController());
//               String selectCatId = catId.selectCatId.value.isNotEmpty
//                   ? jsonEncode(catId.selectCatId.value)
//                   : '[]';
//               await searchProductController.searchProduct(
//                   categoryIds: selectCatId,
//                   brandIds: selectedBrandId,
//                   authorIds: selectedAuthorId,
//                   query: "",
//                   offset: offset);
//             },
//             totalSize: searchProductController.searchedProduct?.totalSize,
//             offset: searchProductController.searchedProduct?.offset,
//             itemView: RepaintBoundary(
//                 child: MasonryGridView.count(
//                     physics: const NeverScrollableScrollPhysics(),
//                     padding: const EdgeInsets.all(0),
//                     crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
//                     shrinkWrap: true,
//                     itemCount: searchProductController
//                         .searchedProduct!.products!.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return ProductWidget(
//                           productModel: searchProductController
//                               .searchedProduct!.products![index]);
//                     })));
//       }),
//     );
//   }
// }

class SearchScrFilterScreen extends StatefulWidget {
  final String? query;
  final ScrollController? scrollController;

  const SearchScrFilterScreen({super.key, this.scrollController, this.query});

  @override
  State<SearchScrFilterScreen> createState() => _SearchScrFilterScreenState();
}

class _SearchScrFilterScreenState extends State<SearchScrFilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Consumer<SearchProductController>(
          builder: (context, searchProductController, _) {
        final searchedProduct = searchProductController.searchedProduct;
        final productList = searchedProduct?.products ?? [];
        print("product list 2 ::::: ${productList.length}");

        return searchedProduct == null || searchedProduct.products == null
            ? const Center(
                child: Text(
                  "No products found",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            : PaginatedListView(
                scrollController: widget.scrollController!,
                onPaginate: (offset) async {
                  // final PaginationController paginationController =
                  //     Get.put(PaginationController());
                  // paginationController.isLoading.value = true;
                  print("Pagination :::::::::::: ${offset!}");
                  // final brandId =
                  //     Provider.of<BrandController>(context, listen: false)
                  //         .selectedBrandIds;
                  // final authorId = Provider.of<SearchProductController>(context,
                  //         listen: false)
                  //     .selectedAuthorIds;

                  // String selectedBrandId =
                  //     brandId.isNotEmpty ? jsonEncode(brandId) : '[]';
                  // String selectedAuthorId =
                  //     authorId.isNotEmpty ? jsonEncode(authorId) : '[]';
                  // final catId = Get.put(VoiceSearchController());
                  // String selectCatId = catId.selectCatId.value.isNotEmpty
                  //     ? jsonEncode(catId.selectCatId.value)
                  //     : '[]';

                  await searchProductController.searchProduct(
                      // categoryIds: selectCatId,
                      // brandIds: selectedBrandId,
                      // authorIds: selectedAuthorId,
                      query: widget.query ?? "",
                      sort: searchProductController.sortText ?? '',
                      offset: offset);
                },
                totalSize: searchedProduct.totalSize ?? 0,
                offset: searchedProduct.offset ?? 0,
                itemView: productList.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "No products available",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          RepaintBoundary(
                            child: MasonryGridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              crossAxisCount:
                                  ResponsiveHelper.isTab(context) ? 3 : 2,
                              shrinkWrap: true,
                              itemCount: productList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ProductWidget(
                                    productModel: productList[index]);
                              },
                            ),
                          ),
                          // CustomButton(buttonText: "Continous"),
                        ],
                      ),
              );
      }),
    );
  }
}
