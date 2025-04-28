import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/product_details/widgets/bottom_cart_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/product_details/widgets/product_image_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/product_details/widgets/product_specification_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/product_details/widgets/product_title_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/product_details/widgets/promise_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/product_details/widgets/review_and_specification_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/product_details/widgets/youtube_video_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/review/controllers/review_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/home/shimmers/product_details_shimmer.dart';
import 'package:flutter_lovexa_ecommerce/features/review/widgets/review_section.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/utill/custom_themes.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/paginated_list_view_widget.dart';
import '../../../common/basewidget/product_widget.dart';
import '../../../helper/responsive_helper.dart';
import '../../../theme/controllers/theme_controller.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/images.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/screens/cart_screen.dart';
import '../../dashboard/screens/controller.dart';
import '../../home/screens/bottomsheet.dart';
import '../../search_product/controllers/search_product_controller.dart';
import '../domain/models/product_details_model.dart';

class ProductDetails extends StatefulWidget {
  final int? productId;
  final String? slug;
  final bool isFromWishList;
  final bool isNotification;
  const ProductDetails(
      {super.key,
      required this.productId,
      required this.slug,
      this.isFromWishList = false,
      this.isNotification = false});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<TextSpan> _publishingHouse = [];
  List<TextSpan> _authors = [];

  Size widgetSize = const Size(100, 400);

  _loadData(BuildContext context) async {
    final pages = Get.put(PaginationController());
    pages.valueFalse();
    Provider.of<ProductDetailsController>(context, listen: false)
        .product_clear();
    Provider.of<ProductDetailsController>(context, listen: false)
        .getProductDetails(
            context, widget.productId.toString(), widget.slug.toString());
    Provider.of<ReviewController>(context, listen: false).removePrevReview();
    Provider.of<ProductDetailsController>(context, listen: false)
        .removePrevLink();
    Provider.of<ReviewController>(context, listen: false)
        .getReviewList(widget.productId, widget.slug, context);
    // Provider.of<ProductController>(context, listen: false)
    //     .removePrevRelatedProduct();
    // Provider.of<ProductController>(context, listen: false)
    //     .initRelatedProductList(widget.productId.toString(), context);
    Provider.of<ProductDetailsController>(context, listen: false)
        .getCount(widget.productId.toString(), context);
    Provider.of<ProductDetailsController>(context, listen: false)
        .getSharableLink(widget.slug.toString(), context);
  }

