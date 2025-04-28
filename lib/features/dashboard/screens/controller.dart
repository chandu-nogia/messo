import 'package:get/get.dart';

class BaseController extends GetxController {
  static BaseController get to => Get.find();
  Rx<int>? id = 0.obs;

  Rx<String>? name = ''.obs;
  var currentIndex = 0.obs;

  addValue(int value, String text) {
    id!.value = value;
    name!.value = text;
  }

  void changePage(int index) {
    // if (currentIndex.value != index) {
    //   Get.nestedKey(currentIndex.value + 1)
    //       ?.currentState
    //       ?.popUntil((route) => route.isFirst);
    currentIndex.value = index;
    // }
  }
}

// class NavIds {
//   static const int home = 0;
//   static const int category = 1;
//   static const int cart = 2;
//   static const int order = 3;
//   static const int ai = 4;
//   static const int more = 5;
// }

// class CategoryScreenNav extends StatelessWidget {
//   const CategoryScreenNav({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       key: Get.nestedKey(NavIds.category),
//       onGenerateRoute: (settings) {
//         if (settings.name == '/home/subCategory') {
//           return GetPageRoute(
//             settings: settings,
//             page: () => BrandAndCategoryProductScreen(
//                 isBrand: false,
//                 id: BaseController.to.id!.value,
//                 name: BaseController.to.name!.value),
//           );
//         } else {
//           return GetPageRoute(
//             settings: settings,
//             page: () => const CategoryScreen(back: false),
//           );
//         }
//       },
//     );
// }
// }
