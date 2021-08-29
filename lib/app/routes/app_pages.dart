import 'package:baku_chat_app/app/modules/home/binding/home_binding.dart';
import 'package:baku_chat_app/app/modules/home/view/home_view.dart';
import 'package:baku_chat_app/app/modules/introduction/binding/introduction_binding.dart';
import 'package:baku_chat_app/app/modules/introduction/view/introduction_view.dart';
import 'package:baku_chat_app/app/modules/login/binding/login_binding.dart';
import 'package:baku_chat_app/app/modules/login/view/login_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
        name: _Paths.LOGIN, page: () => LoginView(), binding: LoginBinding()),
    GetPage(
        name: _Paths.INTRODUCTION,
        page: () => IntroductionView(),
        binding: IntroductionBinding())
  ];
}
