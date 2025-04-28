import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/utill/custom_themes.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/utill/images.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_button_widget.dart';

import '../../../main.dart';
import '../../../utill/color_resources.dart';
import '../../dashboard/screens/dashboard_screen.dart';

class OrderPlaceDialogWidget extends StatelessWidget {
  final bool isFailed;
  final double rotateAngle;
  final IconData icon;
  final String? title;
  final String? description;
  const OrderPlaceDialogWidget(
      {super.key,
      this.isFailed = false,
      this.rotateAngle = 0,
      required this.icon,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeDefault),
            child:
                SizedBox(width: 60, child: Image.asset(Images.orderPlaceIcon)),
          ),
          Text(title!,
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              maxLines: 2,
              textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Text(description!,
              textAlign: TextAlign.center, style: titilliumRegular),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
          SizedBox(
              height: 35,
              width: 90,
              child: CustomButton(
                  radius: 5,
                  buttonText: getTranslated('ok', context),
                  onTap: () => Navigator.pop(context))),
        ]),
      ),
    );
  }
}

class OrderSuccessWidget extends StatelessWidget {
  final bool isFailed;
  final double rotateAngle;
  final IconData icon;
  final String? title;
  final String? description;
  const OrderSuccessWidget(
      {super.key,
      this.isFailed = false,
      this.rotateAngle = 0,
      required this.icon,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // onPopInvoked: (didPop) {},
      onPopInvokedWithResult: (didPop, result) {
        Navigator.of(GetCtx.context!).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const DashBoardScreen()),
            (route) => false);
        return;
      },
      child: Scaffold(
        backgroundColor: Color(0xff307c32),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeDefault),
                child: SizedBox(
                  // width: 60,
                  child: Icon(
                    Icons.check_circle,
                    size: 100,
                    color: Colors.white,
                  )
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.easeOutBack),

                  //  Image.asset(Images.orderPlaceIcon,
                  //         color: ColorResources.white)
                  //     .animate()
                  //     .scale(duration: 500.ms)
                  //     .fadeIn()
                ),
              ),
              Text(title!,
                      style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: ColorResources.white),
                      maxLines: 2,
                      textAlign: TextAlign.center)
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 1, end: 0),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(description!,
                      textAlign: TextAlign.center,
                      style: titilliumRegular.copyWith(
                          color: ColorResources.white, fontSize: 14))
                  .animate()
                  .fadeIn(duration: 700.ms)
                  .slideY(begin: 1, end: 0),
              const SizedBox(
                height: Dimensions.paddingSizeExtraLarge,
              ),
              SizedBox(
                  height: 35,
                  width: 90,
                  child: CustomButton(
                          backgroundColor: ColorResources.white,
                          textColor: ColorResources.green,
                          radius: 5,
                          buttonText: getTranslated('ok', context),
                          onTap: () {
                            Navigator.of(GetCtx.context!).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => const DashBoardScreen()),
                                (route) => false);
                            // Navigator.pop(context);
                          })
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .slideY(begin: 1, end: 0)),
            ]),
          ),
        ),
      ),
    );
  }
}
