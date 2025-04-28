// import 'package:flutter/material.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_button_widget.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/slider_product_shimmer_widget.dart';
// import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';
// import 'package:flutter_lovexa_ecommerce/features/product/screens/view_all_product_screen.dart';
// import 'package:flutter_lovexa_ecommerce/features/product/enums/product_type.dart';
// import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/title_row_widget.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';

// import '../../../main.dart';
// import '../../../theme/controllers/theme_controller.dart';
// import '../../../utill/custom_themes.dart';
// import '../../brand/controllers/brand_controller.dart';
// import '../../category/controllers/category_controller.dart';
// import '../../home/screens/product_for_you.dart';
// import '../../product_details/controllers/product_details_controller.dart';
// import '../../search_product/widgets/search_filter_bottom_sheet_widget.dart';
// import 'products_list_widget.dart';

// class LatestProductListWidget extends StatelessWidget {
//   const LatestProductListWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProductController>(builder: (context, prodProvider, child) {
//       return (prodProvider.latestProductList?.isNotEmpty ?? false)
//           ? Column(children: [
//               TitleRowWidget(
//                 // title: getTranslated('latest_products', context),
//                 title: homeTitleModel.latestProductsHeading ?? "",
//                 onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) => AllProductScreen(
//                             productType: ProductType.latestProduct))),
//               ),
//               const SizedBox(height: Dimensions.paddingSizeSmall),
//               // Container(
//               // height: ResponsiveHelper.isTab(context)
//               //     ? MediaQuery.of(context).size.width * .58
//               //     : MediaQuery.of(context).size.width / 1.1,
//               //     child: GridView.builder(
//               //   shrinkWrap: true,
//               //   physics: NeverScrollableScrollPhysics(),
//               //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               //       crossAxisCount: 2),
//               //   itemCount: prodProvider.latestProductList?.length,
//               //   itemBuilder: (context, index) => ProductWidget(
//               //       productModel: prodProvider.latestProductList![index],25
//               //       productNameLine: 1),
//               // )
//               // RepaintBoundary(
//               //   child: RepaintBoundary(
//               //     child: MasonryGridView.count(
//               //       itemCount: prodProvider.latestProductList?.length,
//               //       crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
//               //       padding: const EdgeInsets.all(0),
//               //       physics: const NeverScrollableScrollPhysics(),
//               //       shrinkWrap: true,
//               //       itemBuilder: (BuildContext context, int index) {
//               //         return ProductWidget(
//               //             productModel: prodProvider.latestProductList![index],
//               //             productNameLine: 1);
//               //       },
//               //     ),
//               //   ),
//               // )

//               ProductListWidget(
//                 isHomePage: false,
//                 productType: ProductType.latestProduct,
//                 // scrollController: _scrollController
//               )
//               // CarouselSlider.builder(
//               //   options: CarouselOptions(
//               //     viewportFraction:
//               //         ResponsiveHelper.isTab(context) ? .5 : .65,
//               //     autoPlay: false,
//               //     pauseAutoPlayOnTouch: true,
//               //     pauseAutoPlayOnManualNavigate: true,
//               //     enlargeFactor: 0.2,
//               //     enlargeCenterPage: true,
//               //     pauseAutoPlayInFiniteScroll: true,
//               //     disableCenter: true,
//               //   ),
//               //   itemCount: prodProvider.latestProductList?.length,
//               //   itemBuilder: (context, index, next) {
//               //     return ProductWidget(
//               //         productModel: prodProvider.latestProductList![index],
//               //         productNameLine: 1);
//               //   },
//               // ),
//               // ),
//             ])
//           : prodProvider.latestProductList == null
//               ? const SliderProductShimmerWidget()
//               : const SizedBox();
//     });
//   }
// }

