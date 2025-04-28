import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../category/controllers/category_controller.dart';
import '../../product/controllers/product_controller.dart';
import 'product_for_you.dart';
import 'package:flutter_lovexa_ecommerce/features/order_details/screens/order_details_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_lovexa_ecommerce/features/update/screen/update_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/wallet/screens/wallet_screen.dart';
import 'package:flutter_lovexa_ecommerce/helper/network_info.dart';
import 'package:flutter_lovexa_ecommerce/main.dart';
import 'package:flutter_lovexa_ecommerce/push_notification/models/notification_body.dart';
import 'package:flutter_lovexa_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/app_constants.dart';
import 'package:flutter_lovexa_ecommerce/features/chat/screens/inbox_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/maintenance/maintenance_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/notification/screens/notification_screen.dart';
import 'package:provider/provider.dart';

class FinalSplashScreen extends StatefulWidget {
  final NotificationBody? body;

  const FinalSplashScreen({super.key, this.body});
  @override
  State<FinalSplashScreen> createState() => _FinalSplashScreenState();
}

class _FinalSplashScreenState extends State<FinalSplashScreen>
    with TickerProviderStateMixin {
  Alignment _alignment = Alignment.centerLeft;

  // bool _isAlign = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductController>(context, listen: false)
        .getHomeCategoryProductList(true);
    Provider.of<CategoryController>(context, listen: false)
        .getCategoryList(true);

    Future.delayed(const Duration(seconds: 0), () {
      setState(() {
        _alignment = Alignment.center;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(child: ScaleTransitionAnimation(body: widget.body)),

              // Logo & Text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          alignment: _alignment,
                          curve: Curves.easeInOut,
                          child: const Text('LOVEXA',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//!Todo import 'package:flutter/material.dart';

class ScaleTransitionAnimation extends StatefulWidget {
  final NotificationBody? body;

  const ScaleTransitionAnimation({super.key, this.body});

  @override
  State<ScaleTransitionAnimation> createState() =>
      _ScaleTransitionAnimationState();
}

class _ScaleTransitionAnimationState extends State<ScaleTransitionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  Color? isColor;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        controller.forward();
        isColor = Colors.white;
        _route();
      });
    });
    // controller.forward();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    controller.addListener(() {
      // if (controller.isCompleted) {
      //   // for back from second screen
      //   Timer(const Duration(microseconds: 400), () {
      //     controller.reset();
      //   });
      // }
    });
    scaleAnimation = Tween<double>(begin: 1, end: 12).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Center(
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isColor,
          ),
        ),
      ),
    );
  }

  void _route() {
    NetworkInfo.checkConnectivity(context);
    Provider.of<SplashController>(context, listen: false).initConfig(context,
        (ConfigModel? configModel) {
      String? minimumVersion = "0";
      UserAppVersionControl? appVersion =
          Provider.of<SplashController>(GetCtx.context!, listen: false)
              .configModel
              ?.userAppVersionControl;
      if (Platform.isAndroid) {
        minimumVersion = appVersion?.forAndroid?.version ?? '0';
      } else if (Platform.isIOS) {
        minimumVersion = appVersion?.forIos?.version ?? '0';
      }
      Provider.of<SplashController>(GetCtx.context!, listen: false)
          .initSharedPrefData();
      // Timer(const Duration(seconds: 2), () {
      final config =
          Provider.of<SplashController>(GetCtx.context!, listen: false)
              .configModel;

      Future.delayed(const Duration(milliseconds: 0)).then((_) {
        if (compareVersions(minimumVersion!, AppConstants.appVersion) == 1) {
          Navigator.of(GetCtx.context!).pushReplacement(
              MaterialPageRoute(builder: (_) => const UpdateScreen()));
        } else if (config?.maintenanceModeData?.maintenanceStatus == 1 &&
            config?.maintenanceModeData?.selectedMaintenanceSystem
                    ?.customerApp ==
                1 &&
            !Provider.of<SplashController>(GetCtx.context!, listen: false)
                .isConfigCall) {
          Navigator.of(GetCtx.context!).pushReplacement(MaterialPageRoute(
            builder: (_) => const MaintenanceScreen(),
            settings: const RouteSettings(name: 'MaintenanceScreen'),
          ));
        } else if (Provider.of<AuthController>(GetCtx.context!, listen: false)
            .isLoggedIn()) {
          Provider.of<AuthController>(GetCtx.context!, listen: false)
              .updateToken(GetCtx.context!);
          if (widget.body != null) {
            if (widget.body!.type == 'order') {
              Navigator.of(GetCtx.context!).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      OrderDetailsScreen(orderId: widget.body!.orderId)));
            } else if (widget.body!.type == 'notification') {
              Navigator.of(GetCtx.context!).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const NotificationScreen()));
            } else if (widget.body!.type == 'wallet') {
              Navigator.of(GetCtx.context!).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const WalletScreen()));
            } 
            // else if (widget.body!.type == 'chatting') {
            //   Navigator.of(GetCtx.context!).pushReplacement(MaterialPageRoute(
            //       builder: (BuildContext context) => InboxScreen(
            //           isBackButtonExist: true,
            //           fromNotification: true,
            //           initIndex:
            //               widget.body!.messageKey == 'message_from_delivery_man'
            //                   ? 0
            //                   : 1)));
            // }
             else if (widget.body!.type == 'product_restock_update') {
              Navigator.of(GetCtx.context!).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => ProductDetails(
                      productId: int.parse(widget.body!.productId!),
                      slug: widget.body!.slug,
                      isNotification: true)));
            } else {
              Navigator.of(GetCtx.context!).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const NotificationScreen(
                        fromNotification: true,
                      )));
            }
          } else {
            // Navigator.of(GetCtx.context!).pushReplacement(
            //   PageRouteBuilder(
            //     pageBuilder: (context, animation, secondaryAnimation) =>
            //         const DashBoardScreen(),
            //     transitionDuration:
            //         Duration.zero, // Removes transition duration
            //     reverseTransitionDuration:
            //         Duration.zero, // Removes reverse transition
            //     transitionsBuilder:
            //         (context, animation, secondaryAnimation, child) => child,
            //   ),
            // );

            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const HomeSliderScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child)),
            );
          }
        } else if (Provider.of<SplashController>(GetCtx.context!, listen: false)
            .showIntro()!) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomeSliderScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child)),
          );
        } else {
          if (Provider.of<AuthController>(GetCtx.context!, listen: false)
                      .getGuestToken() !=
                  null &&
              Provider.of<AuthController>(GetCtx.context!, listen: false)
                      .getGuestToken() !=
                  '1') {
            // Navigator.of(GetCtx.context!).pushReplacement(
            //   PageRouteBuilder(
            //     pageBuilder: (context, animation, secondaryAnimation) =>
            //         const DashBoardScreen(),
            //     transitionDuration:
            //         Duration.zero, // Removes transition duration
            //     reverseTransitionDuration:
            //         Duration.zero, // Removes reverse transition
            //     transitionsBuilder:
            //         (context, animation, secondaryAnimation, child) => child,
            //   ),
            // );
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      HomeSliderScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child)),
            );
          } else {
            Provider.of<AuthController>(GetCtx.context!, listen: false)
                .getGuestIdUrl();

            // Navigator.of(GetCtx.context!).pushReplacement(
            //   PageRouteBuilder(
            //     pageBuilder: (context, animation, secondaryAnimation) =>
            //         const DashBoardScreen(),
            //     transitionDuration:
            //         Duration.zero, // Removes transition duration
            //     reverseTransitionDuration:
            //         Duration.zero, // Removes reverse transition
            //     transitionsBuilder:
            //         (context, animation, secondaryAnimation, child) => child,
            //   ),
            // );
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const HomeSliderScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child)),
            );
          }
        }
      });
      //  });
    }, (ConfigModel? configModel) {
      String? minimumVersion = "0";
      UserAppVersionControl? appVersion =
          Provider.of<SplashController>(GetCtx.context!, listen: false)
              .configModel
              ?.userAppVersionControl;
      if (Platform.isAndroid) {
        minimumVersion = appVersion?.forAndroid?.version ?? '0';
      } else if (Platform.isIOS) {
        minimumVersion = appVersion?.forIos?.version ?? '0';
      }
      Provider.of<SplashController>(GetCtx.context!, listen: false)
          .initSharedPrefData();
      // Timer(const Duration(seconds: 1), () {
      final config =
          Provider.of<SplashController>(GetCtx.context!, listen: false)
              .configModel;
      if (compareVersions(minimumVersion, AppConstants.appVersion) == 1) {
        Navigator.of(GetCtx.context!).pushReplacement(
            MaterialPageRoute(builder: (_) => const UpdateScreen()));
      } else if (config?.maintenanceModeData?.maintenanceStatus == 1 &&
          config?.maintenanceModeData?.selectedMaintenanceSystem?.customerApp ==
              1 &&
          !config!.localMaintenanceMode!) {
        Navigator.of(GetCtx.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const MaintenanceScreen(),
          settings: const RouteSettings(name: 'MaintenanceScreen'),
        ));
      } else if (Provider.of<AuthController>(GetCtx.context!, listen: false)
              .isLoggedIn() &&
          !configModel!.hasLocaldb!) {
        Provider.of<AuthController>(GetCtx.context!, listen: false)
            .updateToken(GetCtx.context!);
        if (widget.body != null) {
          if (widget.body!.type == 'order') {
            Navigator.of(GetCtx.context!).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) =>
                    OrderDetailsScreen(orderId: widget.body!.orderId)));
          } else if (widget.body!.type == 'notification') {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const NotificationScreen()));
          } else if (widget.body!.type == 'wallet') {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const WalletScreen()));
          } 
          //! chatting ho
          // else if (widget.body!.type == 'chatting') {
          //   Navigator.of(context).pushReplacement(MaterialPageRoute(
          //       builder: (BuildContext context) => InboxScreen(
          //           isBackButtonExist: true,
          //           fromNotification: true,
          //           initIndex:
          //               widget.body!.messageKey == 'message_from_delivery_man'
          //                   ? 0
          //                   : 1)));
          // } 
          else if (widget.body!.type == 'product_restock_update') {
            Navigator.of(GetCtx.context!).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => ProductDetails(
                    productId: int.parse(widget.body!.productId!),
                    slug: widget.body!.slug,
                    isNotification: true)));
          } else {
            Navigator.of(GetCtx.context!).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const NotificationScreen(
                      fromNotification: true,
                    )));
          }
        } else {
          // Navigator.of(GetCtx.context!).pushReplacement(MaterialPageRoute(
          //     builder: (BuildContext context) => const DashBoardScreen()));
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    HomeSliderScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child)),
          );
        }
      } else if (Provider.of<SplashController>(GetCtx.context!, listen: false)
              .showIntro()! &&
          !configModel!.hasLocaldb!) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  HomeSliderScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child)),
        );
      } else if (!configModel!.hasLocaldb! ||
          (configModel.hasLocaldb! &&
              configModel.localMaintenanceMode! &&
              !(config?.maintenanceModeData?.maintenanceStatus == 1 &&
                  config?.maintenanceModeData?.selectedMaintenanceSystem
                          ?.customerApp ==
                      1))) {
        if (Provider.of<AuthController>(GetCtx.context!, listen: false)
                    .getGuestToken() !=
                null &&
            Provider.of<AuthController>(GetCtx.context!, listen: false)
                    .getGuestToken() !=
                '1') {
          // Navigator.of(GetCtx.context!).pushReplacement(MaterialPageRoute(
          //     builder: (BuildContext context) => const DashBoardScreen()));
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomeSliderScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child)),
          );
        } else {
          Provider.of<AuthController>(GetCtx.context!, listen: false)
              .getGuestIdUrl();
          // Navigator.pushAndRemoveUntil(
          //     GetCtx.context!,
          //     MaterialPageRoute(builder: (_) => const DashBoardScreen()),
          //     (route) => false);
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    HomeSliderScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child)),
          );
        }
      }
      // });
    }).then((bool isSuccess) {
      if (isSuccess) {}
    });
  }

  int compareVersions(String version1, String version2) {
    List<String> v1Components = version1.split('.');
    List<String> v2Components = version2.split('.');
    for (int i = 0; i < v1Components.length; i++) {
      int v1Part = int.parse(v1Components[i]);
      int v2Part = int.parse(v2Components[i]);
      if (v1Part > v2Part) {
        return 1;
      } else if (v1Part < v2Part) {
        return -1;
      }
    }
    return 0;
  }
}

// homeApis() async {
//   var dio = Dio();
//   var response = await dio.request(
//     'https://lovexa.ai/api/v1/landing-screen',
//     options: Options(
//       method: 'GET',
//     ),
//   );

//   if (response.statusCode == 200) {
//     // print(json.encode(response.data));
//   } else {
//     print(response.statusMessage);
//   }
// }
