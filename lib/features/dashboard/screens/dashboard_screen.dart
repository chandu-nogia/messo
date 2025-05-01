import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/cart/screens/cart_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/dashboard/models/navigation_model.dart';
import 'package:flutter_lovexa_ecommerce/features/dashboard/widgets/dashboard_menu_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/restock/controllers/restock_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_lovexa_ecommerce/helper/network_info.dart';
import 'package:flutter_lovexa_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/features/dashboard/widgets/app_exit_card_widget.dart';
import 'package:flutter_lovexa_ecommerce/utill/images.dart';
import 'package:flutter_lovexa_ecommerce/features/home/screens/aster_theme_home_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/home/screens/fashion_theme_home_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/home/screens/home_screens.dart';
import 'package:flutter_lovexa_ecommerce/features/order/screens/order_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// import '../../category/screens/category_screen.dart';
import '../../../main.dart';
import '../../../theme/controllers/theme_controller.dart';
import '../../brand/controllers/brand_controller.dart';
import '../../category/controllers/category_controller.dart';
import '../../category/screens/category_screen.dart';
import '../../more/screens/chat_bot_screen.dart';
import '../../shop/screens/shop_screen.dart';
import 'controller.dart';

// int _pageIndex = 0;

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});
  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  late List<NavigationModel> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final PageStorageBucket bucket = PageStorageBucket();

  bool singleVendor = false;

  @override
  void initState() {
    super.initState();
    // Provider.of<PageIndexProvider>(context, listen: false);
    Provider.of<FlashDealController>(context, listen: false)
        .getFlashDealList(true, true);
    if (Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<WishListController>(context, listen: false).getWishList();
      Provider.of<ChatController>(context, listen: false)
          .getChatList(1, reload: false, userType: 0);
      Provider.of<ChatController>(context, listen: false)
          .getChatList(1, reload: false, userType: 1);
      Provider.of<RestockController>(context, listen: false)
          .getRestockProductList(1, getAll: true);
    }

    final SplashController splashController =
        Provider.of<SplashController>(context, listen: false);
    singleVendor = splashController.configModel?.businessMode == "single";
    Provider.of<SearchProductController>(context, listen: false)
        .getAuthorList(null);
    Provider.of<SearchProductController>(context, listen: false)
        .getPublishingHouseList(null);

    if (splashController.configModel!.activeTheme == "default") {
      HomePage.loadData(false);
    } else if (splashController.configModel!.activeTheme == "theme_aster") {
      AsterThemeHomeScreen.loadData(false);
    } else {
      FashionThemeHomePage.loadData(false);
    }

    _screens = [
      NavigationModel(
        name: 'home',
        icon: Images.homeImage,
        screen: (splashController.configModel!.activeTheme == "default")
            ? const HomePage()
            : (splashController.configModel!.activeTheme == "theme_aster")
                ? const AsterThemeHomeScreen()
                : const FashionThemeHomePage(),
      ),

      NavigationModel(
          name: 'CATEGORY',
          icon: Images.category,
          screen: CategoryScreen(back: false)),
      NavigationModel(
          name: 'Mall',
          icon: Images.lovexaMall,
          screen: TopSellerProductScreen(
              sellerId: 0,
              temporaryClose: Provider.of<SplashController>(context, listen: false)
                      .configModel
                      ?.inhouseTemporaryClose
                      ?.status ==
                  1,
              vacationStatus: Provider.of<SplashController>(context, listen: false)
                      .configModel
                      ?.inhouseVacationAdd
                      ?.status ==
                  1,
              vacationEndDate:
                  Provider.of<SplashController>(context, listen: false)
                      .configModel
                      ?.inhouseVacationAdd
                      ?.vacationEndDate,
              vacationStartDate:
                  Provider.of<SplashController>(context, listen: false)
                      .configModel
                      ?.inhouseVacationAdd
                      ?.vacationStartDate,
              name: Provider.of<SplashController>(context, listen: false)
                  .configModel
                  ?.companyName,
              banner: Provider.of<SplashController>(context, listen: false)
                  .configModel
                  ?.companyLogo
                  ?.path,
              image: Provider.of<SplashController>(context, listen: false)
                  .configModel
                  ?.companyIcon)),
      NavigationModel(
          name: 'cart',
          icon: Images.cartArrowDownImage,
          screen: const CartScreen(showBackButton: false),
          showCartIcon: true),
      NavigationModel(
          name: 'orders',
          icon: Images.shoppingImage,
          screen: const OrderScreen(isBacButtonExist: false)),
      NavigationModel(name: 'AI', icon: Images.ai, screen: const ChatrBotScreen()),
      // InboxScreen(isBackButtonExist: false)),
      // NavigationModel(
      //     name: 'more', icon: Images.moreImage, screen: const MoreScreen()),
    ];

    // Padding(padding: const EdgeInsets.only(right: 12.0),
    //   child: IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
    //     icon: Stack(clipBehavior: Clip.none, children: [
    //
    //       Image.asset(Images.cartArrowDownImage, height: Dimensions.iconSizeDefault,
    //           width: Dimensions.iconSizeDefault, color: ColorResources.getPrimary(context)),
    //
    //       Positioned(top: -4, right: -4,
    //           child: Consumer<CartController>(builder: (context, cart, child) {
    //             return CircleAvatar(radius: ResponsiveHelper.isTab(context)? 10 :  7, backgroundColor: ColorResources.red,
    //                 child: Text(cart.cartList.length.toString(),
    //                     style: titilliumSemiBold.copyWith(color: ColorResources.white,
    //                         fontSize: Dimensions.fontSizeExtraSmall)));})),
    //     ]),
    //   ),
    // ),

    NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    // var pageIndexProvider = Provider.of<PageIndexProvider>(context)._pageIndex;
    List<Widget> _getBottomWidget(
        bool isSingleVendor, context, List<NavigationModel> screens) {
      List<Widget> list = [];
      for (int index = 0; index < screens.length; index++) {
        list.add(Obx(
          () => Expanded(
              child: CustomMenuWidget(
                  isSelected: BaseController.to.currentIndex.value == index,
                  name: screens[index].name,
                  icon: screens[index].icon,
                  showCartCount: screens[index].showCartIcon ?? false,
                  onTap: () {
                    if (index == 0) {
                      Provider.of<BrandController>(GetCtx.context!,
                              listen: false)
                          .getBrandList(false);
                      Provider.of<CategoryController>(GetCtx.context!,
                              listen: false)
                          .getCategoryList(true);
                    }
                    BaseController.to.changePage(index);
                  })),
        ));
      }
      return list;
    }

    return SafeArea(
      bottom: true,
      top: false,
      child: Consumer(
        builder: (context, value, _) => PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) async {
              if (BaseController.to.currentIndex.value != 0) {
                BaseController.to.changePage(0);

                // setState(() {
                //   Provider.of<PageIndexProvider>(context, listen: false)
                //       .setPage(0, context);
                //   // setPage(0, context);
                // });
                return;
              } else {
                await Future.delayed(const Duration(milliseconds: 150));
                if (context.mounted) {
                  // if (!Navigator.of(context).canPop()) {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (_) => const AppExitCard());
                  // }
                }
              }
              return;
            },
            child: Scaffold(
                backgroundColor:
                    Provider.of<ThemeController>(context, listen: false)
                            .darkTheme
                        ? Colors.black
                        : Colors.white,
                key: _scaffoldKey,
                body:
                    //  Obx(() => IndexedStack(
                    //       index: BaseController.to.currentIndex.value,
                    //       children: [_screens[BaseController.to.currentIndex.value].screen],
                    //     )),
                    Obx(
                  () => PageStorage(
                      bucket: bucket,
                      child: _screens[BaseController.to.currentIndex.value]
                          .screen),
                ),
                bottomNavigationBar: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(Dimensions.paddingSizeLarge)),
                      color:
                          Provider.of<ThemeController>(context, listen: false)
                                  .darkTheme
                              ? Colors.black
                              : Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                            spreadRadius: 1,
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: .125))
                      ],
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _getBottomWidget(
                            singleVendor, context, _screens))))),
      ),
    );
  }
}

// void setPage(int pageIndex, context) {
//   // setState(() {
//   if (pageIndex == 1 && _pageIndex != 1) {
//     Provider.of<ChatController>(context, listen: false)
//         .setUserTypeIndex(context, 0);
//     Provider.of<ChatController>(context, listen: false).resetIsSearchComplete();
//   }
//   _pageIndex = pageIndex;
//   // });
// }

// class PageIndexProvider extends ChangeNotifier {
//   int _pageIndex = 0;
//   int get pageIndex => _pageIndex;

//   void setPage(int pageIndex, BuildContext context) {
//     if (pageIndex == 1 && _pageIndex != 1) {
//       Provider.of<ChatController>(context, listen: false)
//           .setUserTypeIndex(context, 0);
//       Provider.of<ChatController>(context, listen: false)
//           .resetIsSearchComplete();
//     }
//     _pageIndex = pageIndex;
//     notifyListeners(); // Notify UI about the change
//   }
// }
