import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../main.dart';
import '../screens/infinit_search_screen.dart';
import 'search_product_controller.dart';

class VoiceSearchController extends GetxController {
  var selectBrandId = [].obs;
  var selectCatId = [].obs;
  var speech = stt.SpeechToText();
  var isListening = false.obs; // Observable boolean
  var searchText = "Speak to search".obs; // Observable string
  final _pageController = Get.put(SearchPageController());
  void startListening() async {
    bool available = await speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          // _pageController.searchText.value = result.recognizedWords;
          _pageController.resetPagination();

          _pageController.pagingController.refresh();
          _pageController.pagingController.fetchNextPage();

          Get.back(); // Close the voice search screen when done
        }
        print("Status: $status");
      },
      onError: (error) => print("Error: $error"),
    );

    if (available) {
      isListening.value = true;
      speech.listen(
        onResult: (result) {
          _pageController.searchText.value = result.recognizedWords;
          Provider.of<SearchProductController>(GetCtx.context!, listen: false)
              .searchController
              .text = result.recognizedWords;
          searchText.value = result.recognizedWords;
          if (result.recognizedWords.isNotEmpty) {
            Provider.of<SearchProductController>(GetCtx.context!, listen: false)
                .saveSearchAddress(result.recognizedWords);
          }
        },
      );
    }
  }

  void stopListening() {
    speech.stop();
    isListening.value = false;
  }

  @override
  void dispose() {
    searchText.value = "Speak to search";
    // TODO: implement dispose
    super.dispose();
  }
}

class VoiceSearchPage extends StatefulWidget {
  @override
  State<VoiceSearchPage> createState() => _VoiceSearchPageState();
}

class _VoiceSearchPageState extends State<VoiceSearchPage> {
  final VoiceSearchController controller = Get.put(VoiceSearchController());
  @override
  void initState() {
    controller.startListening();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.searchText.value = "Speak to search";

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(controller.searchText.value,
                style: const TextStyle(fontSize: 20))),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () => controller.isListening.value
                  ? controller.stopListening()
                  : controller.startListening(),
              child: Obx(() => Icon(
                  controller.isListening.value ? Icons.mic : Icons.mic_off)),
            ),
          ],
        ),
      ),
    );
  }
}