  @override
  void initState() {
    Provider.of<SearchProductController>(context, listen: false)
        .cleanSearchProduct();
    _loadData(context);
    Provider.of<ProductDetailsController>(context, listen: false)
        .selectReviewSection(false, isUpdate: false);
    super.initState();
  }

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    print("product id :::: ${widget.productId!}");
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async {
        if (widget.isNotification) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => const DashBoardScreen()),
              (route) => false);
        } else {
          return;
        }
      },
      child: Scaffold(
        backgroundColor:
            Provider.of<ThemeController>(context, listen: false).darkTheme
                ? Colors.black
                : Colors.white,
        appBar: AppBar(
          backgroundColor:
              Provider.of<ThemeController>(context, listen: false).darkTheme
                  ? Colors.black
                  : Colors.white,
          surfaceTintColor:
              Provider.of<ThemeController>(context, listen: false).darkTheme
                  ? Colors.black
                  : Colors.white,
          title: Text("${getTranslated('product_details', context)}",
              style: textMedium.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              maxLines: 1,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis),
          actions: [
            searchButton(context),
            SizedBox(
                height: 25,
                width: 25,
                child: Stack(children: [
                  InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CartScreen())),
                    child: Image.asset(Images.cartArrowDownImage,
                        color: ColorResources.getPrimary(context)),
                  ),
                  Positioned.fill(
                      child: Container(
                          transform: Matrix4.translationValues(10, -3, 0),
                          child: Align(
                              // alignment: Alignment.topRight,
                              child: Consumer<CartController>(
                                  builder: (context, cart, child) {
                            return Container(
                                height:
                                    ResponsiveHelper.isTab(context) ? 25 : 15,
                                width:
                                    ResponsiveHelper.isTab(context) ? 25 : 15,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorResources.yellow),
                                child: Center(
                                    child: Text(cart.cartList.length.toString(),
                                        style: textRegular.copyWith(
                                            fontSize: 8,
                                            color: ColorResources.black))));
                          }))))
                ])),
            SizedBox(width: 20)
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async => _loadData(context),
          child: Consumer<ProductDetailsController>(
            builder: (context, details, child) {
              if (details.productDetailsModel?.publishingHouse != null &&
                  details.productDetailsModel!.publishingHouse!.isNotEmpty) {
                _publishingHouse = [];
                for (String? houseName
                    in details.productDetailsModel!.publishingHouse!) {
                  _publishingHouse.add(TextSpan(
                      text: '${houseName!} ',
                      style: titilliumSemiBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault)));
                }
              }

              if (details.productDetailsModel?.authors != null &&
                  details.productDetailsModel!.authors!.isNotEmpty) {
                _authors = [];
                for (String? authorName
                    in details.productDetailsModel!.authors!) {
                  _authors.add(TextSpan(
                      text: '${authorName!} ',
                      style: titilliumSemiBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault)));
                }
              }

              List<int> selectedCategoryIdsList = [];
              selectedCategoryIdsList.clear();
              selectedCategoryIdsList = [];
              if (details.productDetailsModel != null) {
                for (CategoryIds category
                    in details.productDetailsModel!.categoryIds!) {
                  selectedCategoryIdsList
                      .add(int.parse(category.id.toString()));
                }
              }
              String selectedCategoryId = selectedCategoryIdsList.isNotEmpty
                  ? jsonEncode(selectedCategoryIdsList)
                  : '[]';
              // Provider.of<SearchProductController>(context, listen: false)
              //     .searchProduct(
              //         categoryIds: selectedCategoryId, query: "", offset: 1);

              return SingleChildScrollView(
                controller: scrollController,
                // physics: const BouncingScrollPhysics(),
                child: !details.isDetails && details != null
                    ? Column(
                        children: [
                          ProductImageWidget(
                              productModel: details.productDetailsModel),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProductTitleWidget(
                                  productModel: details.productDetailsModel,
                                  averageRatting: details
                                          .productDetailsModel?.averageReview ??
                                      "0"),
                              (details.productDetailsModel?.productType ==
                                          'digital' &&
                                      (_publishingHouse.isNotEmpty ||
                                          _authors.isNotEmpty))
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.homePagePadding),
                                      child: RichText(
                                          text: TextSpan(
                                              text: '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                      color:
                                                          const Color.fromRGBO(
                                                              32, 37, 50, 1)),
                                              children: [
                                            if (details.productDetailsModel
                                                        ?.publishingHouse !=
                                                    null &&
                                                details.productDetailsModel!
                                                    .publishingHouse!.isNotEmpty)
                                              TextSpan(
                                                  text:
                                                      "${getTranslated('publishing_housec', context)}",
                                                  style:
                                                      titilliumRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeDefault,
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor)),
                                            ..._publishingHouse,
                                            if (details.productDetailsModel
                                                        ?.publishingHouse !=
                                                    null &&
                                                details
                                                    .productDetailsModel!
                                                    .publishingHouse!
                                                    .isNotEmpty)
                                              WidgetSpan(
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  height: 15.0,
                                                  width: 1.0,
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withValues(alpha: 0.50),
                                                ),
                                              ),
                                            if (details.productDetailsModel
                                                        ?.authors !=
                                                    null &&
                                                details.productDetailsModel!
                                                    .authors!.isNotEmpty)
                                              TextSpan(
                                                  text:
                                                      "${getTranslated('author', context)}",
                                                  style: titilliumRegular
                                                      .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeDefault,
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor)),
                                            ..._authors,
                                          ])),
                                    )
                                  : const SizedBox(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: WidgetContainer(
                                    child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault),
                                      ),
                                      child: const PromiseWidget()),
                                )),
                              ),
                              const ReviewAndSpecificationSectionWidget(),
                              details.isReviewSelected
                                  ? Column(children: [
                                      ReviewSection(details: details),
                                      // _ProductDetailsProductListWidget(
                                      //     scrollController: scrollController),
                                    ])
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        (details.productDetailsModel?.details !=
                                                    null &&
                                                details.productDetailsModel!
                                                    .details!.isNotEmpty)
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    top: Dimensions
                                                        .paddingSizeSmall),
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .paddingSizeSmall),
                                                child:
                                                    ProductSpecificationWidget(
                                                  productSpecification: details
                                                          .productDetailsModel!
                                                          .details ??
                                                      '',
                                                ),
                                              )
                                            : const SizedBox(),
                                        (details.productDetailsModel
                                                        ?.videoUrl !=
                                                    null &&
                                                details.isValidYouTubeUrl(
                                                    details.productDetailsModel!
                                                        .videoUrl!))
                                            ? YoutubeVideoWidget(
                                                url: details
                                                    .productDetailsModel!
                                                    .videoUrl)
                                            : const SizedBox(),
                                        // (details.productDetailsModel != null)
                                        //     ? ShopInfoWidget(
                                        //         sellerId: details
                                        //                     .productDetailsModel!
                                        //                     .addedBy ==
                                        //                 'seller'
                                        //             ? details
                                        //                 .productDetailsModel!
                                        //                 .userId
                                        //                 .toString()
                                        //             : "0")
                                        //     : const SizedBox.shrink(),
                                        const SizedBox(
                                          height: Dimensions.paddingSizeLarge,
                                        ),
                                        // Visibility(
                                        //   visible: selectedCategoryId != null &&
                                        //       selectedCategoryId.isNotEmpty,
                                        //   child:
                                        ReletedProductWidgets(
                                          scrollController: scrollController,
                                          productId: widget.productId,
                                          categoryId: selectedCategoryId ?? '',
                                        ),
                                        // ),

                                        // deleyCategoryvalue(selectedCategoryId),
                                        // (selectedCategoryId != null &&
                                        //         selectedCategoryId.isNotEmpty)
                                        //     ? ReletedProductWidgets(
                                        //         scrollController:
                                        //             scrollController,
                                        //         categoryId: selectedCategoryId,
                                        //       )
                                        //     : SizedBox(),
                                        SizedBox(height: 10),

                                        // _ProductDetailsProductListWidget(
                                        //     scrollController:
                                        //         scrollController),
                                      ],
                                    ),
                            ],
                          ),
                        ],
                      )
                    : const ProductDetailsShimmer(),
                // : const ProductDetailsShimmer(),
              );
            },
          ),
        ),
        bottomNavigationBar: Consumer<ProductDetailsController>(
            builder: (context, details, child) {
          return !details.isDetails
              ? BottomCartWidget(product: details.productDetailsModel)
              : const SizedBox();
        }),
      ),
    );
  }
}
// class _ProductDetailsProductListWidget extends StatelessWidget {
//   const _ProductDetailsProductListWidget({required this.scrollController});

