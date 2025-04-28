import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_lovexa_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_lovexa_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/product_widget.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../data/model/api_response.dart';

class ProductListWidget extends StatelessWidget {
  final bool isHomePage;
  final ProductType productType;
  final ScrollController? scrollController;

  const ProductListWidget(
      {super.key,
      required this.isHomePage,
      required this.productType,
      this.scrollController});

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if (scrollController!.position.maxScrollExtent ==
              scrollController!.position.pixels &&
          Provider.of<ProductController>(context, listen: false)
                  .latestProductList !=
              null &&
          Provider.of<ProductController>(context, listen: false)
              .latestProductList!
              .isNotEmpty &&
          !Provider.of<ProductController>(context, listen: false)
              .filterIsLoading) {
        late int pageSize;
        if (productType == ProductType.bestSelling ||
            productType == ProductType.topProduct ||
            productType == ProductType.newArrival ||
            productType == ProductType.discountedProduct ||
            productType == ProductType.featuredProduct) {
          if (productType == ProductType.featuredProduct) {
            pageSize = (Provider.of<ProductController>(context, listen: false)
                        .featuredPageSize! /
                    10)
                .ceil();
          } else {
            pageSize = (Provider.of<ProductController>(context, listen: false)
                        .latestPageSize! /
                    10)
                .ceil();
          }
          if (productType == ProductType.featuredProduct) {
            offset = Provider.of<ProductController>(context, listen: false)
                .lOffsetFeatured;
          } else {
            offset =
                Provider.of<ProductController>(context, listen: false).lOffset;
          }
        } else if (productType == ProductType.justForYou) {}
        if (offset < pageSize) {
          offset++;
          Provider.of<ProductController>(context, listen: false)
              .showBottomLoader();
          if (productType == ProductType.featuredProduct) {
            Provider.of<ProductController>(context, listen: false)
                .getFeaturedProductList(offset.toString());
          } else {
            Provider.of<ProductController>(context, listen: false)
                .getLatestProductList(offset);
          }
        } else {}
      }
    });

    return Consumer<ProductController>(
      builder: (context, prodProvider, child) {
        List<Product>? productList = [];

        // print(productType);
        // print("=====>>${prodProvider.latestProductList}<<======");

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
          !prodProvider.filterFirstLoading
              ? (productList != null && productList.isNotEmpty)
                  ? RepaintBoundary(
                      child: RepaintBoundary(
                          child:
                              //       GridView.builder(
                              //   physics: NeverScrollableScrollPhysics(),

                              //   shrinkWrap: true,
                              //   // controller: _scrollController,
                              //   padding: const EdgeInsets.symmetric(
                              //     horizontal: Dimensions.paddingSizeSmall,
                              //   ).copyWith(top: Dimensions.paddingSizeExtraSmall),
                              //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              //     crossAxisCount:
                              //         MediaQuery.of(context).size.width > 480 ? 3 : 2,
                              //     crossAxisSpacing: 10,
                              //     mainAxisSpacing: 10,
                              //     mainAxisExtent:
                              //         MediaQuery.of(context).size.height / 3.3,
                              //     // childAspectRatio:
                              //     //     0.75, // Adjust to match your design
                              //   ),
                              //   itemCount: isHomePage
                              //       ? productList.length > 4
                              //           ? 4
                              //           : productList.length
                              //       : productList.length,
                              //   itemBuilder: (context, index) {
                              //     return ProductWidget(
                              //       productModel: productList![index],
                              //     );
                              //   },
                              // )

                              MasonryGridView.count(
                                  itemCount: isHomePage
                                      ? productList.length > 4
                                          ? 4
                                          : productList.length
                                      : productList.length,
                                  crossAxisCount:
                                      ResponsiveHelper.isTab(context) ? 3 : 2,
                                  padding: const EdgeInsets.all(0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ProductWidget(
                                        productModel: productList![index]);
                                  })))
                  : const NoInternetOrDataScreenWidget(isNoInternet: false)
              : ProductShimmer(
                  isHomePage: isHomePage, isEnabled: prodProvider.firstLoading),
          prodProvider.filterIsLoading
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)),
                ))
              : const SizedBox.shrink()
        ]);
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:provider/provider.dart';

