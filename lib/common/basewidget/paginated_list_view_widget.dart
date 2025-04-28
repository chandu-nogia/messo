import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/main.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/brand/controllers/brand_controller.dart';
import '../../features/category/controllers/category_controller.dart';
import '../../features/product/domain/models/product_model.dart';
import '../../features/search_product/controllers/search_product_controller.dart';
import '../../features/search_product/widgets/search_filter_bottom_sheet_widget.dart';
import '../../utill/dimensions.dart';
import 'product_widget.dart';

class PaginatedListView extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int? offset) onPaginate;
  final int? totalSize;
  final int? offset;
  final int? limit;
  final Widget itemView;
  final bool enabledPagination;
  final bool reverse;
  const PaginatedListView({
    super.key,
    required this.scrollController,
    required this.onPaginate,
    required this.totalSize,
    required this.offset,
    required this.itemView,
    this.enabledPagination = true,
    this.reverse = false,
    this.limit = 20,
  });

  @override
  State<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  final pages = Get.put(PaginationsController());
  int? _offset;
  late List<int?> _offsetList;
  bool _isLoading = false;
  @override
  void dispose() {
    _offset = null;
    _offsetList = [];

    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _offset = 1;
    _offsetList = [1];

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
              widget.scrollController.position.maxScrollExtent &&
          widget.totalSize != null &&
          !_isLoading &&
          widget.enabledPagination) {
        if (mounted) {
          _paginate();
        }
      }
    });
  }

  void _paginate() async {
    int pageSize = (widget.totalSize! / widget.limit!).ceil();
    if (pageSize == _offset) {
      pages.valueTrue();
      // pages.continous.value = true;
    }
    if (_offset! < pageSize && !_offsetList.contains(_offset! + 1)) {
      setState(() {
        _offset = _offset! + 1;
        _offsetList.add(_offset);
        _isLoading = true;
      });
      await widget.onPaginate(_offset);
      setState(() {
        _isLoading = false;
      });
    } else {
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.offset != null) {
      _offset = widget.offset;
      _offsetList = [];
      for (int index = 1; index <= widget.offset!; index++) {
        _offsetList.add(index);
      }
    }

    return Column(children: [
      widget.reverse ? const SizedBox() : widget.itemView,
      ((widget.totalSize == null ||
              _offset! >= (widget.totalSize! / (widget.limit ?? 10)).ceil() ||
              _offsetList.contains(_offset! + 1)))
          ? const SizedBox()
          : Center(
              child: Padding(
                  padding: (_isLoading)
                      ? const EdgeInsets.all(Dimensions.paddingSizeSmall)
                      : EdgeInsets.zero,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const SizedBox())),
      widget.reverse ? widget.itemView : const SizedBox(),
    ]);
  }
}

class PaginationController extends GetxController {
  final RxBool continous = false.obs;
  valueTrue() {
    continous.value = true;
  }

  valueFalse() {
    Future.microtask(() => continous.value = false);
    // continous.value = false;
  }
}

// class PaginatedListView extends StatelessWidget {
//   final ScrollController scrollController;
//   final Function(int? offset) onPaginate;
//   final int? totalSize;
//   final int? offset;
//   final int? limit;
//   final Widget itemView;
//   final bool enabledPagination;
//   final bool reverse;

//   PaginatedListView({
//     super.key,
//     required this.scrollController,
//     required this.onPaginate,
//     required this.totalSize,
//     required this.offset,
//     required this.itemView,
//     this.enabledPagination = true,
//     this.reverse = false,
//     this.limit = 20,
//   });

//   final PaginationController _pages = Get.put(PaginationController());

//   void _paginate() async {
//     final pageSize = (totalSize! / limit! ?? 20).ceil();
//     print("pageSized ::: $pageSize");
//     _pages.valueEqual(offset);
//     if (_pages.currentOffset.value >= pageSize) {
//       _pages.valueTrue();
//       return;
//     }

