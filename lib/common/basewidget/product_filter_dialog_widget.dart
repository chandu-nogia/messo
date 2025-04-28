// import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_loader_widget.dart';
// import 'package:flutter_lovexa_ecommerce/features/brand/domain/models/brand_model.dart';
// import 'package:flutter_lovexa_ecommerce/features/category/domain/models/category_model.dart';
// import 'package:flutter_lovexa_ecommerce/features/product/controllers/seller_product_controller.dart';
// import 'package:flutter_lovexa_ecommerce/features/search_product/domain/models/author_model.dart';
// import 'package:flutter_lovexa_ecommerce/features/splash/controllers/splash_controller.dart';
// import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
// import 'package:flutter_lovexa_ecommerce/features/brand/controllers/brand_controller.dart';
// import 'package:flutter_lovexa_ecommerce/features/category/controllers/category_controller.dart';
// import 'package:flutter_lovexa_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_lovexa_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/custom_themes.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
// import 'package:flutter_lovexa_ecommerce/utill/images.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_button_widget.dart';
// import 'package:flutter_lovexa_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
// import 'package:get/get.dart';
import 'package:provider/provider.dart';

// import '../../features/search_product/controllers/voice_controller.dart';
// // import 'paginated_list_view_widget.dart';

class CategoryFilterItem extends StatelessWidget {
  final String? title;
  final bool checked;
  final Function()? onTap;
  const CategoryFilterItem(
      {super.key, required this.title, required this.checked, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                child: Icon(
                    checked
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    color: (checked &&
                            !Provider.of<ThemeController>(context,
                                    listen: false)
                                .darkTheme)
                        ? Theme.of(context).primaryColor
                        : (checked &&
                                Provider.of<ThemeController>(context,
                                        listen: false)
                                    .darkTheme)
                            ? Colors.white
                            : Theme.of(context)
                                .hintColor
                                .withValues(alpha: .5)),
              ),
              Expanded(child: Text(title ?? '', style: textRegular.copyWith())),
            ],
          ),
        ),
      ),
    );
  }
}
