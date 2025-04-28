import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lovexa_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../localization/language_constrants.dart';
import '../../theme/controllers/theme_controller.dart';
import '../../utill/color_resources.dart';
import '../../utill/images.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget title = const Text(
      'Coming Soon',
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 40,
        color: Color(0xFF666870),
        height: 1,
        letterSpacing: -1,
      ),
    );
    title = title
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1200.ms, color: const Color(0xFF80DDFF))
        .animate() // this wraps the previous Animate in another Animate
        .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
        .slide();
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeController>(context, listen: false).darkTheme
              ? Colors.black
              : Colors.white,
      appBar: CustomAppBar(
          title: getTranslated('AI', context), isBackButtonExist: false),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(Images.ai), color: Colors.black54)
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                    duration: 1200.ms, color: const Color(0xFF80DDFF))
                .animate() // this wraps the previous Animate in another Animate
                .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                .slide(),
            title,
          ],
        ),
      ),
    );
  }
}