//     if (!_pages.offsetList.contains(_pages.currentOffset.value + 1)) {
//       _pages.currentOffset.value++;

//       _pages.offsetList.add(_pages.currentOffset.value);
//       _pages.setLoading(true);

//       try {
//         await onPaginate(_pages.currentOffset.value);
//       } catch (e) {
//         print("Pagination Error: $e");
//         Get.snackbar("Error", "Failed to load more data");
//       } finally {
//         _pages.setLoading(false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     scrollController.addListener(() {
//       if (scrollController.position.pixels ==
//               scrollController.position.maxScrollExtent &&
//           totalSize != null &&
//           !_pages.isLoading.value &&
//           enabledPagination) {
//         _paginate();
//       }
//     });

//     if (offset != null) {
//       _pages.currentOffset.value = offset!;
//       _pages.offsetList.value = List.generate(offset!, (i) => i + 1);
//     }

//     return Obx(() => Column(children: [
//           reverse ? const SizedBox() : itemView,
//           (_pages.continous.value)
//               ? const SizedBox()
//               : Center(
//                   child: Padding(
//                     padding: (_pages.isLoading.value)
//                         ? const EdgeInsets.all(Dimensions.paddingSizeSmall)
//                         : EdgeInsets.zero,
//                     child: _pages.isLoading.value
//                         ? const CircularProgressIndicator()
//                         : const SizedBox(),
//                   ),
//                 ),
//           reverse ? itemView : const SizedBox(),
//         ]));
//   }
// }

// class PaginationController extends GetxController {
//   final RxBool continous = false.obs;
//   valueTrue() {
//     continous.value = true;
//   }

//   valueFalse() {
//     Future.microtask(() => continous.value = false);
//     // continous.value = false;
//   }

//   // final continous = false.obs;
//   final isLoading = false.obs;
//   final currentOffset = 1.obs;
//   final offsetList = <int>[1].obs;
//   valueEqual(value) {
//     currentOffset.value = value;
//   }

//   @override
//   void onInit() {
//     currentOffset.value = 1;
//     offsetList.value = [1];
//     continous.value = false;
//     isLoading.value = false;
//     // TODO: implement onInit
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     currentOffset.value = 1;
//     offsetList.value = [1];
//     continous.value = false;
//     isLoading.value = false;
//     // TODO: implement onClose
//     super.onClose();
//   }

//   paginationEnd() {
//     currentOffset.value = 1;
//     offsetList.value = [1];
//     continous.value = false;
//     isLoading.value = false;
//   }

//   void reset() {
//     currentOffset.value = 1;
//     offsetList.value = [1];
//     continous.value = false;
//     isLoading.value = false;
//   }

