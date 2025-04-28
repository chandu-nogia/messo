// import 'package:flutter/material.dart';
// import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';
// import 'package:flutter_lovexa_ecommerce/helper/responsive_helper.dart';
// import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/no_internet_screen_widget.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/product_shimmer_widget.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/product_widget.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';

// import '../../deal/controllers/featured_deal_controller.dart';
// import '../../product/domain/models/product_model.dart';

// bool hasMore = true;
// bool _isLoading = false;
// int offset = 1;
// List<Product> products = [];

// class ProductForYou extends StatefulWidget {
//   final bool isHomePage;
//   final ScrollController? scrollController;

//   ProductForYou({super.key, required this.isHomePage, this.scrollController});

//   @override
//   State<ProductForYou> createState() => _ProductForYouState();
// }

// class _ProductForYouState extends State<ProductForYou> {
//   // Ensure products is initialized
//   // final ScrollController _scrollController = ScrollController();
//   @override
//   void initState() {
//     fetchData();
//     setState(() {});
//     widget.scrollController?.addListener(() {
//       // print(":::::::::::::::${widget.scrollController!.position.pixels}");
//       if (widget.scrollController!.position.pixels >=
//           widget.scrollController!.position.maxScrollExtent - 100) {
//         fetchData();
//         setState(() {});
//       }
//       setState(() {});
//     });

//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProductController>(
//       builder: (context, prodProvider, child) {
//         return Column(
//           children: [
//             !prodProvider.filterFirstLoading
//                 ? (products.isNotEmpty && products != null)
//                     ? MasonryGridView.count(
//                         // controller: widget.scrollController!,
//                         itemCount: products.length + (_isLoading ? 1 : 0),
//                         crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
//                         padding: const EdgeInsets.all(0),
//                         physics: const NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemBuilder: (BuildContext context, int index) {
//                           if (index >= products.length) {
//                             return const Center(
//                                 child: CircularProgressIndicator());
//                           }
//                           return ProductWidget(
//                             productModel: products[index],
//                           );
//                         })
//                     : const NoInternetOrDataScreenWidget(isNoInternet: false)
//                 : ProductShimmer(
//                     isHomePage: widget.isHomePage,
//                     isEnabled: prodProvider.firstLoading,
//                   ),
//             prodProvider.filterIsLoading
//                 ? Center(
//                     child: Padding(
//                       padding:
//                           const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           Theme.of(context).primaryColor,
//                         ),
//                       ),
//                     ),
//                   )
//                 : const SizedBox.shrink(),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_lovexa_ecommerce/utill/color_resources.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
// import '../../controllers/featch_controller.dart';
import '../../../common/basewidget/custom_image_widget.dart';
import '../../../main.dart';
import '../../category/controllers/category_controller.dart';
import '../../category/screens/category_screen.dart';
import '../../dashboard/screens/controller.dart';
import '../../deal/controllers/featured_deal_controller.dart';
import '../../product/controllers/product_controller.dart';
import '../../product/domain/models/product_model.dart';
import 'controller.dart';
import 'landing_model.dart';

// class ProductForYou extends StatefulWidget {
//   final bool isHomePage;
//   final ScrollController? scrollController;

//   ProductForYou({super.key, required this.isHomePage, this.scrollController});

//   @override
//   State<ProductForYou> createState() => _ProductForYouState();
// }

// class _ProductForYouState extends State<ProductForYou> {
//   final FeatchController productController = Get.put(FeatchController());

//   @override
//   void initState() {
//     super.initState();
//     // productController.fetchData(); // Initial data fetch
//     // if (selectedCategory != null) {
//     //   productController.fetchData(
//     //       categoryId: int.parse(selectedCategory.toString()));
//     // } else if (selectedBrand != null) {
//     //   productController.fetchData(brandId: int.parse(selectedBrand.toString()));
//     // } else {
//     //   productController.fetchData();
//     // }

