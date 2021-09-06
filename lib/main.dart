import 'package:baku_chat_app/app/controllers/auth_controller.dart';
import 'package:baku_chat_app/app/routes/app_pages.dart';
import 'package:baku_chat_app/app/utils/error_page.dart';
import 'package:baku_chat_app/app/utils/loading_page.dart';
import 'package:baku_chat_app/app/utils/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 5)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Obx(
              () => GetMaterialApp(
                title: "Application",
                initialRoute: authC.isSkipIntro.isTrue
                    ? authC.isAuth.isTrue
                        ? Routes.HOME
                        : Routes.LOGIN
                    : Routes.INTRO,
                getPages: AppPages.routes,
              ),
            );
          }
          return FutureBuilder(
            future: authC.firstInitialized(),
            builder: (context, snapshot) => SplashScreen(),
          );
        });
  }
}
