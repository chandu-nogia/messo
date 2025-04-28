import 'package:flutter/material.dart';
// import 'package:flutter_lovexa_ecommerce/localization/app_localization.dart';
import 'package:get/get.dart';

String? getTranslated(String? key, BuildContext context) {
  String? text = key;
  try {
    // text = AppLocalization.of(context)!.translate(key);
    text = "$key".tr;
  } catch (error) {
    text = "$key".tr;
  }
  return text;
}
