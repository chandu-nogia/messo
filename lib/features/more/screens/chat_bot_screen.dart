// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_lovexa_ecommerce/features/wallet/screens/add_fund_to_wallet_screen.dart';
import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../theme/controllers/theme_controller.dart';

class ChatrBotScreen extends StatefulWidget {
  final bool policy;
  const ChatrBotScreen({super.key, this.policy = false});

  @override
  State<ChatrBotScreen> createState() => _ChatrBotScreenState();
}

class _ChatrBotScreenState extends State<ChatrBotScreen> {
  bool _isLoading = true;
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _goBack() async {
    if (await _webViewController.canGoBack()) {
      await _webViewController.goBack();
    } else {
      Navigator.pop(context); // Close the screen if no webview history
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(widget.policy == false ? "ChatBot" : "Legal and Policies"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _goBack,
          ),
        ),
        backgroundColor:
         Provider.of<ThemeController>(context).darkTheme
            ? Colors.black
            :
             Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height / 1,
          width: MediaQuery.of(context).size.width / 1,
          color: 
          Provider.of<ThemeController>(context).darkTheme
              ? Colors.black
              :
               Colors.white,
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                    url: WebUri(widget.policy == false
                        ? "https://tawk.to/chat/67dc21a27511c2190e7aea02/1impu6p0l"
                        : "https://lovexa.ai/app-policy-page")),
                initialSettings: InAppWebViewSettings(
                  // hideToolbarTop: true,
                  javaScriptEnabled: true,
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
              ),
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// class ChatBotScreen extends StatefulWidget {
//   const ChatBotScreen({super.key});

//   @override
//   State<ChatBotScreen> createState() => _ChatBotScreenState();
// }

// class _ChatBotScreenState extends State<ChatBotScreen> {
//   late final WebViewController _controller;
//   String url = "https://tawk.to/chat/67dc21a27511c2190e7aea02/1impu6p0l";
//   bool isLoading = true; // Track loading state

//   @override
//   void initState() {
//     super.initState();
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }

//     final WebViewController controller =
//         WebViewController.fromPlatformCreationParams(params);
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (String url) {
//             setState(() {
//               isLoading = true; // Show loader
//             });
//           },
//           onPageFinished: (String url) {
//             setState(() {
//               isLoading = false; // Hide loader
//             });
//           },
//           onWebResourceError: (WebResourceError error) {
//             setState(() {
//               isLoading = false; // Hide loader on error
//             });
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(url));

//     if (controller.platform is AndroidWebViewController) {
//       AndroidWebViewController.enableDebugging(true);
//       (controller.platform as AndroidWebViewController)
//           .setMediaPlaybackRequiresUserGesture(false);
//     }

//     _controller = controller;
//   }

//   // Handle Back Navigation
//   Future<void> _goBack() async {
//     if (await _controller.canGoBack()) {
//       await _controller.goBack();
//     } else {
//       Navigator.pop(context); // Close the screen if no webview history
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("ChatBot"),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: _goBack,
//         ),
//       ),
//       body: Stack(
//         children: [
//           WebViewWidget(controller: _controller),

//           // Show loader while the page is loading
//           if (isLoading)
//             Center(
//               child: CircularProgressIndicator(
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