//   // void markComplete() => continous.value = true;
//   void setLoading(bool loading) => isLoading.value = loading;
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PaginatedListView extends StatelessWidget {
//   final ScrollController scrollController;
//   final Function(int? offset) onPaginate;
//   final int? totalSize;
//   final int? offset;
//   final int? limit;
//   final Widget itemView;
//   final bool enabledPagination;
//   final bool reverse;

//   const PaginatedListView({
//     super.key,
//     required this.scrollController,
//     required this.onPaginate,
//     required this.totalSize,
//     required this.offset,
//     required this.itemView,
//     this.enabledPagination = true,
//     this.reverse = false,
//     this.limit = 20,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final PaginationController paginationController =
//         Get.put(PaginationController());

//     if (offset != null) {
//       paginationController.setOffset(offset!);
//     }

//     scrollController.addListener(() {
//       if (scrollController.position.pixels ==
//               scrollController.position.maxScrollExtent &&
//           totalSize != null &&
//           !paginationController.isLoading.value &&
//           enabledPagination) {
//         paginationController.paginate(onPaginate, limit!, totalSize!);
//       }
//     });

//     return Column(
//       children: [
//         reverse ? const SizedBox() : itemView,
//         Obx(() {
//           return paginationController.isLoading.value
//               ? Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: const CircularProgressIndicator(),
//                 )
//               : const SizedBox();
//         }),
//         reverse ? itemView : const SizedBox(),
//       ],
//     );
//   }
// }

// class PaginationController extends GetxController {
//   final RxBool continous = false.obs;
//   valueTrue() {
//     continous.value = true;
//   }

//   valueFalse() {
//     Future.microtask(() => continous.value = false);
//     // continous.value = false;
//   }

//   RxBool isLoading = false.obs;
//   RxInt offset = 1.obs;
//   RxList<int?> offsetList = <int?>[1].obs;

//   void setOffset(int newOffset) {
//     offset.value = newOffset;
//     offsetList.clear();
//     for (int i = 1; i <= newOffset; i++) {
//       offsetList.add(i);
//     }
//   }

//   void paginate(
//       Function(int? offset) onPaginate, int limit, int totalSize) async {
//     int pageSize = (totalSize / limit).ceil();
//     if (offset.value >= pageSize) return;

//     if (!offsetList.contains(offset.value + 1)) {
//       isLoading.value = true;
//       offset.value++;
//       await onPaginate(offset.value);
//       offsetList.add(offset.value);
//       isLoading.value = false;
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PaginatedListView extends StatelessWidget {
//   final ScrollController scrollController;
//   final Function(int? offset) onPaginate;
//   final int? totalSize;
//   final int? offset;
//   final int? limit;
//   final Widget itemView;
//   final bool enabledPagination;
//   final bool reverse;

//   const PaginatedListView({
//     super.key,
//     required this.scrollController,
//     required this.onPaginate,
//     required this.totalSize,
//     required this.offset,
//     required this.itemView,
//     this.enabledPagination = true,
//     this.reverse = false,
//     this.limit = 20,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final PaginationController paginationController =
//         Get.put(PaginationController());

//     scrollController.addListener(() {
//       if (scrollController.position.pixels ==
//               scrollController.position.maxScrollExtent &&
//           totalSize != null &&
//           !paginationController.isLoading.value &&
//           enabledPagination) {
//         paginationController.paginate(onPaginate, limit!, totalSize!);
//       }
//     });

//     return Column(
//       children: [
//         reverse ? const SizedBox() : itemView,
//         Obx(() {
//           return paginationController.isLoading.value
//               ? Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: const CircularProgressIndicator(),
//                 )
//               : const SizedBox();
//         }),
//         reverse ? itemView : const SizedBox(),
//       ],
//     );
//   }
// }

class PaginationsController extends GetxController {
  // final RxBool cts = false.obs;
  // ctsTrue() {
  //   cts.value = true;
  // }

  // ctsFalse() {
  //   cts.value = false;
  // }

  final RxBool continous = false.obs;
  valueTrue() {
    continous.value = true;
  }

  valueFalse() {
    Future.microtask(() => continous.value = false);
    continous.value = false;
  }

  RxBool isLoading = false.obs;
  RxInt offset = 1.obs;

//   void paginate(
//       Function(int? offset) onPaginate, int limit, int totalSize) async {
//     int pageSize = (totalSize / limit).ceil();
//     if (pageSize == offset) {
//       continous.value = true;

//       // valueTrue();
// //       // pages.continous.value = true;
//     }
//     if (offset.value >= pageSize) return;

//     isLoading.value = true;

//     offset.value++;

//     await onPaginate(offset.value);

//     isLoading.value = false;
//     // }
//   }

  // @override
  // void onInit() {
  //   offset.value = 1;
  //   // TODO: implement onInit
  //   super.onInit();
  // }

  // @override
  // void onClose() {
  //   offset.value = 1;
  //   // TODO: implement onClose
  //   super.onClose();
  // }
}

class InfinitScrollingWidget extends StatefulWidget {
  const InfinitScrollingWidget({super.key});

  @override
  State<InfinitScrollingWidget> createState() => _InfinitScrollingWidgetState();
}

class _InfinitScrollingWidgetState extends State<InfinitScrollingWidget> {
  final _pageController = Get.put(SearchPaginationController());

  /// The controller needs to be disposed when the widget is removed.

  @override
  Widget build(BuildContext context) {
    return PagedSliverGrid<int, Product>(
      showNoMoreItemsIndicatorAsGridChild: false,
      showNewPageErrorIndicatorAsGridChild: false,
      addRepaintBoundaries: false,
      showNewPageProgressIndicatorAsGridChild: false,
      shrinkWrapFirstPageIndicators: false,

      // fetchNextPage: _pageController.pagingController.fetchNextPage,
      fetchNextPage: () {
        if (_pageController.canPaginate.value) {
          _pageController.pagingController.fetchNextPage();
        }
      },
      state: _pageController.pagingController.value,
      // pagingController: _pagingController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 250,

        // childAspectRatio: 0.73,
      ),
      builderDelegate: PagedChildBuilderDelegate<Product>(
        itemBuilder: (context, item, index) {
          return Consumer<SearchProductController>(
            builder: (context, value, child) => Obx(
              () => _pageController.isLoading == true
                  ? ProductForYouShimer(value: true)
                  : ProductWidget(
                      key: ValueKey(item.id!),
                      productModel:
                          _pageController.pagingController.value.items![index],
                    ),
            ),
          );
        },
        firstPageErrorIndicatorBuilder: (context) => CustomFirstPageError(
            pagingController: _pageController.pagingController),
        newPageErrorIndicatorBuilder: (context) => CustomNewPageError(
            pagingController: _pageController.pagingController),
        animateTransitions: true,
        // firstPageProgressIndicatorBuilder: (context) =>
        //     const Center(child: ProductForYouShimer()),
        newPageProgressIndicatorBuilder: (context) {
          return Obx(
            () => Center(
                child: _pageController.canPaginate.value == false
                    ? const SizedBox.shrink()
                    : const ProductForYouShimer()),
          );
        },

        noMoreItemsIndicatorBuilder: (context) =>
            NoItemFound(pagingController: _pageController.pagingController),
        // const Center(child: Text('No more products')),
        // noItemsFoundIndicatorBuilder: (context) => Center(
        //     child: Column(
        //   children: [
        //     SizedBox(height: 20),
        //     Padding(
        //       padding: EdgeInsets.symmetric(
        //           horizontal: MediaQuery.of(context).size.width / 4),
        //       child: CustomButton(
        //           radius: 10,
        //           onTap: () {
        //             _pageController.clearFilter(nav: true);
        //           },
        //           buttonText: "Continue Shopping"),
        //     ),
        //     SizedBox(height: 60),
        //   ],
        // )),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CustomFirstPageError extends StatelessWidget {
  const CustomFirstPageError({super.key, required this.pagingController});

  final PagingController<Object, Object> pagingController;

  @override
  Widget build(BuildContext context) {
    return PagingListener(
        controller: pagingController,
        builder: (context, state, _) => Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Something went wrong :(',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
              if (state.error != null) ...[
                const SizedBox(height: 16),
                Text(state.error.toString(), textAlign: TextAlign.center),
              ],
              const SizedBox(height: 48),
              SizedBox(
                  width: 200,
                  child: ElevatedButton.icon(
                      onPressed: pagingController.refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again',
                          style: TextStyle(fontSize: 16))))
            ])));
  }
}

class CustomNewPageError extends StatelessWidget {
  const CustomNewPageError({super.key, required this.pagingController});

  final PagingController<Object, Object> pagingController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: pagingController.fetchNextPage,
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('We didn\'t catch that. Try again?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  const Icon(Icons.refresh, size: 20)
                ])));
  }
}

