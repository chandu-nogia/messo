// import 'dart:async';
// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// class LightDarkScreen extends StatefulWidget {
//   static ui.FragmentShader? shader;
//   const LightDarkScreen({super.key});

//   @override
//   State<LightDarkScreen> createState() => _LightDarkScreenState();
// }

// class _LightDarkScreenState extends State<LightDarkScreen> {
//   bool isDarkMode = false;

//   @override
//   void initState() {
//     super.initState();
//     _toggleTheme();
//   }

//   void _toggleTheme() {
//     Timer.periodic(const Duration(seconds: 3), (timer) {
//       if (mounted) {
//         setState(() {
//           isDarkMode = !isDarkMode;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: isDarkMode ? Colors.black : Colors.white,
//       body: Expanded(
//         child: Container(
//           // color: Colors.red,
//           child: Center(
//             child: tile('shader', a.shader(shader: LightDarkScreen.shader)),
//             // Icon(Icons.sunny, size: 100)
//             // Text(
//             //   isDarkMode ? "Dark Mode" : "Light Mode",
//             //   style: TextStyle(
//             //     fontSize: 24,
//             //     fontWeight: FontWeight.bold,
//             //     color: isDarkMode ? Colors.white : Colors.black,
//             //   ),
//             // ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget tile(String label, Widget demo) => Container(
//       margin: const EdgeInsets.all(4),
//       color: Colors.black12,
//       child: Column(
//         children: [
//           Flexible(child: Center(child: demo)),
//           Container(
//             color: Colors.black12,
//             height: 32,
//             alignment: Alignment.center,
//             child: Text(label, style: const TextStyle(fontSize: 12)),
//           )
//         ],
//       ),
//     );

// // class Frag {

// // }

// Animate get a => box
//     .animate(onPlay: (controller) => controller.repeat())
//     .effect(duration: 3000.ms) // this "pads out" the total duration
//     .effect(delay: 750.ms, duration: 1500.ms);

// Widget get box => Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.red, Colors.green, Colors.blue],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       // width: _boxSize,
//       // height: _boxSize,
//     );

// double _boxSize = 80;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../utill/images.dart';

class LightDarkScreen extends StatefulWidget {
  final bool isDarkMode;

  const LightDarkScreen({super.key, required this.isDarkMode});

  @override
  State<LightDarkScreen> createState() => _LightDarkScreenState();
}

class _LightDarkScreenState extends State<LightDarkScreen> {
  // bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _toggleTheme();
  }

  void _toggleTheme() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
    });
    // Timer.periodic(const Duration(seconds: 3), (timer) {
    //   // if (mounted) {

    //   // }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: AnimatedBox(isDarkMode: widget.isDarkMode), // Animated widget
      ),
    );
  }
}

class AnimatedBox extends StatelessWidget {
  final bool isDarkMode;
  const AnimatedBox({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child:
          Image(image: AssetImage(isDarkMode ? Images.theme : Images.sunnyDay)),
      decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: isDarkMode
          //       ? [Colors.white, Colors.white]
          //       : [Colors.red, Colors.orange],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(duration: 1500.ms, curve: Curves.easeInOut)
        .then(delay: 500.ms) // Pause before next animation
        .shake(hz: 4, duration: 1500.ms); // Shake effect
  }
}
