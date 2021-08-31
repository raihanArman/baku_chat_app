import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: Get.width * 0.6,
                    height: Get.width * 0.7,
                    child: Lottie.asset("assets/lottie/login.json"),
                  ),
                ),
                SizedBox(
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset("assets/logo/google.png"),
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Sign in with google',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red[900],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Text('Baku Chat'),
                Text('Versi 1.0'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
