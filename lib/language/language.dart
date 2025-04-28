import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/language/english.dart';
import 'package:flutter_lovexa_ecommerce/language/es.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ar.dart';
import 'bn.dart';
import 'hindi.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': englishlang,
        'es_ES': eslang,
        'hi_US': hindilang,
        'ar_US': arlang,
        'bn_US': bnlang,
      };
}

class LanguageController extends GetxController {
  var locale = const Locale('en', 'US').obs;
  RxInt selectIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadLanguage(); // Load saved language when app starts
    // final int localIndex = locale.value == Locale('en', 'US') ? 0 : 1;
    // selectIndex.value = localIndex;
  }

  Future<void> changeLanguage(
    String languageCode,
  ) async {
    Locale newLocale;
    if (languageCode == 'en') {
      newLocale = const Locale('en', 'US');
      selectIndex.value = 0;
    } else {
      newLocale = const Locale('hi', 'IN');
      selectIndex.value = 1;
    }

    locale.value = newLocale;
    Get.updateLocale(newLocale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLang = prefs.getString('language');

    if (savedLang != null) {
      changeLanguage(savedLang);
    }
  }
}
