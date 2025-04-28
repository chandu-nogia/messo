import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/paginated_list_view_widget.dart';
import '../../../common/basewidget/product_widget.dart';
import '../../../main.dart';
import '../../product/domain/models/product_model.dart';
import '../../search_product/controllers/search_product_controller.dart';

class InfinitReletedProduct extends StatefulWidget {
  final int? productId;
  final String? categoryId;
  const InfinitReletedProduct(
      {super.key, required this.categoryId, required this.productId});

  @override
  State<InfinitReletedProduct> createState() => _InfinitReletedProductState();
}

class _InfinitReletedProductState extends State<InfinitReletedProduct> {
  // final _pageController = Get.put(ReletedProductController());
  bool productLenght = false;
  late final PagingController<int, Product> pagingController;
  Future<List<Product>> methods(int offset) async {
    try {
      final rs = await Provider.of<SearchProductController>(GetCtx.context!,
              listen: false)
          .searchSearchProductForYou(
              query: '', categoryIds: widget.categoryId!, offset: offset);
      List<Product> products =
          rs.where((element) => element.id != widget.productId!).toList();

      return products;
    } catch (e) {
      print("Error fetching products: $e");
      return [];
      // Optionally, show a snackbar or dialog to inform the user
    }
    // return [];
  }

  @override
  void initState() {
    pagingController = PagingController<int, Product>(
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) async {
        final rs = await methods(pageKey);
        print(":::: rs :: ${rs.length}");
        if (rs.length == 0) {
          productLenght = true;
          setState(() {});
        } else {
          productLenght = false;
          setState(() {});
        }
        return rs;
        // return await methods(pageKey);
      },
    );

    pagingController.addListener(showError);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PagedSliverGrid<int, Product>(
      fetchNextPage: pagingController.fetchNextPage,
      state: pagingController.value,
      // pagingController: _pagingController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      builderDelegate: PagedChildBuilderDelegate<Product>(
        itemBuilder: (context, item, index) =>
            Consumer<SearchProductController>(
          builder: (context, value, child) => ProductWidget(
            key: ValueKey(item.id),
            productModel: pagingController.value.items![index],
          ),
        ),
        firstPageErrorIndicatorBuilder: (context) =>
            CustomFirstPageError(pagingController: pagingController),
        newPageErrorIndicatorBuilder: (context) =>
            CustomNewPageError(pagingController: pagingController),
        animateTransitions: true,
        firstPageProgressIndicatorBuilder: (context) =>
            const Center(child: CircularProgressIndicator()),
        newPageProgressIndicatorBuilder: (context) {
          return Obx(
            () => Center(
                child: productLenght == true
                    ? Text('No more products')
                    : CircularProgressIndicator()),
          );
        },
        noMoreItemsIndicatorBuilder: (context) =>
            const Center(child: Text('No more products')),
        noItemsFoundIndicatorBuilder: (context) =>
            const Center(child: Text('No products found')),
      ),
    );
  }

  Future<void> showError() async {
    if (pagingController.value.status == PagingStatus.subsequentPageError) {
      ScaffoldMessenger.of(GetCtx.context!).showSnackBar(SnackBar(
          content:
              const Text('Something went wrong while fetching a new page.'),
          action: SnackBarAction(
              label: 'Retry',
              onPressed: () => pagingController.fetchNextPage())));
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}

// class ReletedProductController extends GetxController {
//   late final PagingController<int, Product> pagingController;
//   RxBool productLenght = false.obs;
//   String? categoryId;
//   int? productId;
//   ClearFilter() {
//     pagingController.refresh();
//     pagingController.fetchNextPage();
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     pagingController = PagingController<int, Product>(
//       getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
//       fetchPage: (pageKey) async {
//         final rs = await methods(pageKey);
//         print(":::: rs :: ${rs.length}");
//         if (rs.length == 0) {
//           productLenght.value = true;
//         } else {
//           productLenght.value = false;
//         }
//         return rs;
//         // return await methods(pageKey);
//       },
//     );

//     pagingController.addListener(_showError);
//   }

//   @override
//   onClose() {
//     pagingController.dispose();
//     super.onClose();
//   }

// }
