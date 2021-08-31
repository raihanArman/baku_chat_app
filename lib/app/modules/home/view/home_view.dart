import 'package:baku_chat_app/app/modules/home/controller/home_controller.dart';
import 'package:baku_chat_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  final List<Widget> myChats = List.generate(
      20,
      (index) => ListTile(
            onTap: () {
              Get.toNamed(Routes.CHAT_ROOM);
            },
            leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black26,
                child: Image.asset(
                  "assets/logo/noimage.png",
                  fit: BoxFit.cover,
                )),
            title: Text(
              'Namanya',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Namanya',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            trailing: Chip(
              label: Text('3'),
            ),
          )).reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
            elevation: 5,
            child: Container(
              margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black38)),
              ),
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chats',
                    style: TextStyle(fontSize: 35),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.red[900],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => Get.toNamed(Routes.PROFILE),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: myChats.length,
              itemBuilder: (context, index) => myChats[index],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH),
        child: Icon(Icons.search),
        backgroundColor: Colors.red[900],
      ),
    );
  }
}
