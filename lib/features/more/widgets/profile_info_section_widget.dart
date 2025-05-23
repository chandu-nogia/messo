import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_lovexa_ecommerce/features/profile/screens/profile_screen1.dart';
import 'package:flutter_lovexa_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/custom_themes.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/utill/images.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

import '../screens/ligt_dart_screen.dart';

class ProfileInfoSectionWidget extends StatefulWidget {
  const ProfileInfoSectionWidget({super.key});

  @override
  State<ProfileInfoSectionWidget> createState() =>
      _ProfileInfoSectionWidgetState();
}

class _ProfileInfoSectionWidgetState extends State<ProfileInfoSectionWidget> {
  @override
  Widget build(BuildContext context) {
    bool isGuestMode =
        !Provider.of<AuthController>(context, listen: false).isLoggedIn();
    return Consumer<ProfileController>(builder: (context, profile, _) {
      return Container(
          decoration: BoxDecoration(
              color: Provider.of<ThemeController>(context).darkTheme
                  ? Colors.black
                  : Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Stack(children: [
              Container(
                  transform: Matrix4.translationValues(-10, 0, 0),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SizedBox(
                          width: 110,
                          child: Image.asset(Images.shadow,
                              opacity: const AlwaysStoppedAnimation(0.75))))),
              Positioned(
                  right: -110,
                  bottom: -100,
                  child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: Theme.of(context)
                                  .cardColor
                                  .withValues(alpha: .05),
                              width: 25)))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                      Dimensions.paddingSizeDefault,
                      70.0,
                      Dimensions.paddingSizeDefault,
                      30),
                  child: Row(children: [
                    InkWell(
                      onTap: () {
                        if (isGuestMode) {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (_) =>
                                  const NotLoggedInBottomSheetWidget());
                        } else {
                          if (profile.userInfoModel != null) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProfileScreen1()));
                          }
                        }
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Provider.of<AuthController>(context,
                                      listen: false)
                                  .isLoggedIn()
                              ? CustomImageWidget(
                                  image:
                                      '${profile.userInfoModel?.imageFullUrl?.path}',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  placeholder: Images.guestProfile)
                              : Image.asset(Images.guestProfile, width: 60)),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            !isGuestMode
                                ? '${profile.userInfoModel?.fName ?? ''} ${profile.userInfoModel?.lName ?? ''}'
                                : 'Guest',
                            style: textMedium.copyWith(
                                // color: ColorResources.black,
                                fontSize: Dimensions.fontSizeExtraLarge)),
                        if (!isGuestMode &&
                            profile.userInfoModel?.phone != null &&
                            profile.userInfoModel!.phone!.isNotEmpty)
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                        if (!isGuestMode)
                          Text(profile.userInfoModel?.phone ?? '',
                              style: textRegular.copyWith(
                                  // color: ColorResources.black,
                                  fontSize: Dimensions.fontSizeLarge)),
                      ],
                    )),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LightDarkScreen(
                                    isDarkMode:
                                        Provider.of<ThemeController>(context)
                                                .darkTheme
                                            ? false
                                            : true))).then(
                          (value) {
                            Provider.of<ThemeController>(context, listen: false)
                                .toggleTheme();
                          },
                        );
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: 30,
                              child: Image.asset(
                                  Provider.of<ThemeController>(context)
                                          .darkTheme
                                      ? Images.sunnyDay
                                      : Images.theme,
                                  color: Provider.of<ThemeController>(context)
                                          .darkTheme
                                      ? Colors.white
                                      : Colors.black))),
                    )
                  ])),
            ]),
          ));
    });
  }
}
