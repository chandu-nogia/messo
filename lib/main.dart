import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_lovexa_ecommerce/data/local/cache_response.dart';
import 'package:flutter_lovexa_ecommerce/features/auth/controllers/facebook_login_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/auth/controllers/google_login_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/compare/controllers/compare_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/contact_us/controllers/contact_us_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/location/controllers/location_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/loyaltyPoint/controllers/loyalty_point_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/onboarding/controllers/onboarding_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_lovexa_ecommerce/features/refund/controllers/refund_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/reorder/controllers/re_order_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/restock/controllers/restock_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/review/controllers/review_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/shipping/controllers/shipping_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/splash/screens/splash_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/support/controllers/support_ticket_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/wallet/controllers/wallet_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_lovexa_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_lovexa_ecommerce/push_notification/models/notification_body.dart';
import 'package:flutter_lovexa_ecommerce/features/address/controllers/address_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/coupon/controllers/coupon_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_lovexa_ecommerce/push_notification/notification_helper.dart';
import 'package:flutter_lovexa_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_lovexa_ecommerce/theme/dark_theme.dart';
import 'package:flutter_lovexa_ecommerce/theme/light_theme.dart';
import 'package:flutter_lovexa_ecommerce/utill/app_constants.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;
import 'features/dashboard/screens/controller.dart';
// import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/home/screens/controller.dart';
import 'features/home/screens/product_for_you.dart';
import 'features/home/screens/splash_screen_lovexa.dart';
import 'helper/custom_delegate.dart';
import 'language/language.dart';
import 'localization/app_localization.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final database = AppDatabase();

Future<void> main() async {
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   FlutterError.dumpErrorToConsole(details);
  //   print(
  //       'FlutterError: ${details.exceptionAsString()} caused by: ${details.stack}');

  //   // if (details.exception != null) {
  //   //   exit(1);
  //   // }else{}

  //   // Optionally log to file or send to server
  // };
  Get.put(LanguageController());
  Get.put(LandingController());
  Get.put(FeatchController());
  Get.put(BaseController());
  FeatchController().hometitle_Api();

  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    if (Platform.isAndroid) {
      try {
        ///todo you need to configure that firebase Option with your own firebase to run your app
        await Firebase.initializeApp(
            options: const FirebaseOptions(
                apiKey: "AIzaSyA1TSFf36TXIrw76D2XbdspdoxrvQesjC0",
                projectId: "lovexa-test",
                messagingSenderId: "109533575942",
                appId: "1:109533575942:android:4cbc183d7ecec03b76fc87"));
      } finally {
        await Firebase.initializeApp();
      }
    } else {
      await Firebase.initializeApp();
    }
  }
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await di.init();

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  NotificationBody? body;
  try {
    final RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      body = NotificationHelper.convertNotification(remoteMessage.data);
    }
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  } catch (_) {}

  // await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  // FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(MultiProvider(
    providers: [
      // ChangeNotifierProvider(create: (context) => di.sl<PageIndexProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CategoryController>()),
      ChangeNotifierProvider(create: (context) => di.sl<ShopController>()),
      ChangeNotifierProvider(create: (context) => di.sl<FlashDealController>()),
      ChangeNotifierProvider(create: (context) => di.sl<FeaturedDealController>()),
      ChangeNotifierProvider(create: (context) => di.sl<BrandController>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductController>()),
      ChangeNotifierProvider(create: (context) => di.sl<BannerController>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductDetailsController>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingController>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthController>()),
      ChangeNotifierProvider(create: (context) => di.sl<SearchProductController>()),
      ChangeNotifierProvider(create: (context) => di.sl<CouponController>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatController>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderController>()),
      ChangeNotifierProvider(create: (context) => di.sl<NotificationController>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileController>()),
      ChangeNotifierProvider(create: (context) => di.sl<WishListController>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashController>()),
      ChangeNotifierProvider(create: (context) => di.sl<CartController>()),
      ChangeNotifierProvider(create: (context) => di.sl<SupportTicketController>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationController>()),
      ChangeNotifierProvider(create: (context) => di.sl<ThemeController>()),
      ChangeNotifierProvider(create: (context) => di.sl<GoogleSignInController>()),
      ChangeNotifierProvider(create: (context) => di.sl<FacebookLoginController>()),
      ChangeNotifierProvider(create: (context) => di.sl<AddressController>()),
      ChangeNotifierProvider(create: (context) => di.sl<WalletController>()),
      ChangeNotifierProvider(create: (context) => di.sl<CompareController>()),
      ChangeNotifierProvider(create: (context) => di.sl<CheckoutController>()),
      ChangeNotifierProvider(create: (context) => di.sl<LoyaltyPointController>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationController>()),
      ChangeNotifierProvider(create: (context) => di.sl<ContactUsController>()),
      ChangeNotifierProvider(create: (context) => di.sl<ShippingController>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderDetailsController>()),
      ChangeNotifierProvider(create: (context) => di.sl<RefundController>()),
      ChangeNotifierProvider(create: (context) => di.sl<ReOrderController>()),
      ChangeNotifierProvider(create: (context) => di.sl<ReviewController>()),
      ChangeNotifierProvider(create: (context) => di.sl<SellerProductController>()),
      ChangeNotifierProvider(create: (context) => di.sl<RestockController>()),
    ],
    child: MyApp(body: body),
  ));
}

class MyApp extends StatelessWidget {
  final NotificationBody? body;
  const MyApp({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    final LanguageController langController = Get.find();

    // List<Locale> locals = [];
    // for (var language in AppConstants.languages) {
    //   locals.add(Locale(language.languageCode!, language.countryCode));
    // }
    return Consumer<ThemeController>(builder: (context, themeController, _) {
      return Obx(
        () => SafeArea(
          bottom: true,
          top: false,
          child: GetMaterialApp(
            translations: Messages(),
            locale: langController.locale.value,
            // locale: Locale('en', 'US'), // Default language
            fallbackLocale: Locale('en', 'US'),

            title: AppConstants.appName,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: themeController.darkTheme
                ? dark
                : light(
                    primaryColor: themeController.selectedPrimaryColor,
                    secondaryColor: themeController.selectedPrimaryColor,
                  ),
            // locale: Provider.of<LocalizationController>(context).locale,
            localizationsDelegates: [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FallbackLocalizationDelegate()
            ],
            builder: (context, child) {
              return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.noScaling),
                  child: child!);
            },
            // supportedLocales: locals,
            // home: SplashScreen(
            //   body: body,
            // ),
            home: FinalSplashScreen(body: body),
          ),
        ),
      );
    });
  }
}

class GetCtx {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
