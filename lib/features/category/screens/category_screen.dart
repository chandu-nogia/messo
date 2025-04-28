import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/product/screens/brand_and_category_product_screen.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_lovexa_ecommerce/main.dart';
import 'package:flutter_lovexa_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/color_resources.dart';
import 'package:flutter_lovexa_ecommerce/utill/custom_themes.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/no_internet_screen_widget.dart';
import '../../../utill/images.dart';
import '../../dashboard/screens/controller.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../home/screens/bottomsheet.dart';
import '../../home/screens/product_for_you.dart';

class CategoryScreen extends StatefulWidget {
  final bool back;
  final int? indexValue;
  const CategoryScreen({super.key, this.indexValue, this.back = true});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      Provider.of<ProductController>(GetCtx.context!, listen: false)
          .getHomeCategoryProductList(true);
      Provider.of<ProductController>(GetCtx.context!, listen: false)
          .initBrandOrCategoryProductList(
              isBrand: false,
              id: Provider.of<CategoryController>(GetCtx.context!,
                      listen: false)
                  .categoryList[0]
                  .id,
              offset: 1,
              isUpdate: false);

      Future.delayed(const Duration(milliseconds: 300), () {
        final indx =
            Provider.of<CategoryController>(GetCtx.context!, listen: false)
                .categorySelectedIndex;
        scroll.scrolltoTap(indx);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    scroll.isCategory.value = false;
    Future.delayed(const Duration(milliseconds: 300), () {
      Provider.of<CategoryController>(GetCtx.context!, listen: false)
          .changeSelectedIndex(0);
      // scrollToCategoryById(category.id!);
    });
    // TODO: implement dispose
    super.dispose();
  }

  final scroll = Get.put(FeatchController());
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DashBoardScreen()));
        return;
      },
      child: Scaffold(
        backgroundColor:
            Provider.of<ThemeController>(context, listen: false).darkTheme
                ? Colors.black
                : Colors.white,
        appBar: CustomAppBar(
            reset: searchButton(context),
            showResetIcon: true,
            onBackPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashBoardScreen()));
            },
            isBackButtonExist: widget.back,
            title: getTranslated('CATEGORY', context)),
        body: Consumer<CategoryController>(
          builder: (context, categoryProvider, child) {
            int selectedIndex = categoryProvider.categorySelectedIndex;
            CategoryModel selectedCategory =
                categoryProvider.categoryList[selectedIndex];

            return (categoryProvider.categoryList.isNotEmpty &&
                    categoryProvider.categorySelectedIndex != null)
                ? Stack(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 80,
                                margin: const EdgeInsets.only(top: 3),
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).highlightColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[
                                              Provider.of<ThemeController>(
                                                          context)
                                                      .darkTheme
                                                  ? 700
                                                  : 200]!,
                                          spreadRadius: 1,
                                          blurRadius: 1)
                                    ]),
                                child: Obx(
                                  () => ListView.builder(
                                      controller: scroll.scrollController.value,
                                      itemCount:
                                          categoryProvider.categoryList.length,
                                      padding: const EdgeInsets.all(0),
                                      itemBuilder: (context, index) {
                                        // for (var cat
                                        //     in categoryProvider.categoryList) {
                                        itemKeys[categoryProvider
                                            .categoryList[index]
                                            .id!] = GlobalKey();
                                        // }
                                        // itemKeys.putIfAbsent(
                                        //     categoryProvider
                                        //         .categoryList[index].id!,
                                        //     () => GlobalKey());
                                        CategoryModel category =
                                            categoryProvider
                                                .categoryList[index];
                                        return InkWell(
                                            onTap: () {
                                              categoryProvider
                                                  .changeSelectedIndex(index);
                                              scrollToCategoryById(
                                                  category.id!);
                                              // scroll.scrolltoTap(index);
                                            },
                                            child: CategoryItem(
                                                key: itemKeys[category.id!],
                                                title: "${category.name}",
                                                icon:
                                                    "${category.imageFullUrl?.path}",
                                                isSelected: categoryProvider
                                                        .categorySelectedIndex ==
                                                    index));
                                      }),
                                )),
                            Expanded(
                                child: SingleChildScrollView(
                                    child:
                                        //  categoryProvider
                                        //             .categoryList[categoryProvider
                                        //                 .categorySelectedIndex!]
                                        selectedCategory
                                                .subCategories!.isNotEmpty
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                    Ink(
                                                        color: Theme.of(context)
                                                            .highlightColor,
                                                        child: GridView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: categoryProvider
                                                                .categoryList[
                                                                    categoryProvider
                                                                        .categorySelectedIndex!]
                                                                .subCategories!
                                                                .length,
                                                            gridDelegate:
                                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount:
                                                                        3),
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              late SubCategory
                                                                  subCategory;
                                                              subCategory = categoryProvider
                                                                  .categoryList[
                                                                      categoryProvider
                                                                          .categorySelectedIndex]
                                                                  .subCategories![index];
                                                              return InkWell(
                                                                  onTap: () {
                                                                    categoryProvider
                                                                        .changeSubCatSelectedIndex(
                                                                            index);
                                                                    BaseController.to.addValue(
                                                                        subCategory
                                                                            .id!,
                                                                        subCategory
                                                                            .name!);
                                                                    // Get.toNamed(
                                                                    //     '/home/subCategory',
                                                                    //     id: NavIds
                                                                    //         .category);
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => BrandAndCategoryProductScreen(
                                                                              isBrand: false,
                                                                              id: BaseController.to.id!.value,
                                                                              name: BaseController.to.name!.value),
                                                                        ));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          child:
                                                                              Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                                                            Container(
                                                                                height: 50,
                                                                                width: 50,
                                                                                decoration: BoxDecoration(color: ColorResources.circulColor, borderRadius: BorderRadius.circular(100)),
                                                                                child: ClipRRect(borderRadius: BorderRadius.circular(100), child: CustomImageWidget(fit: BoxFit.cover, image: "${subCategory.image!.path}"))),
                                                                            Text("${subCategory.name}",
                                                                                maxLines: 2,
                                                                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                                                                overflow: TextOverflow.ellipsis,
                                                                                textAlign: TextAlign.center)
                                                                          ])));
                                                            }))
                                                  ])
                                            : const Center(
                                                child: NoInternetOrDataScreenWidget(
                                                    isNoInternet: false,
                                                    icon: Images.noProduct,
                                                    message:
                                                        'no_product_found')))),
                          ]),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)));
          },
        ),
      ),
    );
  }
}