//   final ScrollController scrollController;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProductDetailsController>(
//         builder: (context, productDetailsController, _) {
//       return Column(children: [
//         Consumer<SellerProductController>(
//             builder: (context, sellerProductController, _) {
//           return (sellerProductController.sellerMoreProduct != null &&
//                   sellerProductController.sellerMoreProduct!.products != null &&
//                   sellerProductController
//                       .sellerMoreProduct!.products!.isNotEmpty)
//               ? Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: Dimensions.paddingSizeDefault),
//                   child: TitleRowWidget(
//                     title: getTranslated('more_from_the_shop', context),
//                     onTap: () {
//                       if (productDetailsController
//                               .productDetailsModel?.addedBy ==
//                           'seller') {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => TopSellerProductScreen(
//                                       fromMore: true,
//                                       sellerId: productDetailsController
//                                           .productDetailsModel?.seller?.id,
//                                       temporaryClose: productDetailsController
//                                           .productDetailsModel
//                                           ?.seller
//                                           ?.shop
//                                           ?.temporaryClose,
//                                       vacationStatus: productDetailsController
//                                               .productDetailsModel
//                                               ?.seller
//                                               ?.shop
//                                               ?.vacationStatus ??
//                                           false,
//                                       vacationEndDate: productDetailsController
//                                           .productDetailsModel
//                                           ?.seller
//                                           ?.shop
//                                           ?.vacationEndDate,
//                                       vacationStartDate:
//                                           productDetailsController
//                                               .productDetailsModel
//                                               ?.seller
//                                               ?.shop
//                                               ?.vacationStartDate,
//                                       name: productDetailsController
//                                           .productDetailsModel
//                                           ?.seller
//                                           ?.shop
//                                           ?.name,
//                                       banner: productDetailsController
//                                           .productDetailsModel
//                                           ?.seller
//                                           ?.shop
//                                           ?.bannerFullUrl
//                                           ?.path,
//                                       image: productDetailsController
//                                           .productDetailsModel
//                                           ?.seller
//                                           ?.shop
//                                           ?.imageFullUrl
//                                           ?.path,
//                                     )));
//                       } else {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => TopSellerProductScreen(
//                                     sellerId: 0,
//                                     fromMore: true,
//                                     temporaryClose: Provider.of<SplashController>(context, listen: false)
//                                             .configModel
//                                             ?.inhouseTemporaryClose
//                                             ?.status ==
//                                         1,
//                                     vacationStatus: Provider.of<SplashController>(context, listen: false)
//                                             .configModel
//                                             ?.inhouseVacationAdd
//                                             ?.status ==
//                                         1,
//                                     vacationEndDate: Provider.of<SplashController>(context, listen: false)
//                                         .configModel
//                                         ?.inhouseVacationAdd
//                                         ?.vacationEndDate,
//                                     vacationStartDate:
//                                         Provider.of<SplashController>(context, listen: false)
//                                             .configModel
//                                             ?.inhouseVacationAdd
//                                             ?.vacationStartDate,
//                                     name: Provider.of<SplashController>(context, listen: false)
//                                         .configModel
//                                         ?.companyName,
//                                     banner: Provider.of<SplashController>(context, listen: false)
//                                         .configModel
//                                         ?.companyLogo
//                                         ?.path,
//                                     image: Provider.of<SplashController>(context, listen: false).configModel?.companyIcon)));
//                       }
//                     },
//                   ),
//                 )
//               : const SizedBox();
//         }),
//         Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: Dimensions.paddingSizeSmall),
//             child: ShopMoreProductViewList(
//                 scrollController: scrollController,
//                 sellerId:
//                     productDetailsController.productDetailsModel!.userId!)),
//         Consumer<ProductController>(builder: (context, productController, _) {
//           return (productController.relatedProductList != null &&
//                   productController.relatedProductList!.isNotEmpty)
//               ? Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: Dimensions.paddingSizeExtraSmall),
//                   child: TitleRowWidget(
//                       title: getTranslated('related_products', context),
//                       isDetailsPage: true))
//               : const SizedBox();
//         }),
//         const SizedBox(height: 5),
//         const Padding(
//           padding:
//               EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
//           child: ReletedProductWidget(),
//         ),
//         const SizedBox(height: Dimensions.paddingSizeSmall),
//       ]);
//     });
//   }
// }

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

