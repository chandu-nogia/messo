import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/paginated_list_view_widget.dart';
import '../../../common/basewidget/product_widget.dart';
import '../../../main.dart';
import '../../product/domain/models/product_model.dart';
import '../controllers/search_product_controller.dart';

class SearchInfinitScrollingWidget extends StatefulWidget {
  const SearchInfinitScrollingWidget({super.key});

  @override
  State<SearchInfinitScrollingWidget> createState() =>
      _SearchInfinitScrollingWidgetState();
}

class _SearchInfinitScrollingWidgetState
    extends State<SearchInfinitScrollingWidget> {
  final _pageController = Get.put(SearchPageController());

  @override
  Widget build(BuildContext context) {
    return PagedSliverGrid<int, Product>(
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
        // childAspectRatio: 0.75,
        mainAxisExtent: 250,
      ),
      builderDelegate: PagedChildBuilderDelegate<Product>(
        itemBuilder: (context, item, index) =>
            Consumer<SearchProductController>(
          builder: (context, value, child) => ProductWidget(
            key: ValueKey(item.id),
            productModel: _pageController.pagingController.value.items![index],
          ),
        ),
        firstPageErrorIndicatorBuilder: (context) => CustomFirstPageError(
            pagingController: _pageController.pagingController),
        newPageErrorIndicatorBuilder: (context) => CustomNewPageError(
            pagingController: _pageController.pagingController),
        animateTransitions: true,
        firstPageProgressIndicatorBuilder: (context) =>
            const Center(child: CircularProgressIndicator()),
        newPageProgressIndicatorBuilder: (context) => Obx(
          () => Center(
              child: _pageController.canPaginate.value == false
                  ? SizedBox.shrink()
                  : CircularProgressIndicator()),
        ),
        noMoreItemsIndicatorBuilder: (context) =>
            const Center(child: Text('No more products')),
        noItemsFoundIndicatorBuilder: (context) => const Center(
            child: Column(
          children: [
            SizedBox(height: 20),
            Text('No products found'),
            SizedBox(height: 60),
          ],
        )),
      ),
    );
  }
}

class SearchPageController extends GetxController {
  late final PagingController<int, Product> pagingController;
  RxString searchText = "".obs;
  RxBool canPaginate = true.obs;
  void resetPagination() {
    canPaginate.value = true;
  }

  ClearFilter() {
    pagingController.refresh();
    pagingController.fetchNextPage();
  }

  Future<List<Product>> methods(int offset) async {
    try {
      final rs = await Provider.of<SearchProductController>(GetCtx.context!,
              listen: false)
          .searchSearchProductForYou(
              query: searchText.value ?? '', offset: offset);

      return rs;
    } catch (e) {
      print("Error fetching products: $e");
      return [];
      // Optionally, show a snackbar or dialog to inform the user
    }
    // return [];
  }

  @override
  void onInit() {
    super.onInit();
    pagingController = PagingController<int, Product>(
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) async => await methods(pageKey),
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
    }
  }
}
