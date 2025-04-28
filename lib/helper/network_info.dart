import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/main.dart';
import 'package:provider/provider.dart';

// class NetworkInfo {
//   final Connectivity? connectivity;
//   NetworkInfo(this.connectivity);
//
//    Future<bool> get isConnected async {
//     ConnectivityResult result = await connectivity!.checkConnectivity();
//     return result != ConnectivityResult.none;
//   }
//
//   static void checkConnectivity(BuildContext context) {
//     bool firstTime = true;
//     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
//
//       print("====>>${result.name}");
//
//       bool isNotConnected = result == ConnectivityResult.none;
//       if(!firstTime) {
//         // bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
//         bool isNotConnected;
//         if(result == ConnectivityResult.none) {
//           isNotConnected = true;
//         }else {
//           isNotConnected = !await (_updateConnectivityStatus() as FutureOr<bool>);
//         }
//
//         // isNotConnected ? const SizedBox() : ScaffoldMessenger.of(GetCtx.context!).hideCurrentSnackBar();
//         ScaffoldMessenger.of(GetCtx.context!).showSnackBar(SnackBar(
//           backgroundColor: isNotConnected ? Colors.red : Colors.green,
//           duration: Duration(seconds: isNotConnected ? 6000 : 3),
//           content: Text(
//             isNotConnected ? getTranslated('no_connection', GetCtx.context!)! : getTranslated('connected', GetCtx.context!)!,
//             textAlign: TextAlign.center,
//           ),
//         ));
//       }
//       firstTime = false;
//     });
//   }
//
//   static Future<bool?> _updateConnectivityStatus() async {
//      bool? isConnected;
//      try {
//        final List<InternetAddress> result = await InternetAddress.lookup('google.com');
//        if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//          isConnected = true;
//        }
//      }catch(e) {
//        isConnected = false;
//      }
//      return isConnected;
//   }
// }

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);

  Future<bool> get isConnected async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static void checkConnectivity(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (Provider.of<SplashController>(GetCtx.context!, listen: false)
          .firstTimeConnectionCheck) {
        Provider.of<SplashController>(GetCtx.context!, listen: false)
            .setFirstTimeConnectionCheck(false);
      } else {
        bool isNotConnected = result == ConnectivityResult.none;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(GetCtx.context!).hideCurrentSnackBar();
        ScaffoldMessenger.of(GetCtx.context!).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', GetCtx.context!)!
                : getTranslated('connected', GetCtx.context!)!,
            textAlign: TextAlign.center,
          ),
        ));
      }
    });
  }
}
