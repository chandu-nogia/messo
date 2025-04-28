import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_lovexa_ecommerce/utill/color_resources.dart';
import 'package:flutter_lovexa_ecommerce/utill/custom_themes.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class MenuButtonWidget extends StatelessWidget {
  final String image;
  final String? title;
  final Widget navigateTo;
  final bool isNotification;
  final bool isProfile;
  final Color? color;
  const MenuButtonWidget({super.key, required this.image, required this.title, required this.navigateTo,
    this.isNotification = false, this.isProfile = false,this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(contentPadding: EdgeInsets.zero,
    visualDensity: VisualDensity(horizontal: -4, vertical: -4),

    dense: true,
        trailing: isNotification? Consumer<NotificationController>(
            builder: (context, notificationController, _) {
              return CircleAvatar(radius: 12, backgroundColor: ColorResources.yellow,
                child: Text(notificationController.notificationModel?.newNotificationItem.toString() ?? '0',
                    style: textRegular.copyWith(color: ColorResources.black, fontSize: Dimensions.fontSizeSmall)),
              );}):

        isProfile? Consumer<ProfileController>(
            builder: (context, profileProvider, _) {
              return CircleAvatar(radius: 12, backgroundColor: Theme.of(context).primaryColor,
                  child: Text(profileProvider.userInfoModel?.referCount.toString() ?? '0',
                      style: textRegular.copyWith(color: ColorResources.white,
                          fontSize: Dimensions.fontSizeSmall)));}):
        const SizedBox(),


        leading: CustomAssetImageWidget(image, width: 20, height: 20, fit: BoxFit.fill,
          color:color),
        title: Text(title!, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo)));
  }
}