final Map<int, GlobalKey> itemKeys = {};
Future<void> scrollToCategoryById(int id) async {
  final key = itemKeys[id];
  if (key != null) {
    return await Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.2, // Center item if needed
    );
  } else {
    scrollToCategoryById(id);
  }
}

class CategoryItem extends StatelessWidget {
  final String? title;
  final String? icon;
  final bool isSelected;
  const CategoryItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall, horizontal: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? ColorResources.getPrimary(context) : null),
      child: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: ColorResources.circulColor,
                  border: Border.all(
                      width: 1,
                      color: isSelected
                          ? Theme.of(context).highlightColor
                          : Colors.white),
                  borderRadius: BorderRadius.circular(100)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CustomImageWidget(fit: BoxFit.cover, image: '$icon'))),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeExtraSmall),
            child: Text(title!,
                maxLines: 2,
                style: textRegular.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: Dimensions.fontSizeSmall,
                  color: isSelected
                      ? Theme.of(context).highlightColor
                      : ColorResources.getTextTitle(context),
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center),
          ),
        ]),
      ),
    );
  }
}


// class CategoryPageController extends GetxController {
//   final Map<int, GlobalKey> itemKeys = {};
//   int? scrollTargetId;

//   void setScrollTarget(int id) {
//     scrollTargetId = id;
//   }

//   Future<void> scrollToCategoryById() async {
//     final id = scrollTargetId;
//     if (id == null) return;

//     final key = itemKeys[id];
//     if (key != null && key.currentContext != null) {
//       await Scrollable.ensureVisible(
//         key.currentContext!,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         alignment: 0.2,
//       );
//     }
//   }
// }


// class CategoryPage extends StatefulWidget {
//   @override
//   State<CategoryPage> createState() => _CategoryPageState();
// }

// class _CategoryPageState extends State<CategoryPage> {
//   final controller = Get.find<CategoryPageController>();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.scrollToCategoryById();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: 20,
//       itemBuilder: (context, index) {
//         controller.itemKeys.putIfAbsent(index, () => GlobalKey());

//         return Container(
//           key: controller.itemKeys[index],
//           padding: const EdgeInsets.all(20),
//           child: Text("Item $index"),
//         );
//       },
//     );
//   }
// }


// final controller = Get.put(CategoryPageController());
// controller.setScrollTarget(7); // your item id
// Get.to(() => CategoryPage()); // the detail page