// import '../../../common/basewidget/product_widget.dart';
// import '../../product/domain/models/product_model.dart';
// import '../controllers/product_controller.dart';
// import '../controllers/search_product_controller.dart';

// enum ProductType {
//   latestProduct,
//   featuredProduct,
//   topProduct,
//   bestSelling,
//   newArrival,
//   justForYou,
// }

// class SearchInfinitScrollingWidget extends StatefulWidget {
//   final ProductType productType;
//   const SearchInfinitScrollingWidget({super.key, required this.productType});

//   @override
//   State<SearchInfinitScrollingWidget> createState() => _SearchInfinitScrollingWidgetState();
// }

// class _SearchInfinitScrollingWidgetState extends State<SearchInfinitScrollingWidget> {
//   late final SearchPageController _pageController;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = Get.put(SearchPageController(widget.productType));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PagedSliverGrid<int, Product>(
//       fetchNextPage: () {
//         if (_pageController.canPaginate.value) {
//           _pageController.pagingController.fetchNextPage();
//         }
//       },
//       state: _pageController.pagingController.value,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisSpacing: 8,
//         crossAxisSpacing: 8,
//         mainAxisExtent: 250,
//       ),
//       builderDelegate: PagedChildBuilderDelegate<Product>(
//         itemBuilder: (context, item, index) => ProductWidget(
//           key: ValueKey(item.id),
//           productModel: item,
//         ),
//         firstPageErrorIndicatorBuilder: (context) => const Center(child: Text('Error loading products')),
//         newPageErrorIndicatorBuilder: (context) => const Center(child: CircularProgressIndicator()),
//         animateTransitions: true,
//         firstPageProgressIndicatorBuilder: (context) => const Center(child: CircularProgressIndicator()),
//         newPageProgressIndicatorBuilder: (context) => Obx(() =>
//             _pageController.canPaginate.value ? const CircularProgressIndicator() : const SizedBox.shrink()),
//         noMoreItemsIndicatorBuilder: (context) => const Center(child: Text('No more products')),
//         noItemsFoundIndicatorBuilder: (context) => const Center(child: Text('No products found')),
//       ),
//     );
//   }
// }

// class SearchPageController extends GetxController {
//   final ProductType productType;
//   late final PagingController<int, Product> pagingController;
//   RxBool canPaginate = true.obs;

//   SearchPageController(this.productType);

//   @override
//   void onInit() {
//     super.onInit();
//     pagingController = PagingController<int, Product>(
//       getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
//       fetchPage: (pageKey) async => await _fetchProducts(pageKey),
//     );

//     pagingController.addListener(_showError);
//   }

//   @override
//   void onClose() {
//     pagingController.dispose();
//     super.onClose();
//   }

//   Future<List<Product>> _fetchProducts(int offset) async {
//     try {
//       final productController = Provider.of<ProductController>(Get.context!, listen: false);
//       switch (productType) {
//         case ProductType.latestProduct:
//         case ProductType.topProduct:
//         case ProductType.bestSelling:
//         case ProductType.newArrival:
//           return await productController.getLatestProductList(offset);
//         case ProductType.featuredProduct:
//           return await productController.getFeaturedProductList(offset.toString());
//         case ProductType.justForYou:
//           final searchController = Provider.of<SearchProductController>(Get.context!, listen: false);
//           return await searchController.searchSearchProductForYou(query: '', offset: offset);
//       }
//     } catch (e) {
//       print("Error fetching products: $e");
//       return [];
//     }
//   }

//   void _showError() {
//     if (pagingController.value.status == PagingStatus.subsequentPageError) {
//       ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
//         content: const Text('Something went wrong while fetching a new page.'),
//         action: SnackBarAction(
//           label: 'Retry',
//           onPressed: () => pagingController.fetchNextPage(),
//         ),
//       ));
//     }
//   }

//   void resetPagination() {
//     canPaginate.value = true;
//     pagingController.refresh();
//   }

