import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../brand/controllers/brand_controller.dart';
import '../../category/controllers/category_controller.dart';
import '../../category/screens/category_screen.dart';
import '../../dashboard/screens/controller.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../product/screens/brand_and_category_product_screen.dart';
import '../../product_details/screens/product_details_screen.dart';
import 'landing_model.dart';
import 'product_for_you.dart';

enum Status { loading, success, error, noInternet }

class LandingController extends GetxController {
  var status = Status.loading.obs;
  // LandingModel? data;
  Rx<LandingModel?> data = Rx<LandingModel?>(null);

  var errorMessage = ''.obs;
  var dio = Dio();
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      status.value = Status.loading;

      // Simulate internet check (use actual connectivity logic in real apps)
      final hasInternet = await checkInternet();
      if (!hasInternet) {
        status.value = Status.noInternet;
        return;
      }

      // Simulate API call
      // final response = await ApiService.getData();

      final response = await dio.get(
        'https://lovexa.ai/api/v1/landing-screen',
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        data.value = LandingModel.fromJson(response.data);
        print(
            "response.data ${data.value?.categories[0].name} :: ${response.data}");

        // data.value = response.data;
        status.value = Status.success;
      } else {
        errorMessage.value = 'Something went wrong';
        status.value = Status.error;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      status.value = Status.error;
    }
  }

  void clickBannerRedirect(BuildContext context, int? id, String? type) {
    final cIndex = Provider.of<CategoryController>(context, listen: false)
        .categoryList
        .indexWhere((element) => element.id == id);
    final bIndex = Provider.of<BrandController>(context, listen: false)
        .brandList
        .indexWhere((element) => element.id == id);

    if (type == 'category') {
      if (Provider.of<CategoryController>(context, listen: false)
              .categoryList[cIndex]
              .name !=
          null) {
        print("resorces id :::: $id");
        // Provider.of<CategoryController>(context, listen: false)
        //     .changeSelectedIndex(cIndex);
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => CategoryScreen()));
        final categorys =
            Provider.of<CategoryController>(GetCtx.context!, listen: false);
        final ids =
            categorys.categoryList.indexWhere((element) => element.id == id);
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => DashBoardScreen()));
        Navigator.pushAndRemoveUntil(
            GetCtx.context!,
            MaterialPageRoute(builder: (_) => const DashBoardScreen()),
            (route) => false);
        BaseController.to.changePage(1);
        Future.delayed(const Duration(seconds: 1), () {
          categorys.changeSelectedIndex(ids);
        });
      }
    } else if (type == 'product') {
      if (id != null) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (_) => ProductDetails(productId: id, slug: null)));
        Navigator.pushAndRemoveUntil(
            GetCtx.context!,
            MaterialPageRoute(
                builder: (_) => ProductDetails(productId: id, slug: null)),
            (route) => false);
      }
    } else if (type == 'brand') {
      if (Provider.of<BrandController>(context, listen: false)
              .brandList[bIndex]
              .name !=
          null) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (_) => BrandAndCategoryProductScreen(
        //             isBrand: true,
        //             id: id,
        //             name:
        //                 '${Provider.of<BrandController>(context, listen: false).brandList[bIndex].name}')));
        Navigator.pushAndRemoveUntil(
            GetCtx.context!,
            MaterialPageRoute(
                builder: (_) => BrandAndCategoryProductScreen(
                    isBrand: true,
                    id: id,
                    name:
                        '${Provider.of<BrandController>(context, listen: false).brandList[bIndex].name}')),
            (route) => false);
      }
    }
  }

  Future<bool> checkInternet() async {
    // Use the `connectivity_plus` package here in real apps
    return true;
  }
}

class MyScreen extends StatelessWidget {
  final controller = Get.put(LandingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.status.value) {
          case Status.loading:
            return Center(child: CircularProgressIndicator());

          case Status.noInternet:
            return Center(child: Text("No Internet Connection"));

          case Status.error:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${controller.errorMessage.value}"),
                  ElevatedButton(
                    onPressed: controller.fetchData,
                    child: Text("Retry"),
                  ),
                ],
              ),
            );

          case Status.success:
            return HomeSliderScreen();
          // ListView.builder(
          //   itemCount: controller.data.length,
          //   itemBuilder: (context, index) {
          //     final item = controller.data[index];
          //     return ListTile(title: Text(item.toString()));
          //   },
          // );
        }
      }),
    );
  }
}