class ReletedProductWidgets extends StatefulWidget {
  final int? productId;
  final String? categoryId;
  final ScrollController? scrollController;

  const ReletedProductWidgets(
      {super.key,
      this.scrollController,
      this.categoryId,
      required this.productId});

  @override
  State<ReletedProductWidgets> createState() => _ReletedProductWidgetsState();
}

class _ReletedProductWidgetsState extends State<ReletedProductWidgets> {
  @override
  void initState() {
    // Provider.of<SearchProductController>(context, listen: false)
    //     .cleanSearchProduct();
    setState(() {
      Provider.of<SearchProductController>(context, listen: false)
          .searchProduct(categoryIds: widget.categoryId!, query: "", offset: 1);
    });

    // setState(() {});

    // TODO: implement initState
    super.initState();
  }

  final pages = Get.put(PaginationsController());
  @override
  void dispose() {
    pages.valueFalse();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Consumer<SearchProductController>(
          builder: (context, searchProductController, _) {
        final searchedProduct = searchProductController.searchedProduct;
        // final productList = searchedProduct?.products ?? [];

        final productList = (searchedProduct?.products ?? [])
            .where((product) => product.id != widget.productId)
            .toList();

        print("product list 2 ::::: ${productList.length}");

        return searchedProduct == null ||
                productList == null ||
                productList.isEmpty
            ? Center(
                child: CustomButton(
                    onTap: () {
                      BaseController.to.changePage(0);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashBoardScreen()));
                    },
                    buttonText: "Continue Shopping"))
            : PaginatedListView(
                scrollController: widget.scrollController!,
                onPaginate: (offset) async {
                  print("Pagination :::::::::::: ${offset!}");

                  await searchProductController.searchProduct(
                      categoryIds: widget.categoryId ?? '',
                      // brandIds: selectedBrandId,
                      // authorIds: selectedAuthorId,
                      query: "",
                      offset: offset);
                },
                totalSize: searchedProduct.totalSize ?? 0,
                offset: searchedProduct.offset ?? 0,
                itemView: productList.isEmpty
                    ? Center(
                        child: CustomButton(
                            onTap: () {
                              BaseController.to.changePage(0);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashBoardScreen()));
                            },
                            buttonText: "Continue Shopping"))
                    : Obx(
                        () => Column(
                          children: [
                            TitleRowWidget(
                              title: 'Related Products',
                            ),
                            RepaintBoundary(
                                child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              // controller: _scrollController,
                              padding: const EdgeInsets.symmetric().copyWith(
                                  top: Dimensions.paddingSizeExtraSmall),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width > 480
                                        ? 3
                                        : 2,
                                mainAxisExtent:
                                    MediaQuery.of(context).size.height / 3.1,
                              ),
                              itemCount: productList.length,
                              itemBuilder: (context, index) {
                                return ProductWidget(
                                    productModel: productList[index]);
                              },
                            )
                                // MasonryGridView.count(
                                //   physics: const NeverScrollableScrollPhysics(),
                                //   padding: const EdgeInsets.all(0),
                                //   crossAxisCount:
                                //       ResponsiveHelper.isTab(context) ? 3 : 2,
                                //   shrinkWrap: true,
                                //   itemCount: productList.length,
                                //   itemBuilder: (BuildContext context, int index) {
                                //     return ProductWidget(
                                //         productModel: productList[index]);
                                //   },
                                // ),
                                ),
                            if (pages.continous.value == true)
                              CustomButton(
                                  onTap: () {
                                    BaseController.to.changePage(0);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DashBoardScreen()));
                                  },
                                  buttonText: "Continue Shopping")
                          ],
                        ),
                      ),
              );
      }),
    );
  }
}