//     // Scroll listener to load more data
//     widget.scrollController?.addListener(() {
//       if (!productController.isLoading.value &&
//           productController.hasMore.value &&
//           widget.scrollController!.position.pixels >=
//               widget.scrollController!.position.maxScrollExtent - 100) {
//         if (selectedCategory != null) {
//           productController.fetchData(
//               categoryId: int.parse(selectedCategory.toString()));
//         } else if (selectedBrand != null) {
//           productController.fetchData(
//               brandId: int.parse(selectedBrand.toString()));
//         } else {
//           productController.fetchData();
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (productController.isLoading.value &&
//           productController.products.isEmpty) {
//         return ProductShimmer(
//           isHomePage: widget.isHomePage,
//           isEnabled: productController.isLoading.value,
//         );
//       }

//       return Column(
//         children: [
//           productController.products.isNotEmpty
//               ? MasonryGridView.count(
//                   itemCount: productController.products.length +
//                       (productController.isLoading.value ? 1 : 0),
//                   crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
//                   padding: const EdgeInsets.all(0),
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   // controller: widget.scrollController!,
//                   itemBuilder: (context, index) {
//                     if (index >= productController.products.length) {
//                       return const Center(child: SizedBox());
//                     }
//                     return ProductWidget(
//                       productModel: productController.products[index],
//                     );
//                   },
//                 )
//               : const NoInternetOrDataScreenWidget(isNoInternet: false),

//           // Loading indicator
//           productController.isLoading.value
//               ? Padding(
//                   padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                         Theme.of(context).primaryColor),
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ],
//       );
//     });
//   }
// }

class FeatchController extends GetxController {
  RxList<Product> products = <Product>[].obs; // Observable list
  var isCategory = false.obs;

  var isLoading = false.obs;
  var hasMore = true.obs;
  int offset = 1;
  Rx<ScrollController> scrollController = ScrollController().obs;

