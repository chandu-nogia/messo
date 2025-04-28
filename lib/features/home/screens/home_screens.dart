import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/address/controllers/address_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/banner/widgets/banners_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/banner/widgets/footer_banner_slider_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/banner/widgets/single_banner_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/brand/widgets/brand_list_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/category/widgets/category_list_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/clearance_sale/widgets/clearance_sale_list_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/screens/featured_deal_screen_view.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/screens/flash_deal_screen_view.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/widgets/featured_deal_list_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/widgets/flash_deals_list_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/home/shimmers/flash_deal_shimmer.dart';
import 'package:flutter_lovexa_ecommerce/features/home/widgets/announcement_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/home/widgets/aster_theme/find_what_you_need_shimmer.dart';
import 'package:flutter_lovexa_ecommerce/features/home/widgets/featured_product_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/home/widgets/search_home_page_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_lovexa_ecommerce/features/product/widgets/latest_product_list_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/product/widgets/recommended_product_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_lovexa_ecommerce/features/search_product/screens/search_product_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/main.dart';
import 'package:flutter_lovexa_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/custom_themes.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/utill/images.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../common/basewidget/custom_button_widget.dart';
import '../../../common/basewidget/paginated_list_view_widget.dart';
import '../../../utill/color_resources.dart';
import '../../more/screens/more_screen_view.dart';
import '../../notification/screens/notification_screen.dart';
import '../../product/screens/view_all_product_screen.dart';
import '../../product/widgets/best_selling_screen.dart';
import '../../search_product/controllers/search_product_controller.dart';
import '../../search_product/widgets/home_filter_screen.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../../wishlist/screens/wishlist_screen.dart';
import 'bottomsheet.dart';
import 'product_for_you.dart';
import 'splash_screen_lovexa.dart';

class GlobleKeys {
  // static final GlobalKey targetKey = GlobalKey<_HomePageState>();
  final targetKey = ValueKey("target_25");
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static Future<void> loadData(bool reload) async {
    if (Provider.of<AuthController>(GetCtx.context!, listen: false)
        .isLoggedIn()) {
      try {
        await Provider.of<ProfileController>(GetCtx.context!, listen: false)
            .getUserInfo(GetCtx.context!);
      } catch (e, stack) {
        print('User info fetch error: $e');
      }

      // Provider.of<ProfileController>(GetCtx.context!, listen: false)
      //     .getUserInfo(GetCtx.context!);
      // profileController.getUserInfo(GetCtx.context!);
    }
    final productController =
        Provider.of<ProductController>(GetCtx.context!, listen: false);
    // Provider.of<SearchProductController>(GetCtx.context!, listen: false)
    //     .searchProductForYou(query: "", offset: 1);

    // await Future.delayed(Duration(seconds: 2));
    // final FeatchController productCTr = Get.put(FeatchController());
    // await FeatchController().hometitle_Api();

    final flashDealController =
        Provider.of<FlashDealController>(GetCtx.context!, listen: false);
    final shopController =
        Provider.of<ShopController>(GetCtx.context!, listen: false);
    final categoryController =
        Provider.of<CategoryController>(GetCtx.context!, listen: false);
    final bannerController =
        Provider.of<BannerController>(GetCtx.context!, listen: false);
    final addressController =
        Provider.of<AddressController>(GetCtx.context!, listen: false);

    final brandController =
        Provider.of<BrandController>(GetCtx.context!, listen: false);
    final featuredDealController =
        Provider.of<FeaturedDealController>(GetCtx.context!, listen: false);
    final notificationController =
        Provider.of<NotificationController>(GetCtx.context!, listen: false);
    final cartController =
        Provider.of<CartController>(GetCtx.context!, listen: false);
    final profileController =
        Provider.of<ProfileController>(GetCtx.context!, listen: false);
    final splashController =
        Provider.of<SplashController>(GetCtx.context!, listen: false);

    if (flashDealController.flashDealList.isEmpty || reload) {
      // await flashDealController.getFlashDealList(reload, false);
    }
    splashController.initConfig(GetCtx.context!, null, null);
//  final isCategor = Get.put(FeatchController());
//  if(isCategor.isCategory.value == true){
    productController.getHomeCategoryProductList(reload);
    categoryController.getCategoryList(reload);
//  }

    bannerController.getBannerList(reload);

    shopController.getTopSellerList(reload, 1, type: "top");

    shopController.getAllSellerList(reload, 1, type: "all");

    if (addressController.addressList == null ||
        (addressController.addressList != null &&
            addressController.addressList.isEmpty) ||
        reload) {
      addressController.getAddressList();
    }

    cartController.getCartData(GetCtx.context!);

    brandController.getBrandList(reload);

    featuredDealController.getFeaturedDealList(reload);
    ProductFor().productForYou(1);
    // featuredDealController.productForYou(1);
//!
    productController.getLProductList('1', reload: reload);

    // productController.getLatestProductList(1, reload: reload);
    Provider.of<ProductController>(GetCtx.context!, listen: false)
        .getLatestProductListApis(1);

    productController.getFeaturedProductList('1', reload: reload);

    productController.getRecommendedProduct();

    productController.getClearanceAllProductList('1');

    if (notificationController.notificationModel == null ||
        (notificationController.notificationModel != null &&
            notificationController.notificationModel!.notification!.isEmpty) ||
        reload) {
      notificationController.getNotificationList(1);
    }

    if (Provider.of<AuthController>(GetCtx.context!, listen: false)
            .isLoggedIn() &&
        profileController.userInfoModel == null) {
      Provider.of<ProfileController>(GetCtx.context!, listen: false)
          .getUserInfo(GetCtx.context!);
      profileController.getUserInfo(GetCtx.context!);
    }
  }
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final _pageController = Get.put(SearchPaginationController());

