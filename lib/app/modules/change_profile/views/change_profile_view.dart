import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
          backgroundColor: Colors.red[900],
          title: Text('Change Profile'),
          centerTitle: true,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.save))],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              AvatarGlow(
                endRadius: 75,
                glowColor: Colors.black,
                duration: Duration(seconds: 2),
                child: Container(
                  margin: EdgeInsets.all(15),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: AssetImage("assets/logo/noimage.png"),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: controller.emailC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: controller.nameC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: controller.statusC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Status",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('no image'),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Pilih file',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Update',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red[900],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                  ))
            ],
          ),
        ));
  }
}
