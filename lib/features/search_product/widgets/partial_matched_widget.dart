import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/custom_themes.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/utill/images.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:voice_assistant/voice_assistant.dart';

import '../../home/widgets/search_home_page_widget.dart';
import '../controllers/voice_controller.dart';
import '../screens/infinit_search_screen.dart';

class SearchSuggestion extends StatefulWidget {
  final bool fromCompare;
  final int? id;

  const SearchSuggestion({super.key, this.fromCompare = false, this.id});
  @override
  State<SearchSuggestion> createState() => _SearchSuggestionState();
}

class _SearchSuggestionState extends State<SearchSuggestion> {
  // bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Consumer<SearchProductController>(
          builder: (context, searchProvider, _) {
        return SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Autocomplete(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty ||
                    searchProvider.suggestionModel == null) {
                  return const Iterable<String>.empty();
                } else {
                  return searchProvider.nameList.where((word) => word
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
                }
              },
              optionsViewOpenDirection: OptionsViewOpenDirection.down,
              optionsViewBuilder:
                  (context, Function(String) onSelected, options) {
                return Material(
                    elevation: 0,
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return InkWell(
                              onTap: () {
                                if (widget.fromCompare) {
                                  searchProvider.setSelectedProductId(
                                      index, widget.id);
                                  Navigator.of(context).pop();
                                } else {
                                  searchProvider.searchProduct(
                                      query: option.toString(), offset: 1);
                                  onSelected(option.toString());
                                }
                              },
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Dimensions.paddingSizeSmall),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeDefault),
                                            child: Icon(Icons.history,
                                                color:
                                                    Theme.of(context).hintColor,
                                                size: 25)),
                                        Expanded(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeSmall),
                                                child: SubstringHighlight(
                                                  text: option.toString(),
                                                  textStyle:
                                                      textRegular.copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color!
                                                                  .withValues(
                                                                      alpha:
                                                                          .5),
                                                          fontSize: Dimensions
                                                              .fontSizeLarge),
                                                  term: searchProvider
                                                      .searchController.text,
                                                  textStyleHighlight:
                                                      textMedium.copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color,
                                                          fontSize: Dimensions
                                                              .fontSizeLarge),
                                                ))),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeDefault),
                                            child: Icon(
                                                CupertinoIcons.arrow_up_left,
                                                color:
                                                    Theme.of(context).hintColor,
                                                size: 25))
                                      ])));
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        itemCount: options.length));
              },
              onSelected: (selectedString) {
                if (kDebugMode) {
                  print(selectedString);
                }
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                searchProvider.searchController = controller;
                searchProvider.searchFocusNode = focusNode;

                return Hero(
                  tag: 'search',
                  child: Material(
                    child: TextFormField(
                      controller: controller,
                      focusNode: searchProvider.searchFocusNode,
                      textInputAction: TextInputAction.search,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          searchProvider.getSuggestionProductName(
                              searchProvider.searchController.text.trim());
                        }
                      },
                      onFieldSubmitted: (value) {
                        if (controller.text.trim().isNotEmpty) {
                          // final PaginationController paginationController =
                          //     Get.put(PaginationController());
                          // paginationController.offset.value = 1;
                          searchProvider
                              .saveSearchAddress(controller.text.toString());
                          final _pageController =
                              Get.put(SearchPageController());
                          _pageController.searchText.value =
                              controller.text.toString();
                          _pageController.resetPagination();
                          _pageController.pagingController.refresh();
                          _pageController.pagingController.fetchNextPage();
                          focusNode.unfocus();

                          // searchProvider.searchProduct(
                          //     query: controller.text.toString(), offset: 1);
                        } else {
                          showCustomSnackBar(
                              getTranslated('enter_somethings', context),
                              context);
                        }
                      },
                      style: textMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge),
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.paddingSizeSmall),
                              borderSide: BorderSide(color: Colors.grey[300]!)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.paddingSizeSmall),
                              borderSide: BorderSide(color: Colors.grey[300]!)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.paddingSizeSmall),
                              borderSide: BorderSide(color: Colors.grey[300]!)),
                          hintText: getTranslated('search_product', context),
                          prefixIcon: InkWell(
                            onTap: () {
                              if (controller.text.trim().isNotEmpty) {
                                // final PaginationController
                                //     paginationController =
                                //     Get.put(PaginationController());
                                // paginationController.offset.value = 1;
                                focusNode.unfocus();
                                searchProvider.saveSearchAddress(
                                    controller.text.toString());
                                searchProvider.searchProduct(
                                    query: controller.text.toString(),
                                    offset: 1);
                              } else {
                                showCustomSnackBar(
                                    getTranslated('enter_somethings', context),
                                    context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                  width: 40,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      // color:
                                      //     Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              Dimensions.paddingSizeSmall))),
                                  child: SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeSmall),
                                        child: Image.asset(Images.search,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ))),
                            ),
                          ),
                          suffixIcon: SizedBox(
                            width: controller.text.isNotEmpty ? 110 : 90,
                            child: Row(
                              children: [
                                if (controller.text.isNotEmpty)
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          controller.clear();
                                          searchProvider.cleanSearchProduct(
                                              notify: true);
                                        });
                                      },
                                      child: const Icon(Icons.clear, size: 20)),
                                Container(
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) =>
                                                  VoiceSearchPage(),
                                            );
                                          },
                                          icon: Icon(Icons.mic,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      // SizedBox(width: 8),
                                      InkWell(
                                        //! camera open
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(20)),
                                            ),
                                            builder: (context) {
                                              return Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(16),
                                                height: 200,
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                        "Please select Camera and Galary",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            ImagePick()
                                                                .pickImage(
                                                                    ImageSource
                                                                        .camera);
                                                          },
                                                          child: const Icon(
                                                              Icons.camera_alt),
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            ImagePick().pickImage(
                                                                ImageSource
                                                                    .gallery);
                                                          },
                                                          child: const Icon(
                                                              Icons.photo),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },

                                        child: Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(Dimensions
                                                      .paddingSizeExtraSmall))),
                                          child: Icon(Icons.camera_alt_outlined,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: Dimensions.iconSizeSmall),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
