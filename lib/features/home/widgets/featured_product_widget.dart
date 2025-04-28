// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/product_widget.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/slider_product_shimmer_widget.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/title_row_widget.dart';
// import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';
// import 'package:flutter_lovexa_ecommerce/features/product/enums/product_type.dart';
// import 'package:flutter_lovexa_ecommerce/features/product/screens/view_all_product_screen.dart';
// import 'package:flutter_lovexa_ecommerce/helper/responsive_helper.dart';
// import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
// import 'package:provider/provider.dart';

// import '../screens/product_for_you.dart';

// class FeaturedProductWidget extends StatefulWidget {
//   const FeaturedProductWidget({super.key});

//   @override
//   State<FeaturedProductWidget> createState() => _FeaturedProductWidgetState();
// }

// class _FeaturedProductWidgetState extends State<FeaturedProductWidget> {
//   // final FeatchController productCTr = Get.put(FeatchController());
//   final ScrollController _scrollController = ScrollController();
//   int _currentIndex = 0;
//   Timer? _timer;

//   List productList = [];
//   @override
//   void initState() {
//     super.initState();
//     _startAutoScroll();
//   }

//   void _startAutoScroll() {
//     _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
//       if (_currentIndex < productList.length - 1) {
//         _currentIndex++;
//       } else {
//         _currentIndex = 0;
//       }

//       _scrollController.animateTo(
//         _currentIndex * 120.0, // Adjust based on item height
//         duration: Duration(milliseconds: 500),
//         curve: Curves.ease,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProductController>(
//         builder: (context, productController, _) {
//       return ((productController.featuredProductList != null &&
//               productController.featuredProductList!.isNotEmpty))
//           ? Column(children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: Dimensions.paddingSizeExtraSmall,
//                   vertical: Dimensions.paddingSizeExtraSmall,
//                 ),
//                 child: TitleRowWidget(
//                   // title: getTranslated('featured_products', context),
//                   title: homeTitleModel.featuredProductsHeading ?? '',
//                   onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => AllProductScreen(
//                               productType: ProductType.featuredProduct))),
//                 ),
//               ),
//               SizedBox(
//                 height: ResponsiveHelper.isTab(context)
//                     ? MediaQuery.of(context).size.width * .58
//                     : MediaQuery.of(context).size.width / 1.9,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemExtent: 130,
//                   shrinkWrap: true,
//                   controller: _scrollController,
//                   itemCount: productController.featuredProductList?.length,
//                   itemBuilder: (context, index) {
//                     productList = productController.featuredProductList!;
//                     return ProductWidget(
//                         productModel:
//                             productController.featuredProductList![index],
//                         productNameLine: 1);
//                   },
//                 ),
//               ),
//             ])
//           : productController.featuredProductList == null
//               ? const SliderProductShimmerWidget()
//               : const SizedBox();
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/product/domain/models/product_model.dart';
import 'package:get/get.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/slider_product_shimmer_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';
// import 'package:flutter_lovexa_ecommerce/features/product/controllers/featured_product_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_lovexa_ecommerce/features/product/screens/view_all_product_screen.dart';
import 'package:flutter_lovexa_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../screens/product_for_you.dart';

class FeaturedProductWidget extends StatelessWidget {
  FeaturedProductWidget({super.key});

  // final productController = Get.find<ProductController>();
  final featuredController = Get.put(FeaturedProductController());

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
        builder: (context, productController, _) {
      return ((productController.featuredProductList != null &&
              productController.featuredProductList!.isNotEmpty))
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraSmall,
                    vertical: Dimensions.paddingSizeExtraSmall,
                  ),
                  child: TitleRowWidget(
                    // title: getTranslated('featured_products', context),
                    title: homeTitleModel.featuredProductsHeading ??
                        'Featured Products',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AllProductScreen(
                                productType: ProductType.featuredProduct))),
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.isTab(context)
                      ? MediaQuery.of(context).size.width * .58
                      : MediaQuery.of(context).size.height / 3.8,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemExtent: 130,
                    shrinkWrap: true,
                    controller: featuredController.scrollController,
                    itemCount: productController.featuredProductList?.length,
                    itemBuilder: (context, index) {
                      featuredController.productList.value =
                          productController.featuredProductList!;
                      return ProductWidget(
                          productModel:
                              productController.featuredProductList![index],
                          productNameLine: 1);
                    },
                  ),
                ),
              ],
            )
          : productController.featuredProductList == null
              ? const SliderProductShimmerWidget()
              : const SizedBox();
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';

// class FeaturedProductController extends GetxController {
//   final ScrollController scrollController = ScrollController();
//   int currentIndex = 0;
//   Timer? _timer;
//   var productList = <Product>[].obs;

//   // List get productList =>
//   //     Get.find<ProductController>().featuredProductList ?? [];

