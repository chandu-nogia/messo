import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/custom_themes.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/custom_app_bar_widget.dart';
import '../../../main.dart';
import '../../search_product/controllers/voice_controller.dart';
import '../../search_product/screens/search_product_screen.dart';

class SearchHomePageWidget extends StatelessWidget {
  const SearchHomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Provider.of<ThemeController>(context, listen: false).darkTheme
          ? Colors.black
          : Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeExtraExtraSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.homePagePadding,
              vertical: Dimensions.paddingSizeSmall),
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(
                left:
                    Provider.of<LocalizationController>(context, listen: false)
                            .isLtr
                        ? Dimensions.homePagePadding
                        : Dimensions.paddingSizeExtraSmall,
                right:
                    Provider.of<LocalizationController>(context, listen: false)
                            .isLtr
                        ? Dimensions.paddingSizeExtraSmall
                        : Dimensions.homePagePadding),
            height: 60,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color:
                  Provider.of<ThemeController>(context, listen: false).darkTheme
                      ? Colors.black
                      : Colors.white,
              // boxShadow: Provider.of<ThemeController>(context).darkTheme ? null :
              // [BoxShadow(color: Theme.of(context).primaryColor, spreadRadius: 1, blurRadius: 1, offset: const Offset(0,0))],
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius:
                  BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            ),
            child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.search,
                        color: Theme.of(context).primaryColor,
                        size: Dimensions.iconSizeSmall),
                  ),
                  Text(getTranslated('search_hint', context) ?? '',
                      style: textRegular.copyWith(
                          color: Theme.of(context).hintColor)),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SearchScreen()));
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => VoiceSearchPage(),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(
                              Dimensions.paddingSizeExtraSmall))),
                      child: Icon(Icons.mic,
                          color: Theme.of(context).primaryColor,
                          size: Dimensions.iconSizeSmall),
                    ),
                  ),
                  InkWell(
                    //! camera open
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SearchScreen()));
                    },

                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(
                              Dimensions.paddingSizeExtraSmall))),
                      child: Icon(Icons.camera_alt_outlined,
                          color: Theme.of(context).primaryColor,
                          size: Dimensions.iconSizeSmall),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class ImagePick {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    // final XFile? camera = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      _imageFile = File(image.path);
      Navigator.push(GetCtx.context!,
          MaterialPageRoute(builder: (context) => NoDataScreen()));
    }
  }
}

class NoDataScreen extends StatelessWidget {
  const NoDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeController>(context, listen: false).darkTheme
              ? Colors.black
              : Colors.white,
      appBar: CustomAppBar(title: getTranslated('', context)),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("No data found")],
        ),
      ),
    );
  }
}
