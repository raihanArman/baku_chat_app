import 'package:baku_chat_app/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_status_controller.dart';

class UpdateStatusView extends GetView<UpdateStatusController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    controller..statusC.text = authC.dataUser.value.status!;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
          backgroundColor: Colors.red[900],
          title: Text('Update Status'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: controller.statusC,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  authC.updateStatus(controller.statusC.text);
                },
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
                height: 30,
              ),
              Container(
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: () {
                      authC.updateStatus(controller.statusC.text);
                    },
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
