import 'package:baku_chat_app/app/controllers/auth_controller.dart';
import 'package:baku_chat_app/app/routes/app_pages.dart';
import 'package:baku_chat_app/app/utils/error_page.dart';
import 'package:baku_chat_app/app/utils/loading_page.dart';
import 'package:baku_chat_app/app/utils/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final authC = Get.put(AuthController(), permanent: true);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return ErrorPage();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder(
              future: Future.delayed(Duration(seconds: 3)),
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
                return SplashScreen();
              });
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingPage();
      },
    );
  }
}
