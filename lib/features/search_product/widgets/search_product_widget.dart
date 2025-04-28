import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/search_product/widgets/search_filter_bottom_sheet_widget.dart';
import 'package:flutter_lovexa_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_lovexa_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/custom_themes.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/utill/images.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/product_filter_search.dart';
import '../../brand/controllers/brand_controller.dart';
import '../controllers/voice_controller.dart';
import 'home_filter_screen.dart';

class SearchProductWidget extends StatefulWidget {
  final ScrollController? scrollController;

  const SearchProductWidget({super.key, this.scrollController});

  @override
  State<SearchProductWidget> createState() => _SearchProductWidgetState();
}

class _SearchProductWidgetState extends State<SearchProductWidget> {
  // ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Consumer<SearchProductController>(
          builder: (context, searchProductController, _) {
        return Column(
          children: [
            // Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 5.0),
            //     child: Row(children: [
            //       Expanded(
            //           child:
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  '${getTranslated('product_list', context)}',
                  style: robotoBold,
                ),
              ),
            ),
            // ),
            //       InkWell(
            //           onTap: () => showModalBottomSheet(
            //               context: context,
            //               isScrollControlled: true,
            //               backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
            //               builder: (c) =>
            //                   const SearchFilterBottomSheet(value: false)),
            //           child: Stack(
            //             children: [
            //               Container(
            //                 padding: const EdgeInsets.symmetric(
            //                     vertical: Dimensions.paddingSizeExtraSmall,
            //                     horizontal: Dimensions.paddingSizeExtraSmall),
            //                 decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(5),
            //                     border: Border.all(
            //                         color: Theme.of(context)
            //                             .hintColor
            //                             .withValues(alpha: .25))),
            //                 child: SizedBox(
            //                     width: 25,
            //                     height: 24,
            //                     child: Image.asset(Images.sort,
            //                         color: Provider.of<ThemeController>(context,
            //                                     listen: false)
            //                                 .darkTheme
            //                             ? Colors.white
            //                             : Theme.of(context).primaryColor)),
            //               ),
            //               if (searchProductController.isSortingApplied)
            //                 CircleAvatar(
            //                   radius: 5,
            //                   backgroundColor: Theme.of(context).primaryColor,
            //                 )
            //             ],
            //           )),
            //       const SizedBox(
            //         width: Dimensions.paddingSizeDefault,
            //       ),
            //       InkWell(
            //           onTap: () => showModalBottomSheet(
            //               context: context,
            //               isScrollControlled: true,
            //               backgroundColor: Colors.transparent,
            //               builder: (c) => const ProductFilterDialog(
            //                     fromShop: false,
            //                   )),
            //           child: Stack(
            //             children: [
            //               Container(
            //                   padding: const EdgeInsets.symmetric(
            //                       vertical: Dimensions.paddingSizeExtraSmall,
            //                       horizontal: Dimensions.paddingSizeExtraSmall),
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(5),
            //                       border: Border.all(
            //                           color: Theme.of(context)
            //                               .hintColor
            //                               .withValues(alpha: .25))),
            //                   child: SizedBox(
            //                       width: 25,
            //                       height: 24,
            //                       child: Image.asset(Images.dropdown,
            //                           color: Provider.of<ThemeController>(
            //                                       context,
            //                                       listen: false)
            //                                   .darkTheme
            //                               ? Colors.white
            //                               : Theme.of(context).primaryColor))),
            //               if (searchProductController.isFilterApplied)
            //                 CircleAvatar(
            //                   radius: 5,
            //                   backgroundColor: Theme.of(context).primaryColor,
            //                 )
            //             ],
            //           ))
            //     ])),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            SearchScrFilterScreen(
                scrollController: widget.scrollController,
                query: searchProductController.searchController.text)

            // SingleChildScrollView(
            //   // controller: widget.scrollController,
            //   child: PaginatedListView(
            //       scrollController: widget.scrollController!,
            //       onPaginate: (offset) async {
            //         print("paggination :::::::::::: ${offset!}");
            //         // await searchProductController.searchProduct(
            //         //     query: "",
            //         //     // categoryIds: ,
            //         //     offset: offset);
            //         final brandId =
            //             Provider.of<BrandController>(context, listen: false)
            //                 .selectedBrandIds;
            //         final authorId = Provider.of<SearchProductController>(
            //                 context,
            //                 listen: false)
            //             .selectedAuthorIds;

            //         String selectedBrandId =
            //             brandId.isNotEmpty ? jsonEncode(brandId) : '[]';
            //         String selectedAuthorId =
            //             authorId.isNotEmpty ? jsonEncode(authorId) : '[]';
            //         final catId = Get.put(VoiceSearchController());
            //         String selectCatId = catId.selectCatId.value.isNotEmpty
            //             ? jsonEncode(catId.selectCatId.value)
            //             : '[]';

            //         await searchProductController.searchProduct(
            //             categoryIds: selectCatId,
            //             brandIds: selectedBrandId,
            //             authorIds: selectedAuthorId,
            //             query: Provider.of<SearchProductController>(context,
            //                     listen: false)
            //                 .searchController
            //                 .text,
            //             offset: offset);
            //       },
            //       totalSize: searchProductController.searchedProduct?.totalSize,
            //       offset: searchProductController.searchedProduct?.offset,
            //       itemView: RepaintBoundary(
            //         child: MasonryGridView.count(
            //           physics: const NeverScrollableScrollPhysics(),
            //           padding: const EdgeInsets.all(0),
            //           crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
            //           shrinkWrap: true,
            //           itemCount: searchProductController
            //               .searchedProduct!.products!.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return ProductWidget(
            //                 productModel: searchProductController
            //                     .searchedProduct!.products![index]);
            //           },
            //         ),
            //       )),
            // ),
          ],
        );
      }),
    );
  }
}
