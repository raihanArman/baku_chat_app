import 'package:baku_chat_app/app/modules/introduction/controller/introduction_controller.dart';
import 'package:get/get.dart';

class IntroductionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroductionController>(() => IntroductionController());
  }
}
