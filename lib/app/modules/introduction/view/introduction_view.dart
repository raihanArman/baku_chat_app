import 'package:baku_chat_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class IntroductionView extends StatelessWidget {
  const IntroductionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Berinteraksi dengan mudah",
            body: "Kamu hanya perlu di rumah saja untuk mendapatkan teman baru",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset("assets/lottie/main-laptop-duduk.json"),
              ),
            ),
          ),
          PageViewModel(
            title: "Temukan sahabat baru mu",
            body:
                "Jika kamu memang jodoh karena aplikasi ini, kamu sangat bahagia",
            image: Center(
              child: Lottie.asset("assets/lottie/ojek.json"),
            ),
          ),
          PageViewModel(
            title: "Aplikasi bebas biaya",
            body: "Kamu tidak perlu, aplikasi ini bebas biaya apapun",
            image: Center(
              child: Lottie.asset("assets/lottie/payment.json"),
            ),
          ),
          PageViewModel(
            title: "Gabung sekarang juga",
            body:
                "Daftarkan diri kamu untuk menjadi bagian dari kami, kami akan menghubungkan dengan seribu user",
            image: Center(
              child: Lottie.asset("assets/lottie/register.json"),
            ),
          )
        ],
        onDone: () => Get.offAllNamed(Routes.LOGIN),
        showSkipButton: true,
        skip: Text('Skip'),
        next: Text(
          'Next',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        done:
            const Text("Login", style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}