// String? selectedCategory;
// filter_for_you() {
//   final FeatchController productController = Get.put(FeatchController());
//   return Container(
//     height: 40,
//     decoration: BoxDecoration(
//       color:
//           Provider.of<ThemeController>(GetCtx.context!, listen: false).darkTheme
//               ? Color.fromARGB(255, 41, 41, 41)
//               : Colors.white,
//       boxShadow: [
//         BoxShadow(
//           color: Provider.of<ThemeController>(GetCtx.context!, listen: false)
//                   .darkTheme
//               ? Colors.black
//               : const Color.fromARGB(255, 212, 212, 212).withOpacity(0.5),
//           spreadRadius: 1,
//           blurRadius: 5,
//           offset: Offset(0, 3),
//         ),
//       ],
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Consumer<ProductDetailsController>(
//           builder: (context, details, child) => InkWell(
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 backgroundColor:
//                     Provider.of<ThemeController>(context, listen: false)
//                             .darkTheme
//                         ? Colors.black
//                         : Colors.white,
//                 builder: (context) => Consumer<CategoryController>(
//                   builder: (context, categoryProvider, child) {
//                     // Track selected category

//                     return categoryProvider.categoryList.isNotEmpty
//                         ? StatefulBuilder(
//                             // Needed to update selection state
//                             builder: (context, setModalState) {
//                               return SizedBox(
//                                 height: 600,
//                                 child: Column(
//                                   children: [
//                                     const SizedBox(height: 20),
//                                     const Text(
//                                       "Select Category",
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         padding: EdgeInsets.zero,
//                                         itemCount: categoryProvider
//                                             .categoryList.length,
//                                         itemBuilder:
//                                             (BuildContext context, int index) {
//                                           String categoryName = categoryProvider
//                                               .categoryList[index].name!;
//                                           String categoryId = categoryProvider
//                                               .categoryList[index].id!
//                                               .toString();

//                                           return RadioListTile<String>(
//                                             title: Text(categoryName),
//                                             value: categoryId,
//                                             groupValue: selectedCategory,
//                                             onChanged: (String? newValue) {
//                                               setModalState(() {
//                                                 print("value :::: ${newValue}");
//                                                 selectedCategory = newValue;
//                                               });
//                                             },
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: CustomButton(
//                                         onTap: () {
//                                           if (selectedCategory != null) {
//                                             // FeatchController().fetchData(
//                                             //     categoryId: int.parse(
//                                             //         _selectedCategory
//                                             //             .toString()));

//                                             productController.offset = 1;
//                                             productController.clears();
//                                             productController.fetchData(
//                                                 categoryId: int.parse(
//                                                     selectedCategory
//                                                         .toString()));

//                                             Navigator.pop(
//                                                 context, selectedCategory);
//                                             productController.fetchData(
//                                                 categoryId: int.parse(
//                                                     selectedCategory
//                                                         .toString()));
//                                           }
//                                         },
//                                         buttonText: "Submit",
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               );
//                             },
//                           )
//                         : const SizedBox();
//                   },
//                 ),
//               ).then((selectedCategory) {
//                 if (selectedCategory != null) {
//                   // Handle selected category after closing the modal

//                   print("Selected Category: $selectedCategory");
//                 }
//               });
//             },
//             child: const Row(
//               children: [
//                 const Text(
//                   'Category ',
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 const Icon(Icons.keyboard_arrow_down, size: 20),
//               ],
//             ),
//           ),
//         ),
//         Container(color: Colors.grey, width: 0.1),
//         InkWell(
//             onTap: () {
//               showModalBottomSheet(
//                   context: GetCtx.context!,
//                   isScrollControlled: true,
//                   backgroundColor: Provider.of<ThemeController>(GetCtx.context!,
//                               listen: false)
//                           .darkTheme
//                       ? Colors.black
//                       : Colors.white,
//                   builder: (context) => BrandListSelect());
//             },
//             child: const Row(
//               children: const [
//                 Text('Brand', style: TextStyle(fontSize: 14)),
//                 Icon(Icons.keyboard_arrow_down, size: 20),
//               ],
//             )),
//         Container(color: Colors.grey, width: 0.1),
//         InkWell(
//           onTap: () {
//             showModalBottomSheet(
//                 context: GetCtx.context!,
//                 isScrollControlled: true,
//                 backgroundColor:
//                     Provider.of<ThemeController>(GetCtx.context!, listen: false)
//                             .darkTheme
//                         ? Colors.black
//                         : Colors.white,
//                 builder: (context) => SearchFilterBottomSheet()
//                 // SearchFilterBottomSheet()
//                 // SortByWidget()
//                 );
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Sort', style: TextStyle(fontSize: 14)),
//               SizedBox(width: 5),
//               Icon(Icons.sort),
//             ],
//           ),
//         )
//       ],
//     ),
//   );
// }

// List<Map<String, String>> sortList = [
//   {'price_asc': 'Price: Low to High'},
//   {'price_desc': 'Price: High to Low'},
//   {'newest': 'Newest'},
//   {'oldest': 'Oldest'}
// ];
// String? selectedSort;

// class SortByWidget extends StatefulWidget {
//   // final String selectedSort;
//   const SortByWidget({Key? key}) : super(key: key);

//   @override
//   _SortByWidgetState createState() => _SortByWidgetState();
// }

// class _SortByWidgetState extends State<SortByWidget> {
//   final FeatchController productController = Get.put(FeatchController());
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         height: 400,
//         child: Column(children: [
//           SizedBox(height: 20),
//           Text(
//             "Sort",
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.zero,
//               itemCount: sortList.length,
//               itemBuilder: (BuildContext context, int index) {
//                 String key = sortList[index].keys.first;
//                 String value = sortList[index][key]!;

//                 return RadioListTile<String>(
//                   title: Text(value),
//                   value: key,
//                   groupValue: selectedSort,
//                   onChanged: (String? newValue) {
//                     if (newValue != null) {
//                       setState(() {
//                         print("sort value :::: ${newValue}");
//                         selectedSort = newValue;
//                       });
//                       // Navigator.pop(context, newValue); // Return selected value
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: CustomButton(
//                   buttonText: "Submit",
//                   onTap: () {
//                     // if (selectedCategory != null) {
//                     productController.offset = 1;
//                     productController.clears();
//                     productController.fetchData(
//                         categoryId: selectedCategory != null
//                             ? int.parse(selectedCategory.toString())
//                             : null,
//                         brandId: selectedBrand != null
//                             ? int.parse(selectedBrand.toString())
//                             : null,
//                         sortBy: selectedSort);
//                     Navigator.pop(context);

//                     // } else if (selectedCategory == null) {
//                     //   Get.snackbar("Error", "Please select category");

//                     //   Navigator.pop(context);
//                     // } else {
//                     //   // Get.snackbar("Error", "Please select Brand");

//                     //   Navigator.pop(context);
//                     // }

//                     // setState(() {});
//                   }))
//         ]));
//   }
// }

// String? selectedBrand;

// class BrandListSelect extends StatelessWidget {
//   const BrandListSelect({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final FeatchController productController = Get.put(FeatchController());
//     return Consumer<BrandController>(
//       builder: (context, brandProvider, child) {
//         // Track selected category

//         return brandProvider.brandList.isNotEmpty
//             ? StatefulBuilder(
//                 // Needed to update selection state
//                 builder: (context, setModalState) {
//                   return SizedBox(
//                     height: 600,
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 20),
//                         const Text(
//                           "Select Brand",
//                           style: TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                         Expanded(
//                           child: ListView.builder(
//                             padding: EdgeInsets.zero,
//                             itemCount: brandProvider.brandList.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               String brandId =
//                                   brandProvider.brandList[index].id.toString();
//                               String brandName = brandProvider
//                                   .brandList[index].name
//                                   .toString();

//                               return RadioListTile<String>(
//                                 title: Text(brandName),
//                                 value: brandId,
//                                 groupValue: selectedBrand,
//                                 onChanged: (String? newValue) {
//                                   setModalState(() {
//                                     selectedBrand = newValue;
//                                   });
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: CustomButton(
//                             onTap: () {
//                               if (selectedBrand != null) {
//                                 productController.clears();
//                                 // selectedCategory = null;
//                                 productController.offset = 1;

//                                 productController.fetchData(
//                                     categoryId: selectedCategory != null
//                                         ? int.parse(selectedCategory.toString())
//                                         : null,
//                                     brandId:
//                                         int.parse(selectedBrand.toString()));

//                                 Navigator.pop(context, selectedBrand);
//                               }
//                             },
//                             buttonText: "Submit",
//                           ),
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               )
//             : const SizedBox();
//       },
//     );
//   }
// }

// class SearchFilterController extends GetxController {
//   var currentRangeValues = RangeValues(100000, 900000).obs;
//   var selectedSortIndex = 0.obs;

//   void setPriceRange(RangeValues values) {
//     currentRangeValues.value = values;
//   }

//   void setSortIndex(int index) {
//     selectedSortIndex.value = index;
//   }

//   void clearFilters() {
//     currentRangeValues.value = RangeValues(100000, 900000);
//     selectedSortIndex.value = 0;
//   }
// }

// class SearchFilterBottomSheet extends StatelessWidget {
//   final SearchFilterController controller = Get.put(SearchFilterController());

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Container(
//               width: 35,
//               height: 4,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey.shade400,
//               ),
//             ),
//           ),
//           SizedBox(height: 16),

//           // Price Range
//           Text("Price Range",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           Obx(() {
//             return Center(
//               child: Text(
//                 "₹${controller.currentRangeValues.value.start.toInt()} - ₹${controller.currentRangeValues.value.end.toInt()}",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//             );
//           }),

//           Obx(() {
//             return SliderTheme(
//               data: SliderTheme.of(context).copyWith(
//                 activeTrackColor: Colors.blue,
//                 inactiveTrackColor: Colors.blue.shade100,
//                 thumbColor: Colors.blue,
//                 overlayColor: Colors.blue.withOpacity(0.2),
//               ),
//               child: RangeSlider(
//                 values: controller.currentRangeValues.value,
//                 min: 100000,
//                 max: 900000,
//                 divisions: 100,
//                 onChanged: (values) {
//                   controller.setPriceRange(values);
//                 },
//               ),
//             );
//           }),

//           SizedBox(height: 16),

//           // Sort Options
//           Text("Sort",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           Obx(() {
//             return Column(
//               children: List.generate(sortOptions.length, (index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(5),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius:
//                             BorderRadius.circular(Dimensions.paddingSizeSmall),
//                         border: Border.all(
//                             width: 1,
//                             color: Theme.of(context)
//                                 .hintColor
//                                 .withValues(alpha: .1))),
//                     child: RadioListTile<int>(
//                       controlAffinity: ListTileControlAffinity.trailing,
//                       contentPadding: EdgeInsets.zero,
//                       dense: true,
//                       title: Text(sortOptions[index],
//                           style: textRegular.copyWith(
//                               fontSize: Dimensions.fontSizeDefault)),
//                       value: index,
//                       groupValue: controller.selectedSortIndex.value,
//                       onChanged: (value) {
//                         controller.setSortIndex(value!);
//                       },
//                     ),
//                   ),
//                 );
//               }),
//             );
//           }),

//           SizedBox(height: 16),

//           // Buttons
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey.shade300,
//                     foregroundColor: Colors.black,
//                   ),
//                   onPressed: () {
//                     controller.clearFilters();
//                   },
//                   child: Text("Clear"),
//                 ),
//               ),
//               SizedBox(width: 10),
//               Expanded(
//                 child: CustomButton(
//                   onTap: () {
//                     Get.back(); // Close the bottom sheet
//                   },
//                   buttonText: "Apply"
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// const List<String> sortOptions = [
//   "Latest Products",
//   "Alphabetically A-Z",
//   "Alphabetically Z-A",
//   "Low to high price",
//   "High to low price",
// ];