//   @override
//   void onInit() {
//     super.onInit();
//     _startAutoScroll();
//   }

//   void _startAutoScroll() {
//     _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
//       if (productList.isEmpty) return;
//       int lengths = productList.length > 8 ? 8 : productList.length - 1;

//       if (currentIndex < lengths) {
//         currentIndex++;
//       } else {
//         currentIndex = 0;
//       }

//       scrollController.animateTo(
//         currentIndex * 120.0,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.ease,
//       );
//     });
//   }

//   @override
//   void onClose() {
//     _timer?.cancel();
//     scrollController.dispose();
//     super.onClose();
//   }
// }

class FeaturedProductController extends GetxController {
  final ScrollController scrollController = ScrollController();
  int currentIndex = 0;
  var productList = <Product>[].obs;
  bool _isAutoScrolling = false;

  @override
  void onInit() {
    super.onInit();
    _startAutoScroll();
  }

  void _startAutoScroll() async {
    _isAutoScrolling = true;

    while (_isAutoScrolling) {
      if (productList.isNotEmpty) {
        int lengths = productList.length > 8 ? 8 : productList.length - 1;

        if (currentIndex < lengths) {
          currentIndex++;
        } else {
          currentIndex = 0;
        }

        scrollController.animateTo(
          currentIndex * 120.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }

      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  void onClose() {
    _isAutoScrolling = false;
    scrollController.dispose();
    super.onClose();
  }
}

// class BestSellingProductController extends GetxController {
//   final ScrollController scrollController = ScrollController();
//   int currentIndex = 0;
//   Timer? _timer;
//   var productList = <Product>[].obs;

//   // List get productList =>
//   //     Get.find<ProductController>().featuredProductList ?? [];

//   @override
//   void onInit() {
//     super.onInit();
//     _startAutoScroll();
//   }

//   void _startAutoScroll() {
//     _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
//       if (productList.isEmpty) return;
//       int lengths = productList.length > 8 ? 8 : productList.length - 1;

//       if (currentIndex < lengths) {
//         currentIndex++;
//       } else {
//         currentIndex = 0;
//       }

//       scrollController.animateTo(
//         currentIndex * 120.0,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.ease,
//       );
//     });
//   }

//   @override
//   void onClose() {
//     _timer?.cancel();
//     scrollController.dispose();
//     super.onClose();
//   }
// }

class BestSellingProductController extends GetxController {
  final ScrollController scrollController = ScrollController();
  int currentIndex = 0;
  var productList = <Product>[].obs;
  bool _isAutoScrolling = false;

  @override
  void onInit() {
    super.onInit();
    _startAutoScroll();
  }

  void _startAutoScroll() async {
    _isAutoScrolling = true;

    while (_isAutoScrolling) {
      if (productList.isNotEmpty) {
        int lengths = productList.length > 8 ? 8 : productList.length - 1;

        if (currentIndex < lengths) {
          currentIndex++;
        } else {
          currentIndex = 0;
        }

        scrollController.animateTo(
          currentIndex * 120.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }

      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  void onClose() {
    _isAutoScrolling = false;
    scrollController.dispose();
    super.onClose();
  }
}

class FlashSellingProductController extends GetxController {
  final ScrollController scrollController = ScrollController();
  int currentIndex = 0;
  var productList = <Product>[].obs;
  bool _isAutoScrolling = false;

  @override
  void onInit() {
    super.onInit();
    _startAutoScroll();
  }

  void _startAutoScroll() async {
    _isAutoScrolling = true;

    while (_isAutoScrolling) {
      if (productList.isNotEmpty) {
        int lengths = productList.length > 8 ? 8 : productList.length - 1;

        if (currentIndex < lengths) {
          currentIndex++;
        } else {
          currentIndex = 0;
        }

        scrollController.animateTo(
          currentIndex * 120.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }

      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  void onClose() {
    _isAutoScrolling = false;
    scrollController.dispose();
    super.onClose();
  }
}
// class FlashSellingProductController extends GetxController {
//   final ScrollController scrollController = ScrollController();
//   int currentIndex = 0;
//   Timer? _timer;
//   var productList = <Product>[].obs;

//   // List get productList =>
//   //     Get.find<ProductController>().featuredProductList ?? [];

//   @override
//   void onInit() {
//     super.onInit();
//     _startAutoScroll();
//   }

//   void _startAutoScroll() {
//     _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
//       if (productList.isEmpty) return;
//       int lengths = productList.length > 8 ? 8 : productList.length - 1;

//       if (currentIndex < lengths) {
//         currentIndex++;
//       } else {
//         currentIndex = 0;
//       }

//       scrollController.animateTo(
//         currentIndex * 120.0,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.ease,
//       );
//     });
//   }

//   @override
//   void onClose() {
//     _timer?.cancel();
//     scrollController.dispose();
//     super.onClose();
//   }
// }