  scrolltoTap(int index) {
    scrollController.value.animateTo(index * 100,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  clears() {
    products.value.clear();
    products.value = [];
  }

  Future<void> fetchData(
      {int? categoryId, int? brandId, String? sortBy}) async {
    if (isLoading.value || !hasMore.value)
      return; // Prevent multiple calls at the same time

    isLoading.value = true;

    try {
      ProductModel? newProducts = await ProductFor().productForYou(
        offset,
        brandId: brandId,
        categoryId: categoryId,
        sortBy: sortBy,
      );

      if (newProducts.products != null && newProducts.products!.isNotEmpty) {
        print("new product ::::: ${newProducts}");
        // Remove duplicates before adding new products
        List<Product> uniqueProducts = newProducts.products!
            .where((newProduct) => !products.contains(newProduct))
            .toList();

        if (uniqueProducts.isNotEmpty) {
          // print("new product data ::::: ${newProducts}");
          products.addAll(uniqueProducts);
          offset++; // Only increase offset if new unique data is added
        } else {
          print("new product no ::::: ${newProducts}");
          // hasMore.value = false; // Stop fetching if no new unique data is found
        }
      } else {
        print("new product no any one ::::: ${newProducts}");
        // hasMore.value =
        //     false; // Stop fetching if no more products are available
      }
    } catch (error) {
      print("Error fetching data: $error");
    }

    isLoading.value = false;
  }

  hometitle_Api() async {
    try {
      HomeTitleModel? titleRes = await ProductFor().homeTitleApi();
      if (titleRes != null) {
        homeTitleModel = titleRes;
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }
}

HomeTitleModel homeTitleModel = HomeTitleModel.fromJson({});

class HomeSliderScreen extends StatefulWidget {
  final LandingModel? data;

  const HomeSliderScreen({super.key, this.data});
  @override
  State<HomeSliderScreen> createState() => _HomeSliderScreenState();
}

class _HomeSliderScreenState extends State<HomeSliderScreen> {
  //  CarouselController _carouselController = CarouselController(initialItem: );
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int currentIndex = 0;
  final controller = Get.put(LandingController());
  final categorys =
      Provider.of<CategoryController>(GetCtx.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Text('LOVEXA',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Colors.black,
          centerTitle: true),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      GetCtx.context!,
                      MaterialPageRoute(
                          builder: (_) => const DashBoardScreen()),
                      (route) => false);
                  BaseController.to.changePage(2);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 4.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: CustomImageWidget(
                      image: controller.data.value!.lovexaMallBannerFullUrl!
                      // categoryImageList[0]['image']!,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: GestureDetector(
                onTap: () {
                  controller.clickBannerRedirect(
                      context,
                      int.parse(controller
                          .data.value!.landingCustomBanner!.resourceId!),
                      controller
                          .data.value!.landingCustomBanner!.resourceType!);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 4.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: CustomImageWidget(
                      image: controller
                          .data.value!.landingCustomBanner!.bannerFullUrl!
                      // categoryImageList[0]['image']!,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 4),

            /// ✅ Carousel
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        height: double.infinity,
                        // aspectRatio: 16 / 14,

                        autoPlayInterval: Duration(seconds: 2),
                        // height: 300.0,
                        // enlargeCenterPage: true,
                        autoPlay: true,
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                      items: controller.data.value!.categories
                          .take(10)
                          .map((item) {
                        return InkWell(
                          onTap: () {
                            // Future.delayed(Duration(seconds: 1), () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const CategoryScreen(back: true)));
                            Navigator.pushAndRemoveUntil(
                                GetCtx.context!,
                                MaterialPageRoute(
                                    builder: (_) => const DashBoardScreen()),
                                (route) => false);
                            BaseController.to.changePage(1);

                            final ids = categorys.categoryList
                                .indexWhere((element) => element.id == item.id);
                            categorys.changeSelectedIndex(ids);

                            // scrollToCategoryById(ids);
                          },
                          child: SizedBox.expand(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CustomImageWidget(
                                  image: item.bannerFullUrl!,
                                  fit: BoxFit.cover),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Positioned.fill(
                    bottom: MediaQuery.of(context).size.height / 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${controller.data.value!.categories[currentIndex].name}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            weight: 2, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.height / 80),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 2.0,
                        children: controller.data.value!.categories
                            .asMap()
                            .entries
                            .take(10)
                            .map((entry) {
                          final index = entry.key;
                          final category = entry.value;

                          return GestureDetector(
                            onTap: () {
                              // final controller = Get.put(LandingController());
                              // controller.fetchData();
                              setState(() {
                                currentIndex = index;
                              });
                              // Provider.of<ProductController>(context,
                              //         listen: false)
                              //     .getHomeCategoryProductList(true);
                              // Future.delayed(Duration(seconds: 1), () {
                              final ids = categorys.categoryList.indexWhere(
                                  (element) => element.id == category.id);
                              Navigator.pushAndRemoveUntil(
                                  GetCtx.context!,
                                  MaterialPageRoute(
                                      builder: (_) => const DashBoardScreen()),
                                  (route) => false);
                              BaseController.to.changePage(1);
                              Future.delayed(const Duration(seconds: 1), () {
                                categorys.changeSelectedIndex(ids);
                              });

                              // });
                              // BaseController.to.changePage(1);

                              // Future.delayed(Duration(seconds: 3), () {
                              // _carouselController.animateToPage(index);

                              // });

                              _carouselController.animateToPage(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: index == currentIndex
                                          ? Colors.black
                                          : ColorResources.white,
                                      width: 0.18),
                                  color: index == currentIndex
                                      ? const Color(0xFF1B1A16)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 1.3),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height:
                                        MediaQuery.of(context).size.height / 25,
                                    width:
                                        MediaQuery.of(context).size.width / 6.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: index == currentIndex
                                              ?const Color(0xFF1B1A16)
                                              : ColorResources.white,
                                          width: 0.5),
                                      color: index == currentIndex
                                          ? const Color(0xFF1B1A16)
                                          : 
                                          // Colors.brown.withOpacity(0.9),
                                         const Color(0xFF53504C).withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        category.name!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: index == currentIndex
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: index == currentIndex
                                              ? Colors.white
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// ✅ Category Buttons synced with slider
            ///
          ],
        ),
      ),
    );
  }
}