// class WidgetContainer extends StatefulWidget {
//   final Widget child;
//   const WidgetContainer({super.key, required this.child});

//   @override
//   State<WidgetContainer> createState() => _WidgetContainerState();
// }

// class _WidgetContainerState extends State<WidgetContainer>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Alignment> _tlAlignAnim;
//   late Animation<Alignment> _brAlignAnim;
//   // late Animation<double> _animation;
//   @override
//   void initState() {
//     _controller =
//         AnimationController(vsync: this, duration: Duration(seconds: 2));
//     _tlAlignAnim = TweenSequence<Alignment>([
//       TweenSequenceItem<Alignment>(
//           tween: Tween<Alignment>(
//               begin: Alignment.topRight, end: Alignment.topRight),
//           weight: 1),
//       TweenSequenceItem<Alignment>(
//           tween: Tween<Alignment>(
//               begin: Alignment.topRight, end: Alignment.bottomRight),
//           weight: 1),
//       TweenSequenceItem<Alignment>(
//           tween: Tween<Alignment>(
//               begin: Alignment.bottomRight, end: Alignment.bottomLeft),
//           weight: 1),
//       TweenSequenceItem<Alignment>(
//           tween: Tween<Alignment>(
//               begin: Alignment.bottomLeft, end: Alignment.topLeft),
//           weight: 1)
//     ]).animate(_controller);
//     _brAlignAnim = TweenSequence<Alignment>([
//       TweenSequenceItem<Alignment>(
//           tween: Tween<Alignment>(
//               begin: Alignment.bottomRight, end: Alignment.bottomLeft),
//           weight: 1),
//       TweenSequenceItem<Alignment>(
//           tween: Tween<Alignment>(
//               begin: Alignment.bottomLeft, end: Alignment.topLeft),
//           weight: 1),
//       TweenSequenceItem<Alignment>(
//           tween: Tween<Alignment>(
//               begin: Alignment.topLeft, end: Alignment.topRight),
//           weight: 1),
//       TweenSequenceItem<Alignment>(
//           tween: Tween<Alignment>(
//               begin: Alignment.topRight, end: Alignment.bottomRight),
//           weight: 1)
//     ]).animate(_controller);
//     _controller.repeat();

//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//         animation: _controller,
//         builder: (context, _) {
//           return Container(
//             // padding: const EdgeInsets.only(
//             //     top: Dimensions.paddingSizeLarge,
//             //     bottom: Dimensions.paddingSizeDefault),
//             // height: 100,
//             child: widget.child,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//                 gradient: LinearGradient(
//                     begin: _tlAlignAnim.value,
//                     end: _brAlignAnim.value,
//                     colors: [
//                       ColorResources.yellow,
//                       Theme.of(context).primaryColor
//                     ])),
//           );
//         });
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class WidgetContainer extends StatelessWidget {
  final Widget child;
  const WidgetContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WidgetContainerController>(
      init: WidgetContainerController(),
      builder: (controller) {
        return AnimatedBuilder(
          animation: controller.controller,
          builder: (context, _) {
            return Container(
              child: child,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), // Default radius
                gradient: LinearGradient(
                  begin: controller.tlAlignAnim.value,
                  end: controller.brAlignAnim.value,
                  colors: [Colors.yellow, Theme.of(context).primaryColor],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class WidgetContainerController extends GetxController
    with GetTickerProviderStateMixin {
  // ✅ Use GetTickerProviderStateMixin for multiple animations

  late AnimationController controller;
  late Animation<Alignment> tlAlignAnim;
  late Animation<Alignment> brAlignAnim;

  @override
  void onInit() {
    super.onInit();

    controller = AnimationController(
      vsync: this, // ✅ Now works with multiple tickers
      duration: const Duration(seconds: 2),
    );

    tlAlignAnim = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
    ]).animate(controller);

    brAlignAnim = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
    ]).animate(controller);

    controller.repeat();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
