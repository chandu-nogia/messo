import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_lovexa_ecommerce/features/order_details/widgets/cancel_order_dialog_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_lovexa_ecommerce/features/reorder/controllers/re_order_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/support/screens/support_ticket_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/tracking/screens/tracking_result_screen.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/color_resources.dart';
import 'package:flutter_lovexa_ecommerce/utill/custom_themes.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class CancelAndSupportWidget extends StatelessWidget {
  final Orders? orderModel;
  final bool fromNotification;
  const CancelAndSupportWidget(
      {super.key, this.orderModel, this.fromNotification = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: Dimensions.paddingSizeSmall),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SupportTicketScreen())),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: getTranslated(
                      'if_you_cannot_contact_with_seller_or_facing_any_trouble_then_contact',
                      context),
                  style: titilliumRegular.copyWith(
                      color: ColorResources.hintTextColor,
                      fontSize: Dimensions.fontSizeSmall),
                ),
                TextSpan(
                    text: ' ${getTranslated('SUPPORT_CENTER', context)}',
                    style: titilliumSemiBold.copyWith(
                        color: ColorResources.getPrimary(context)))
              ]))),
          const SizedBox(height: Dimensions.homePagePadding),
          (orderModel != null &&
                  (orderModel!.customerId! ==
                      int.parse(Provider.of<ProfileController>(context, listen: false)
                          .userID)) &&
                  (orderModel!.orderStatus == 'pending') &&
                  (orderModel!.orderType != "POS"))
              ? CustomButton(
                  textColor: Theme.of(context).colorScheme.error,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .error
                      .withValues(alpha: 0.1),
                  buttonText: getTranslated('cancel_order', context),
                  onTap: () {
                    print("hello::: Cencel");
                    showCancelDialog(context, orderModel!.id);
                  },
                )
              : (orderModel != null &&
                      Provider.of<AuthController>(context, listen: false)
                          .isLoggedIn() &&
                      orderModel!.customerId! ==
                          int.parse(
                              Provider.of<ProfileController>(context, listen: false)
                                  .userID) &&
                      (orderModel!.orderStatus == 'delivered' ||
                          orderModel!.orderStatus == 'canceled') &&
                      orderModel!.orderType != "POS")
                  ? CustomButton(
                      textColor: ColorResources.white,
                      backgroundColor: Theme.of(context).primaryColor,
                      buttonText: getTranslated('re_order', context),
                      onTap: () =>
                          Provider.of<ReOrderController>(context, listen: false)
                              .reorder(orderId: orderModel?.id.toString()))
                  : (Provider.of<AuthController>(context, listen: false).isLoggedIn() &&
                          orderModel!.customerId! ==
                              int.parse(
                                  Provider.of<ProfileController>(context, listen: false)
                                      .userID) &&
                          orderModel!.orderType != "POS" &&
                          (orderModel!.orderStatus != 'canceled' &&
                              orderModel!.orderStatus != 'returned' &&
                              orderModel!.orderStatus != 'fail_to_delivered'))
                      ? CustomButton(
                          buttonText: getTranslated('TRACK_ORDER', context),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => TrackingResultScreen(
                                      orderID: orderModel!.id.toString()))),
                        )
                      : const SizedBox(),
          const SizedBox(width: Dimensions.paddingSizeSmall),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class CancelOrderController extends GetxController {
  var selectedReason = RxnString();
  TextEditingController commentController = TextEditingController();

  final List<String> cancelReasons = [
    "Changed my mind",
    "Ordered by mistake",
    "Found a better price",
    "Delivery is taking too long",
    "Other"
  ];
}

// class CancelOrderScreen  {

void showCancelDialog(BuildContext context, int? orderId) {
  final CancelOrderController controller = Get.put(CancelOrderController());
  Get.bottomSheet(
    backgroundColor: Colors.white,
    Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Cancel Order",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Obx(() => Column(
                children: controller.cancelReasons
                    .map((reason) => RadioListTile<String>(
                          title: Text(reason),
                          value: reason,
                          groupValue: controller.selectedReason.value,
                          onChanged: (value) {
                            controller.selectedReason.value = value;
                          },
                        ))
                    .toList(),
              )),
          const SizedBox(height: 16),
          CustomButton(
            buttonText: "Submit",
            onTap: () {
              // controller.submitCancellation(orderId);
              //  void submitCancellation(id) {
              if (controller.selectedReason.value == null) {
                Get.snackbar("Error", "Please select a reason for cancellation",
                    snackPosition: SnackPosition.BOTTOM);
                // return;
              } else {
                showDialog(
                    context: GetCtx.context!,
                    builder: (context) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: CancelOrderDialogWidget(
                              orderId: orderId!,
                              reason: controller.selectedReason.value),
                        ));
              }
            },
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
  );
}