class NoItemFound extends StatelessWidget {
  const NoItemFound({super.key, required this.pagingController});

  final PagingController<Object, Object> pagingController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        // onTap: pagingController.fetchNextPage,
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (pagingController.items == null) ...[
                    const SizedBox(height: 16),
                    Text('No products found', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                  ],
                ])));
  }
}

class SearchPaginationController extends GetxController {
  late final PagingController<int, Product> pagingController;
  RxBool canPaginate = true.obs;
  RxBool isLoading = false.obs;
  RxString categoryId = "[]".obs;
  RxString brandId = "[]".obs;
  RxString sortId = "[]".obs;
  String? priceMin;
  String? priceMax;
  RxBool productLenght = false.obs;
  void resetPagination() {
    canPaginate.value = true; // Allow pagination again
    // pagingController.refresh(); // Reset the paging controller
  }

  final searchProvider =
      Provider.of<SearchProductController>(GetCtx.context!, listen: false);
  clearFilter({bool nav = false}) {
    resetPagination();
    categoryId.value = "[]";
    brandId.value = "[]";
    sortId.value = "[]";
    priceMin = null;
    priceMax = null;
    currentRangeValues = RangeValues(0, 1000000);
    searchProvider.setFilterIndex(10);
    searchProvider.setFilterApply(isSorted: false);
    Provider.of<BrandController>(GetCtx.context!, listen: false).brandClear();
    Provider.of<CategoryController>(GetCtx.context!, listen: false)
        .clearAllSelectedCategories();
    pagingController.refresh();
    pagingController.fetchNextPage();
    if (nav == false) {
      Navigator.of(GetCtx.context!).pop();
    }
  }