  // late ScrollController _scrollController;

  void passData(int index, String title) {
    index = index;

    title = title;
  }

  bool singleVendor = false;

  @override
  void initState() {
    super.initState();
    FeatchController().hometitle_Api();

    if (Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<SplashController>(context, listen: false)
              .configModel!
              .softwareVersion ??
          'version';
      Provider.of<ProfileController>(context, listen: false)
          .getUserInfo(context);
      Provider.of<WishListController>(GetCtx.context!, listen: false)
          .getWishList();
    }
    singleVendor = Provider.of<SplashController>(context, listen: false)
            .configModel!
            .businessMode ==
        "single";
    // Provider.of<ProfileController>(context, listen: false).getUserInfo(context);
    // singleVendor = Provider.of<SplashController>(context, listen: false)
    //         .configModel!
    //         .businessMode ==
    //     "single";
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  // final FeatchController productCTr = Get.put(FeatchController());
  @override
  Widget build(BuildContext context) {
    bool isGuestMode =
        !Provider.of<AuthController>(context, listen: false).isLoggedIn();
    final ConfigModel? configModel =
        Provider.of<SplashController>(context, listen: false).configModel;

    // List<String?> types = [
    //   getTranslated('new_arrival', context),
    //   getTranslated('top_product', context),
    //   getTranslated('${homeTitleModel!.bestSellingsHeading ?? ""}', context),
    //   getTranslated('discounted_product', context)
    // ];

    return Scaffold(
        backgroundColor:
            Provider.of<ThemeController>(context, listen: false).darkTheme
                ? Colors.black
                : Colors.white,
        resizeToAvoidBottomInset: false,
        body: Consumer<SearchProductController>(
          builder: (context, searchProductController, child) => SafeArea(
              child: RefreshIndicator(
                  onRefresh: () async {
                    await HomePage.loadData(true);
                  },
                  child: CustomScrollView(
                      shrinkWrap: true,
                      controller: _scrollController,
                      slivers: [
                        homeAppBar(context),
                        SliverToBoxAdapter(
                            child: Provider.of<SplashController>(context,
                                            listen: false)
                                        .configModel!
                                        .announcement!
                                        .status ==
                                    '1'
                                ? Consumer<SplashController>(
                                    builder: (context, announcement, _) {
                                    return (announcement
                                                    .configModel!
                                                    .announcement!
                                                    .announcement !=
                                                null &&
                                            announcement.onOff)
                                        ? AnnouncementWidget(
                                            announcement: announcement
                                                .configModel!.announcement)
                                        : const SizedBox();
                                  })
                                : const SizedBox()),
                        SliverPersistentHeader(
                            pinned: true,
                            delegate: SliverDelegate(
                                child: InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const SearchScreen())),
                                    child: const Hero(
                                        tag: 'search',
                                        child: Material(
                                            child: SearchHomePageWidget()))))),
                        //   if (productForYouValue == true)

                        SliverToBoxAdapter(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Consumer<ProfileController>(
                                builder: (context, info, child) => info
                                            .userInfoModel?.location ==
                                        "NA"
                                    ? const SizedBox()
                                    : (!isGuestMode &&
                                            info.userInfoModel?.phone != null &&
                                            info.userInfoModel!.phone!
                                                .isNotEmpty)
                                        ? InkWell(
                                            onTap: () {
                                              showDeliveryLocationBottomSheet(
                                                  context,
                                                  info.userInfoModel!
                                                      .primaryAddressid!);
                                            },
                                            child: Container(
                                                color:
                                                    Provider.of<ThemeController>(
                                                                context,
                                                                listen: false)
                                                            .darkTheme
                                                        ? const Color.fromARGB(
                                                            255, 41, 41, 41)
                                                        : ColorResources
                                                            .circulColor,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            top: 10,
                                                            bottom: 10),
                                                    child: Row(children: [
                                                      const Icon(
                                                          Icons.location_on,
                                                          size: 16),
                                                      Text(
                                                        info.userInfoModel
                                                                ?.location ??
                                                            '',
                                                      ),
                                                      const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 16)
                                                    ]))))
                                        : const SizedBox(),
                              ),
                              const CategoryListWidget(isHomePage: true),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),
                              const BannersWidget(),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),
                              Consumer<FlashDealController>(
                                  builder: (context, megaDeal, child) {
                                return megaDeal.flashDeal == null
                                    ? const FlashDealShimmer()
                                    : megaDeal.flashDealList.isNotEmpty
                                        ? Column(children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeDefault),
                                                child: InkWell(
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                const FlashDealScreenView())),
                                                    child: TitleRowWidget(
                                                        title: getTranslated(
                                                                'flash_deal',
                                                                context)
                                                            ?.toUpperCase(),
                                                        eventDuration: megaDeal
                                                                    .flashDeal !=
                                                                null
                                                            ? megaDeal.duration
                                                            : null,
                                                        isFlash: true))),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeSmall),
                                            Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeDefault),
                                                child: Text(
                                                    getTranslated(
                                                            'hurry_up_the_offer_is_limited_grab_while_it_lasts',
                                                            context) ??
                                                        '',
                                                    style: textRegular.copyWith(
                                                        color: Provider.of<ThemeController>(context, listen: false)
                                                                .darkTheme
                                                            ? Theme.of(context)
                                                                .hintColor
                                                            : Theme.of(context)
                                                                .primaryColor,
                                                        fontSize: Dimensions
                                                            .fontSizeDefault),
                                                    textAlign: TextAlign.center)),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeSmall),
                                            FlashDealsListWidget()
                                          ])
                                        : const SizedBox.shrink();
                              }),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),

                              Consumer<FeaturedDealController>(builder:
                                  (context, featuredDealProvider, child) {
                                return featuredDealProvider
                                            .featuredDealProductList !=
                                        null
                                    ? featuredDealProvider
                                            .featuredDealProductList!.isNotEmpty
                                        ? Column(children: [
                                            Stack(children: [
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 150,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onTertiary),
                                              Column(children: [
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: Dimensions
                                                            .paddingSizeDefault),
                                                    child: TitleRowWidget(
                                                        title:
                                                            '${getTranslated('featured_deals', context)}',
                                                        onTap: () => Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    const FeaturedDealScreenView())))),
                                                const FeaturedDealsListWidget()
                                              ])
                                            ]),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeDefault)
                                          ])
                                        : const SizedBox.shrink()
                                    : const FindWhatYouNeedShimmer();
                              }),
                              const ClearanceListWidget(),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),
                              Consumer<BannerController>(builder:
                                  (context, footerBannerProvider, child) {
                                return footerBannerProvider.footerBannerList !=
                                            null &&
                                        footerBannerProvider
                                            .footerBannerList!.isNotEmpty
                                    ? const MainSectionBanner()
                                    : const SizedBox();
                              }),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),

                              Consumer<ProductController>(
                                  builder: (context, productController, _) {
                                return FeaturedProductWidget();
                              }),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),

                              // const Padding(
                              //     padding: EdgeInsets.only(
                              //         bottom: Dimensions.paddingSizeDefault),
                              //     child: RecommendedProductWidget()),
                              const Padding(
                                  padding: EdgeInsets.only(
                                      bottom: Dimensions.paddingSizeDefault),
                                  child: LatestProductListWidget()),

                              Consumer<ProductController>(
                                  builder: (ctx, prodProvider, child) {
                                return Container(
                                    decoration: BoxDecoration(
                                        color: Provider.of<ThemeController>(
                                                    context,
                                                    listen: false)
                                                .darkTheme
                                            ? Colors.black
                                            : Colors.white
                                        // Theme.of(context)
                                        //     .colorScheme
                                        //     .onSecondaryContainer
                                        ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TitleRowWidget(
                                              // title: getTranslated('brand', context),
                                              title: homeTitleModel
                                                      .bestSellingsHeading ??
                                                  'Best Sellings',
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          AllProductScreen(
                                                              productType:
                                                                  ProductType
                                                                      .bestSelling)))),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall),
                                              child: BestSellingScreen(
                                                isHomePage: false,
                                                productType:
                                                    ProductType.bestSelling,
                                                // scrollController: _scrollController
                                              )),
                                          const SizedBox(
                                              height:
                                                  Dimensions.homePagePadding)
                                        ]));
                              }),
                              if (configModel?.brandSetting == "1")
                                TitleRowWidget(
                                  // onTap: () {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (_) =>
                                  //               FinalSplashScreen()));
                                  // },
                                  // title: getTranslated('brand', context),
                                  title:
                                      homeTitleModel.brandsHeading ?? 'Brands',
                                  // onTap: () => Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  // builder: (_) => const BrandsView())),
                                ),
                              SizedBox(
                                  height: configModel?.brandSetting == "1"
                                      ? Dimensions.paddingSizeSmall
                                      : 0),
                              if (configModel!.brandSetting == "1") ...[
                                const BrandListWidget(isHomePage: true),
                                const SizedBox(
                                    height: Dimensions.paddingSizeDefault),
                              ],
                              // const HomeCategoryProductWidget(isHomePage: true),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),
                              const FooterBannerSliderWidget(),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),
                              // SearchProductWidget(),
                              //   Container(key: targetKey.currentWidget!.key!),
                              // Container(key: GlobleKeys.targetKey),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.paddingSizeExtraSmall,
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  child: TitleRowWidget(
                                      key: GlobleKeys().targetKey,
                                      title: homeTitleModel
                                              .productsForYouHeading ??
                                          'Products for You'))
                              //       SearchProductWidget(
                              //   scrollController: _scrollController,
                              // )
                              // filter_for_you(),
                            ])),

                        //   SliverPersistentHeader(floating: false,
                        //       pinned: true,
                        //       delegate: SliverDelegate(child: filter_for_you())),
                        SliverAppBar(
                          floating: false,
                          elevation: 0,
                          // centerTitle: true,
                          automaticallyImplyLeading: false,
                          backgroundColor: Provider.of<ThemeController>(context,
                                      listen: false)
                                  .darkTheme
                              ? Colors.black
                              : Colors.white,
                          stretch: false,
                          pinned: true,
                          titleSpacing: 0,
                          surfaceTintColor: Provider.of<ThemeController>(
                                      context,
                                      listen: false)
                                  .darkTheme
                              ? Colors.black
                              : Colors.white,
                          title: filter_for_you(),
                        ),
                        // SliverToBoxAdapter(
                        //     child: HomeFilterScreen(
                        //         scrollController: _scrollController)),
                        // SliverToBoxAdapter(
                        //     child: SearchAPisScrFilterScreen(
                        //         scrollController: _scrollController)),
                        InfinitScrollingWidget(),
                        SliverToBoxAdapter(
                            child: Obx(
                          () => Center(
                              child: _pageController.canPaginate.value == false
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30,
                                          bottom: 50),
                                      child: CustomButton(
                                          radius: 10,
                                          onTap: () {
                                            _pageController.clearFilter(
                                                nav: true);
                                          },
                                          buttonText: "Continue Shopping"),
                                    )
                                  : SizedBox.shrink()),
                        )),
                        // SliverToBoxAdapter(
                        //   child: ProductForYou(
                        //     scrollController: _scrollController,
                        //     isHomePage: false,
                        //   ),
                        // ),
                      ]))),
        ));
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;
  SliverDelegate({required this.child, this.height = 70});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}

