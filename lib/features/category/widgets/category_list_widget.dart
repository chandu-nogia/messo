import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/category/widgets/category_widget.dart';
import 'package:flutter_lovexa_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

import '../../dashboard/screens/controller.dart';
import '../screens/category_screen.dart';
import 'category_shimmer_widget.dart';

class CategoryListWidget extends StatelessWidget {
  final bool isHomePage;
  const CategoryListWidget({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {
        return Column(children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          categoryProvider.categoryList.isNotEmpty
              ? SizedBox(
                  height: Provider.of<LocalizationController>(context,
                              listen: false)
                          .isLtr
                      ? MediaQuery.of(context).size.width / 3.7
                      : MediaQuery.of(context).size.width / 3,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryProvider.categoryList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Consumer<CategoryController>(
                        builder: (context, value, child) => InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            // Provider.of<PageIndexProvider>(context, listen: false)
                            // .setPage(1, context);
                            categoryProvider.changeSelectedIndex(index);
                            BaseController.to.changePage(1);
                            scrollToCategoryById(value.categoryList[index].id!);

                            // Navigator.push(context, MaterialPageRoute(
                            //     builder: (_) {
                            //   value.changeSelectedIndex(index);

                            //   return CategoryScreen(indexValue: index);
                            // }

                            //     // BrandAndCategoryProductScreen(
                            //     //     isBrand: false,
                            //     //     id: categoryProvider.categoryList[index].id,
                            //     //     name: categoryProvider.categoryList[index].name)

                            //     ));
                          },
                          child: CategoryWidget(
                              category: categoryProvider.categoryList[index],
                              index: index,
                              length: categoryProvider.categoryList.length),
                        ),
                      );
                    },
                  ),
                )
              : const CategoryShimmerWidget(),
        ]);
      },
    );
  }
}