  Future<List<Product>> methods(int offset) async {
    try {
      isLoading.value = true;
      final rs = await Provider.of<SearchProductController>(GetCtx.context!,
              listen: false)
          .searchProductForYou(
              query: "",
              sort: sortId.value,
              categoryIds: categoryId.value,
              brandIds: brandId.value,
              priceMin: priceMin,
              priceMax: priceMax,
              offset: offset);

      // Check if there are no more products
      if (rs.isEmpty) {
        canPaginate.value = false; // Stop pagination
      }
      isLoading.value = false;
      return rs;
    } catch (e) {
      isLoading.value = false;
      print("Error fetching products: $e");
      return [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    pagingController = PagingController<int, Product>(
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) async {
        if (!canPaginate.value)
          return []; // Stop fetching if pagination is disabled

        final rs = await methods(pageKey);
        return rs;
      },
      // fetchPage: (pageKey) async {
      //   final rs = await methods(pageKey);
      //   print(":::: rs :: ${rs.length}");
      //   if (rs.length == 0) {
      //     productLenght.value = true;
      //   } else {
      //     productLenght.value = false;
      //   }
      //   return rs;
      //   // return await methods(pageKey);

      // },
    );

    pagingController.addListener(_showError);
  }

  @override
  onClose() {
    pagingController.dispose();
    super.onClose();
  }

  Future<void> _showError() async {
    if (pagingController.value.status == PagingStatus.subsequentPageError) {
      ScaffoldMessenger.of(GetCtx.context!).showSnackBar(SnackBar(
          content:
              const Text('Something went wrong while fetching a new page.'),
          action: SnackBarAction(
              label: 'Retry',
              onPressed: () => pagingController.fetchNextPage())));
    } else if (pagingController.value.status == PagingStatus.firstPageError) {
      ScaffoldMessenger.of(GetCtx.context!).showSnackBar(SnackBar(
          content: const Text('Something went wrong while fetching the page.'),
          action: SnackBarAction(
              label: 'Retry', onPressed: () => pagingController.refresh())));
    }
  }
}

class ProductForYouShimer extends StatelessWidget {
  final bool value;
  const ProductForYouShimer({super.key, this.value = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).cardColor,
      highlightColor: Colors.grey[300]!,
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: value ? 1 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
        ),
      ),
    );
  }
}