homeAppBar(BuildContext context) {
  bool isGuestMode =
      !Provider.of<AuthController>(context, listen: false).isLoggedIn();

  return SliverAppBar(
    pinned: true,
    actions: [
      FittedBox(
          child: Stack(children: [
        Positioned(
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WishListScreen()));
                },
                child: Icon(Icons.favorite_border,
                    color: Theme.of(context).primaryColor))),
        Positioned(
            top: 0,
            right: 0,
            child: Consumer<WishListController>(
                builder: (context, wishListController, _) {
              return CircleAvatar(
                  radius: 6,
                  backgroundColor: ColorResources.yellow,
                  child: Text(
                      wishListController.wishList?.length.toString() ?? '0',
                      style: textRegular.copyWith(
                          color: ColorResources.black, fontSize: 8)));
            }))
      ])),
      const SizedBox(width: 5),
      FittedBox(
          child: Stack(children: [
        Positioned(
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                },
                child: Icon(Icons.notifications,
                    color: Theme.of(context).primaryColor))),
        Positioned(
            top: 0,
            right: 2,
            child: Consumer<NotificationController>(
                builder: (context, notificationController, _) {
              return CircleAvatar(
                  radius: 6,
                  backgroundColor: ColorResources.yellow,
                  child: Text(
                      notificationController
                              .notificationModel?.newNotificationItem
                              .toString() ??
                          '0',
                      style: textRegular.copyWith(
                          color: ColorResources.black, fontSize: 8)));
            }))
      ])),
      const SizedBox(width: 10)
    ],

    title: Consumer<ProfileController>(builder: (context, profile, _) {
      return InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MoreScreen()));
          },
          child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 0, right: 15),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Provider.of<AuthController>(context, listen: false).isLoggedIn()
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CustomImageWidget(
                            image:
                                '${profile.userInfoModel?.imageFullUrl?.path}',
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                            placeholder: Images.guestProfile))
                    : Image.asset(Images.guestProfile, width: 30, height: 30),
                const SizedBox(width: 4),
                // Image.asset(Images.guestProfile), //! profile pic
                Column(
                    spacing: 0.0,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello",
                          style: textBold.copyWith(
                              color: Theme.of(context).primaryColor)),
                      Text(
                          !isGuestMode
                              ? '${profile.userInfoModel?.fName ?? ''} ${profile.userInfoModel?.lName ?? ''}'
                              : 'Guest',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: titleRegular.copyWith(
                              fontSize: 10,
                              color: Theme.of(context).primaryColor)),
                      SizedBox(
                          height: (profile.userInfoModel == null &&
                                  profile.userInfoModel?.phone! == null)
                              ? 8
                              : 0)
                    ])
              ])));
    }),
    // leadingWidth: 110,
    // leading:

    floating: true,
    elevation: 0,
    // centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor:
        Provider.of<ThemeController>(context, listen: false).darkTheme
            ? Colors.black
            : Colors.white,
    // title: Image.asset(Images.logoWithNameImage, height: 35),
  );
}
