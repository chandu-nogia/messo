import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/data/local/cache_response.dart';
import 'package:flutter_lovexa_ecommerce/data/model/api_response.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/domain/services/featured_deal_service_interface.dart';
import 'package:flutter_lovexa_ecommerce/features/product/domain/models/product_model.dart';

import 'package:flutter_lovexa_ecommerce/helper/api_checker.dart';
import 'package:flutter_lovexa_ecommerce/main.dart';
import 'package:flutter_lovexa_ecommerce/utill/app_constants.dart';
// import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../auth/controllers/auth_controller.dart';

class FeaturedDealController extends ChangeNotifier {
  final FeaturedDealServiceInterface featuredDealServiceInterface;
  FeaturedDealController({required this.featuredDealServiceInterface});

  int? _featuredDealSelectedIndex;
  List<Product>? _featuredDealProductList;
  List<Product>? get featuredDealProductList => _featuredDealProductList;
  int? get featuredDealSelectedIndex => _featuredDealSelectedIndex;

  Future<void> getFeaturedDealList(bool reload) async {
    var localData =
        await database.getCacheResponseById(AppConstants.featuredDealUri);

    if (localData != null) {
      _featuredDealProductList = [];
      var featuredDealProductList = jsonDecode(localData.response);
      featuredDealProductList.forEach((featuredDealProduct) =>
          _featuredDealProductList?.add(Product.fromJson(featuredDealProduct)));
      notifyListeners();
    }

    _featuredDealProductList = [];
    ApiResponse apiResponse =
        await featuredDealServiceInterface.getFeaturedDeal();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200 &&
        apiResponse.response!.data.toString() != '{}') {
      _featuredDealProductList = [];
      apiResponse.response!.data.forEach(
          (fDeal) => _featuredDealProductList?.add(Product.fromJson(fDeal)));
      _featuredDealSelectedIndex = 0;

      if (localData != null) {
        await database.updateCacheResponse(
            AppConstants.featuredDealUri,
            CacheResponseCompanion(
              endPoint: const Value(AppConstants.featuredDealUri),
              header: Value(jsonEncode(apiResponse.response!.headers.map)),
              response: Value(jsonEncode(apiResponse.response!.data)),
            ));
      } else {
        await database.insertCacheResponse(
          CacheResponseCompanion(
            endPoint: const Value(AppConstants.featuredDealUri),
            header: Value(jsonEncode(apiResponse.response!.headers.map)),
            response: Value(jsonEncode(apiResponse.response!.data)),
          ),
        );
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void changeSelectedIndex(int selectedIndex) {
    _featuredDealSelectedIndex = selectedIndex;
    notifyListeners();
  }
}

// List<ProductModel> products = [];

class ProductFor {
  var dio = Dio();
  Future<ProductModel> productForYou(int offset,
      {int? categoryId, int? brandId, String? sortBy}) async {
    var headers = {
      'Authorization':
          'Bearer ${Provider.of<AuthController>(GetCtx.context!, listen: false).getUserToken()}'
    };

    final String baseUrl =
        '${AppConstants.baseUrl}/api/v1/products/for-you?offset=$offset&limit=12';
    final String categorys = '$baseUrl&category_id=$categoryId';
    final String brand = '$baseUrl&brand_id=$brandId';
    final String sort = '$baseUrl&sort_by=$sortBy';
    final String sortCategory =
        '$baseUrl&category_id=$categoryId&sort_by=$sortBy';
    final String sortBrand = '$baseUrl&brand_id=$brandId&sort_by=$sortBy';

    final String url;
    if (categoryId != null && sortBy != null) {
      url = sortCategory;
    } else if (brandId != null && sortBy != null) {
      url = sortBrand;
    } else if (categoryId != null) {
      url = categorys;
    } else if (brandId != null) {
      url = brand;
    } else if (sortBy != null) {
      url = sort;
    } else {
      url = baseUrl;
    }

    print("url:::::::::::::: $url");

    var response = await dio.request(url,
        options: Options(
          method: 'GET',
          headers: headers,
        ));
    if (response.statusCode == 200) {
      return ProductModel.fromJson(response.data);
    } else {
      print(response.statusMessage);
      return ProductModel.fromJson({});
    }
  }

  Future<HomeTitleModel> homeTitleApi() async {
    var headers = {
      'Authorization':
          'Bearer ${Provider.of<AuthController>(GetCtx.context!, listen: false).getUserToken()}'
    };

    const String url = '${AppConstants.baseUrl}/api/v1/business-settings';

    print("url:::::::::::::: $url");
    var response = await dio.request(url,
        options: Options(
          method: 'GET',
          headers: headers,
        ));
    if (response.statusCode == 200) {
      print("title :::: ${response.data}");

      return HomeTitleModel.fromJson(response.data);
    } else {
      print(response.statusMessage);
      return HomeTitleModel.fromJson({});
    }
  }
}

class HomeTitleModel {
  String? brandsHeading;
  String? featuredProductsHeading;
  String? newArrivalsHeading;
  String? latestProductsHeading;
  String? productsForYouHeading;
  String? dealOfTheDayHeading;
  String? bestSellingsHeading;
  String? mallLatestProductHeading;
  String? mallAllProductHeading;
  String? image;

  HomeTitleModel(
      {this.brandsHeading,
      this.featuredProductsHeading,
      this.newArrivalsHeading,
      this.latestProductsHeading,
      this.productsForYouHeading,
      this.dealOfTheDayHeading,
      this.bestSellingsHeading,
      this.mallLatestProductHeading,
      this.mallAllProductHeading,
      this.image});

  HomeTitleModel.fromJson(Map<String, dynamic> json) {
    brandsHeading = json['brands_heading'];
    featuredProductsHeading = json['featured_products_heading'];
    newArrivalsHeading = json['new_arrivals_heading'];
    latestProductsHeading = json['latest_products_heading'];
    productsForYouHeading = json['products_for_you_heading'];
    dealOfTheDayHeading = json['deal_of_the_day_heading'];
    bestSellingsHeading = json['best_sellings_heading'];
    mallLatestProductHeading = json['mall_latest_products_heading'];
    mallAllProductHeading = json['mall_all_products_heading'];
    image = json['mob_menu_banner'];
  }
}
