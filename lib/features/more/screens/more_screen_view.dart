import 'package:flutter/material.dart';
import 'package:flutter_lovexa_ecommerce/features/auth/screens/login_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/blog/screens/blog_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/order_details/screens/guest_track_order_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_lovexa_ecommerce/features/profile/screens/profile_screen1.dart';
import 'package:flutter_lovexa_ecommerce/features/restock/screens/restock_list_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/support/screens/support_ticket_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/more/widgets/logout_confirm_bottom_sheet_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/chat/screens/inbox_screen.dart';
import 'package:flutter_lovexa_ecommerce/localization/language_constrants.dart';
import 'package:flutter_lovexa_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_lovexa_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_lovexa_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_lovexa_ecommerce/utill/custom_themes.dart';
import 'package:flutter_lovexa_ecommerce/utill/dimensions.dart';
import 'package:flutter_lovexa_ecommerce/utill/images.dart';
import 'package:flutter_lovexa_ecommerce/features/category/screens/category_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/compare/screens/compare_product_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/contact_us/screens/contact_us_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/coupon/screens/coupon_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/more/screens/html_screen_view.dart';
import 'package:flutter_lovexa_ecommerce/features/more/widgets/profile_info_section_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/more/widgets/more_horizontal_section_widget.dart';
import 'package:flutter_lovexa_ecommerce/features/notification/screens/notification_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/address/screens/address_list_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/refer_and_earn/screens/refer_and_earn_screen.dart';
import 'package:flutter_lovexa_ecommerce/features/setting/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../../../common/basewidget/custom_image_widget.dart';
import '../../home/screens/product_for_you.dart';
import 'chat_bot_screen.dart';
import 'faq_screen_view.dart';
import 'package:flutter_lovexa_ecommerce/features/more/widgets/title_button_widget.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});
  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  late bool isGuestMode;
  String? version;
  bool singleVendor = false;

  @override
  void initState() {
      FeatchController().hometitle_Api();
    isGuestMode =
        !Provider.of<AuthController>(context, listen: false).isLoggedIn();
    if (Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      version = Provider.of<SplashController>(context, listen: false)
              .configModel!
              .softwareVersion ??
          'version';
      Provider.of<ProfileController>(context, listen: false)
          .getUserInfo(context);
    }
    singleVendor = Provider.of<SplashController>(context, listen: false)
            .configModel!
            .businessMode ==
        "single";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authController = Provider.of<AuthController>(context, listen: false);
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeController>(context, listen: false).darkTheme
              ? Colors.black
              : Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              shadowColor: Theme.of(context).highlightColor,
              // leading: IconButton(
              //     onPressed: () => Navigator.pop(context),
              //     icon: Icon(
              //       Icons.arrow_back_ios_new_rounded,
              //       size: 18,
              //       color: Provider.of<ThemeController>(context, listen: false)
              //               .darkTheme
              //           ? Colors.white
              //           : Colors.black,
              //     )),
              floating: true,
              elevation: 0,
              expandedHeight: 140,
              pinned: true,
              centerTitle: false,
              automaticallyImplyLeading: true,
              // backgroundColor: Theme.of(context).highlightColor,
              collapsedHeight: 140,
              flexibleSpace: const ProfileInfoSectionWidget()),
          SliverToBoxAdapter(
              child: Container(
            decoration: BoxDecoration(
                color: Provider.of<ThemeController>(context, listen: false)
                        .darkTheme
                    ? Colors.black
                    : Colors.white),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                  padding: EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: Center(child: MoreHorizontalSection())),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    Dimensions.paddingSizeDefault,
                    0,
                    Dimensions.paddingSizeDefault,
                    0),
                child: Text(
                  getTranslated('general', context) ?? '',
                  style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Consumer<SplashController>(
                  builder: (context, splashController, _) {
                return Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.fontSizeExtraSmall),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context)
                                .hintColor
                                .withValues(alpha: .05),
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: const Offset(0, 1))
                      ],
                      color:
                          Provider.of<ThemeController>(context, listen: false)
                                  .darkTheme
                              ? Colors.black
                              : Colors.white,
                      // Provider.of<ThemeController>(context).darkTheme
                      //     ? Colors.white.withValues(alpha: .05)
                      //     : Theme.of(context).cardColor
                    ),
                    child: Column(children: [
                      // MenuButtonWidget(
                      //   image: Images.trackOrderpro,
                      //   title: getTranslated('TRACK_ORDER', context),
                      //   navigateTo: const GuestTrackOrderScreen(),
                      // ),
                      // Divider(color: Colors.grey),
                      if (authController.isLoggedIn()) ...[
                        MenuButtonWidget(
                          image: Images.userpro,
                          title: getTranslated('profile', context),
                          navigateTo: const ProfileScreen1(),
                        ),
                        Divider(color: Colors.grey)
                      ],
                      if (authController.isLoggedIn()) ...[
                        MenuButtonWidget(
                          image: Images.addressespro,
                          title: getTranslated('addresses', context),
                          navigateTo: const AddressListScreen(),
                        ),
                        Divider(color: Colors.grey)
                      ],
                      MenuButtonWidget(
                        image: Images.couponspro,
                        title: getTranslated('coupons', context),
                        navigateTo: const CouponList(),
                      ),
                      Divider(color: Colors.grey),
                      if (!isGuestMode)
                        if (splashController.configModel?.refEarningStatus ==
                            "1") ...[
                          MenuButtonWidget(
                            color: Colors.blue,
                            image: Images.refIcon,
                            title: getTranslated('refer_and_earn', context),
                            isProfile: true,
                            navigateTo: const ReferAndEarnScreen(),
                          ),
                          Divider(color: Colors.grey)
                        ],
                      MenuButtonWidget(
                        // color: Colors.yellow,
                        image: Images.categorespro,
                        title: getTranslated('CATEGORY', context),
                        navigateTo: const CategoryScreen(),
                      ),
                      Divider(color: Colors.grey),
                      if (authController.isLoggedIn()) ...[
                        MenuButtonWidget(
                          // color: Colors.red,
                          image: Images.restockpro,
                          title: getTranslated('restock_requests', context),
                          navigateTo: const RestockListScreen(),
                        ),
                        Divider(color: Colors.grey)
                      ],
                      if (splashController.configModel!.activeTheme !=
                              "default" &&
                          authController.isLoggedIn()) ...[
                        MenuButtonWidget(
                          image: Images.compare,
                          title: getTranslated('compare_products', context),
                          navigateTo: const CompareProductScreen(),
                        ),
                        Divider(color: Colors.grey)
                      ],
                      MenuButtonWidget(
                        // color: Colors.deepOrange,
                        image: Images.notificatpro,
                        title: getTranslated(
                          'notification',
                          context,
                        ),
                        isNotification: true,
                        navigateTo: const NotificationScreen(),
                      ),
                      Divider(color: Colors.grey),
                      MenuButtonWidget(
                        // color: Colors.lightGreen,
                        image: Images.settingspro,
                        title: getTranslated('settings', context),
                        navigateTo: const SettingsScreen(),
                      ),
                      Divider(color: Colors.grey),
                      if (splashController.configModel?.blogUrl?.isNotEmpty ??
                          false) ...[
                        MenuButtonWidget(
                          image: Images.blogIcon,
                          title: getTranslated('blog', context),
                          navigateTo: BlogScreen(
                            url: splashController.configModel?.blogUrl ?? '',
                          ),
                        ),
                        Divider(color: Colors.grey)
                      ],
                    ]),
                  ),
                );
              }),
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                      Dimensions.paddingSizeDefault,
                      Dimensions.paddingSizeDefault,
                      Dimensions.paddingSizeDefault,
                      0),
                  child: Text(getTranslated('help_and_support', context) ?? '',
                      style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: Theme.of(context).colorScheme.onPrimary))),
              Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Container(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Dimensions.fontSizeExtraSmall),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withValues(alpha: .05),
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: const Offset(0, 1))
                          ],
                          color: Provider.of<ThemeController>(context,
                                      listen: false)
                                  .darkTheme
                              ? Colors.black
                              : Colors.white),
                      child: Column(children: [
                        // singleVendor
                        //     ? const SizedBox()
                        //     : MenuButtonWidget(
                        //         // color: Colors.red,
                        //         image: Images.inboxpro,
                        //         title: getTranslated('inbox', context),
                        //         navigateTo: const InboxScreen()),
                        // Divider(color: Colors.grey),
                        MenuButtonWidget(
                            // color: Colors.green,
                            image: Images.contactpro,
                            title: getTranslated('contact_us', context),
                            navigateTo: const ContactUsScreen()),
                        Divider(color: Colors.grey),
                        MenuButtonWidget(
                            // color: Colors.cyan,
                            image: Images.chatbotpro,
                            title: getTranslated('Chat Support', context),
                            navigateTo: const ChatrBotScreen()),
                        Divider(color: Colors.grey),
                        MenuButtonWidget(
                            // color: Colors.cyan,
                            image: Images.supportpro,
                            title: getTranslated('support_ticket', context),
                            navigateTo: const SupportTicketScreen()),
                        Divider(color: Colors.grey),
                        MenuButtonWidget(
                            // color: Colors.brown,
                            image: Images.termConditionpro,
                            title: getTranslated('terms_condition', context),
                            navigateTo: HtmlViewScreen(
                              title: getTranslated('terms_condition', context),
                              url: Provider.of<SplashController>(context,
                                      listen: false)
                                  .configModel!
                                  .termsConditions,
                            )),
                        Divider(color: Colors.grey),
                        MenuButtonWidget(
                            color: Colors.cyan,
                            image: Images.privacyPolicy,
                            title: getTranslated('Legal and Policies', context),
                            navigateTo: ChatrBotScreen(policy: true)),
                        // Divider(color: Colors.grey),
                        // if (Provider.of<SplashController>(context,
                        //             listen: false)
                        //         .configModel!
                        //         .refundPolicy
                        //         ?.status ==
                        //     1)
                        //   MenuButtonWidget(
                        //       // color: Colors.pinkAccent,
                        //       image: Images.refundpro,
                        //       title: getTranslated('refund_policy', context),
                        //       navigateTo: HtmlViewScreen(
                        //         title: getTranslated('refund_policy', context),
                        //         url: Provider.of<SplashController>(context,
                        //                 listen: false)
                        //             .configModel!
                        //             .refundPolicy!
                        //             .content,
                        //       )),
                        // if (Provider.of<SplashController>(context,
                        //             listen: false)
                        //         .configModel!
                        //         .refundPolicy
                        //         ?.status ==
                        //     1)
                        //   Divider(color: Colors.grey),
                        // if (Provider.of<SplashController>(context,
                        //             listen: false)
                        //         .configModel!
                        //         .returnPolicy
                        //         ?.status ==
                        //     1)
                        //   MenuButtonWidget(
                        //       color: Colors.teal,
                        //       image: Images.termCondition,
                        //       title: getTranslated('return_policy', context),
                        //       navigateTo: HtmlViewScreen(
                        //         title: getTranslated('return_policy', context),
                        //         url: Provider.of<SplashController>(context,
                        //                 listen: false)
                        //             .configModel!
                        //             .returnPolicy!
                        //             .content,
                        //       )),
                        // if (Provider.of<SplashController>(context,
                        //             listen: false)
                        //         .configModel!
                        //         .returnPolicy
                        //         ?.status ==
                        //     1)
                        //   Divider(color: Colors.grey),
                        // if (Provider.of<SplashController>(context,
                        //             listen: false)
                        //         .configModel!
                        //         .cancellationPolicy
                        //         ?.status ==
                        //     1)
                        //   MenuButtonWidget(
                        //       color: Colors.limeAccent,
                        //       image: Images.termCondition,
                        //       title:
                        //           getTranslated('cancellation_policy', context),
                        //       navigateTo: HtmlViewScreen(
                        //         title: getTranslated(
                        //             'cancellation_policy', context),
                        //         url: Provider.of<SplashController>(context,
                        //                 listen: false)
                        //             .configModel!
                        //             .cancellationPolicy!
                        //             .content,
                        //       )),
                        // if (Provider.of<SplashController>(context,
                        //             listen: false)
                        //         .configModel!
                        //         .cancellationPolicy
                        //         ?.status ==
                        //     1)
                        //   Divider(color: Colors.grey),
                        // if (Provider.of<SplashController>(context,
                        //             listen: false)
                        //         .configModel!
                        //         .shippingPolicy
                        //         ?.status ==
                        //     1)
                        //   MenuButtonWidget(
                        //       color: Colors.orange,
                        //       image: Images.termCondition,
                        //       title: getTranslated('shipping_policy', context),
                        //       navigateTo: HtmlViewScreen(
                        //         title:
                        //             getTranslated('shipping_policy', context),
                        //         url: Provider.of<SplashController>(context,
                        //                 listen: false)
                        //             .configModel!
                        //             .shippingPolicy!
                        //             .content,
                        //       )),
                        // if (Provider.of<SplashController>(context,
                        //             listen: false)
                        //         .configModel!
                        //         .shippingPolicy
                        //         ?.status ==
                        //     1)
                        Divider(color: Colors.grey),
                        MenuButtonWidget(
                            // color: Colors.deepOrangeAccent,
                            image: Images.faqpro,
                            title: getTranslated('faq', context),
                            navigateTo: FaqScreen(
                              title: getTranslated('faq', context),
                            )),
                        Divider(color: Colors.grey),
                        MenuButtonWidget(
                            // color: Colors.red,
                            image: Images.aboutpro,
                            title: getTranslated('about_us', context),
                            navigateTo: HtmlViewScreen(
                              title: getTranslated('about_us', context),
                              url: Provider.of<SplashController>(context,
                                      listen: false)
                                  .configModel!
                                  .aboutUs,
                            )),
                        Divider(color: Colors.grey),
                      ]))),
              ListTile(
                leading: SizedBox(
                    width: 30,
                    child: Image.asset(
                      Images.logOut,
                      color: Theme.of(context).primaryColor,
                    )),
                title: Text(
                    isGuestMode
                        ? getTranslated('sign_in', context)!
                        : getTranslated('sign_out', context)!,
                    style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge)),
                onTap: () {
                  if (isGuestMode) {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  } else {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) => const LogoutCustomBottomSheetWidget());
                  }
                },
              ),

              SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  width: double.infinity,
                  child: CustomImageWidget(image: "${homeTitleModel.image}")),
              // Image(
              //     image: NetworkImage(
              //         "https://lovexa.ai/storage/app/public/banner/Banner%204.jpg")),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: Dimensions.paddingSizeDefault),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    // '${getTranslated('version', context)} ${AppConstants.appVersion}',
                    'LOVEXA',
                    style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).hintColor),
                  ),
                ]),
              ),
            ]),
          ))
        ],
      ),
    );
  }
}