//   void clearFilter() {
//     pagingController.refresh();
//     pagingController.fetchNextPage();
//   }
// }

//! product list widget
class ProductInfinitListWidget extends StatefulWidget {
  final bool isHomePage;
  final ProductType productType;

  const ProductInfinitListWidget({
    super.key,
    required this.isHomePage,
    required this.productType,
  });

  @override
  State<ProductInfinitListWidget> createState() =>
      _ProductInfinitListWidgetState();
}

class _ProductInfinitListWidgetState extends State<ProductInfinitListWidget> {
  late final PagingController<int, Product> _pagingController;
  // final RxBool _canPaginate = true.obs;
  final BestFeatureController _bestFeatureController =
      Get.put(BestFeatureController());

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, Product>(
      // firstPageKey: 1,
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) => _fetchProducts(pageKey),
    );

    _pagingController.addListener(_handlePagingError);
  }

  Future<List<Product>> _fetchProducts(int page) async {
    final productController =
        Provider.of<ProductController>(context, listen: false);
    try {
      print("types::::: ${widget.productType}");
      // switch (widget.productType) {
      //   case ProductType.featuredProduct:
      //     return await productController.getFeaturedProductListApis('$page');
      //   case ProductType.latestProduct:
      //   case ProductType.topProduct:
      //   case ProductType.bestSelling:
      //   case ProductType.newArrival:
      //     return await productController.getLatestProductListApis(page);
      //   case ProductType.justForYou:
      //   // return await productController.getJustForYouProducts(page);
      //   default:
      //     return [];
      // }
      if (widget.productType == ProductType.featuredProduct) {
        return await productController.getFeaturedProductListApis('$page');
      } else if (widget.productType == ProductType.latestProduct) {
        return await productController.getLatestProductListApis(page);
      } else if (widget.productType == ProductType.bestSelling) {
        return await productController.getBestSellingProductListApis(page);
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
      return [];
    }
    return [];
  }

  void _handlePagingError() {
    if (_pagingController.value.status == PagingStatus.subsequentPageError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Error loading more products'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () => _pagingController.fetchNextPage(),
        ),
      ));
    }
  }

  @override
  void dispose() {
    _bestFeatureController.canPaginateValue(true);
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagingListener(
      controller: _pagingController,
      builder: (context, state, fetchNextPage) => PagedSliverGrid<int, Product>(
        fetchNextPage: () {
          // if (_bestFeatureController.canPaginate.value) fetchNextPage();
          if (_bestFeatureController.canPaginate.value == true) {
            _pagingController.fetchNextPage();
          }
          // fetchNextPage();
        },
        state: state,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          mainAxisExtent: 250,
        ),
        shrinkWrapFirstPageIndicators: true,
        builderDelegate: PagedChildBuilderDelegate<Product>(
          itemBuilder: (context, item, index) => ProductWidget(
            key: ValueKey(item.id),
            productModel: item,
          ),
          firstPageErrorIndicatorBuilder: (context) => const Center(
              child: Text("Error loading products. Please try again.")),
          newPageErrorIndicatorBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
          firstPageProgressIndicatorBuilder: (context) =>
              const ProductShimmer(isHomePage: false, isEnabled: true),
          newPageProgressIndicatorBuilder: (context) => Obx(() => Center(
                child: _bestFeatureController.canPaginate.value
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink(),
              )),
          noItemsFoundIndicatorBuilder: (context) =>
              const NoInternetOrDataScreenWidget(isNoInternet: false),
          noMoreItemsIndicatorBuilder: (context) => const Center(
            child: Text("No more products"),
          ),
        ),
      ),
    );
  }
}

class BestFeatureController extends GetxController {
  final canPaginate = true.obs;
  canPaginateValue(bool value) {
    canPaginate.value = value;
  }

  @override
  void onClose() {
    canPaginateValue(true);
    // TODO: implement onClose
    super.onClose();
  }
}

featureFn(ApiResponse apiResponse) {
  final bestsellingCtr = Get.put(BestFeatureController());
  if (apiResponse.response!.data['products'] == null) {
    bestsellingCtr.canPaginateValue(false);
  }
}
