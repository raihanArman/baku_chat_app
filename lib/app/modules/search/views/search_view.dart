import 'package:baku_chat_app/app/controllers/auth_controller.dart';
import 'package:baku_chat_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(140),
          child: AppBar(
            backgroundColor: Colors.red[900],
            title: Text('SearchView'),
            centerTitle: true,
            leading: IconButton(
                onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(25, 50, 20, 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextField(
                  controller: controller.searchC,
                  cursorColor: Colors.red[900],
                  onChanged: (value) => controller.searchFriend(
                      value, authC.dataUser.value.email!),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.white, width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.white, width: 1)),
                    hintText: "Search new friend here..",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    suffixIcon: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      child: Icon(
                        Icons.search,
                        color: Colors.red[900],
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Obx(() => controller.tempSearch.length == 0
            ? Center(
                child: Container(
                  width: Get.width * 0.7,
                  height: Get.width * 0.7,
                  child: Lottie.asset("assets/lottie/empty.json"),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.tempSearch.length,
                itemBuilder: (context, index) => ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black26,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: controller.tempSearch[index]["photoUrl"] ==
                                "noimage"
                            ? Image.asset(
                                "assets/logo/noimage.png",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                controller.tempSearch[index]["photoUrl"],
                                fit: BoxFit.cover),
                      )),
                  title: Text(
                    "${controller.tempSearch[index]["name"]}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${controller.tempSearch[index]["email"]}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  trailing: GestureDetector(
                    onTap: () => authC.addNewConnection(
                        controller.tempSearch[index]["email"]),
                    child: Chip(
                      label: Text('message'),
                    ),
                  ),
                ),
              )));
  }
}
