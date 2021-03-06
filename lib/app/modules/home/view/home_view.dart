import 'package:baku_chat_app/app/controllers/auth_controller.dart';
import 'package:baku_chat_app/app/modules/home/controller/home_controller.dart';
import 'package:baku_chat_app/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();

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
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.chatsStream(authC.dataUser.value.email!),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.active) {
                  var listDocsChats = snapshot1.data!.docs;
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: listDocsChats.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                            stream: controller.friendStream(
                                listDocsChats[index]["connection"]),
                            builder: (context, snapshot2) {
                              if (snapshot2.connectionState ==
                                  ConnectionState.active) {
                                var data = snapshot2.data!.data();
                                return data!["status"] == ""
                                    ? ListTile(
                                        onTap: () {
                                          controller.gotoChatRoom(
                                              "${listDocsChats[index].id}",
                                              authC.dataUser.value.email!,
                                              listDocsChats[index]
                                                  ["connection"]);
                                        },
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        leading: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.black26,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child:
                                                  data["photoUrl"] == "noimage"
                                                      ? Image.asset(
                                                          "assets/logo/noimage.png",
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          data["photoUrl"],
                                                          fit: BoxFit.cover),
                                            )),
                                        title: Text(
                                          '${data["name"]}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        trailing: listDocsChats[index]
                                                    ["total_unread"] ==
                                                0
                                            ? SizedBox()
                                            : Chip(
                                                backgroundColor:
                                                    Colors.red[900],
                                                label: Text(
                                                  '${listDocsChats[index]["total_unread"]}',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                      )
                                    : ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        onTap: () {
                                          controller.gotoChatRoom(
                                              "${listDocsChats[index].id}",
                                              authC.dataUser.value.email!,
                                              listDocsChats[index]
                                                  ["connection"]);
                                        },
                                        leading: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.black26,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child:
                                                  data["photoUrl"] == "noimage"
                                                      ? Image.asset(
                                                          "assets/logo/noimage.png",
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          data["photoUrl"],
                                                          fit: BoxFit.cover),
                                            )),
                                        title: Text(
                                          '${data["name"]}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: Text(
                                          '${data["status"]}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        trailing: listDocsChats[index]
                                                    ["total_unread"] ==
                                                0
                                            ? SizedBox()
                                            : Chip(
                                                backgroundColor:
                                                    Colors.red[900],
                                                label: Text(
                                                  '${listDocsChats[index]["total_unread"]}',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                      );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            });
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          // Expanded(
          //   child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          //     stream: controller.chatsStream(authC.dataUser.value.email!),
          //     builder: (context, snapshot1) {
          //       if (snapshot1.connectionState == ConnectionState.active) {
          //         var allChats = (snapshot1.data!.data()
          //             as Map<String, dynamic>)["chats"] as List;
          //         return ListView.builder(
          //             padding: EdgeInsets.zero,
          //             itemCount: allChats.length,
          //             itemBuilder: (context, index) {
          //               return StreamBuilder<
          //                       DocumentSnapshot<Map<String, dynamic>>>(
          //                   stream: controller
          //                       .friendStream(allChats[index]['connection']),
          //                   builder: (context, snapshot2) {
          //                     if (snapshot2.connectionState ==
          //                         ConnectionState.active) {
          //                       var data = snapshot2.data!.data();
          //                       return data!["status"] == ""
          //                           ? ListTile(
          //                               onTap: () {
          //                                 Get.toNamed(Routes.CHAT_ROOM);
          //                               },
          //                               leading: CircleAvatar(
          //                                   radius: 30,
          //                                   backgroundColor: Colors.black26,
          //                                   child: ClipRRect(
          //                                     borderRadius:
          //                                         BorderRadius.circular(100),
          //                                     child:
          //                                         data["photoUrl"] == "noimage"
          //                                             ? Image.asset(
          //                                                 "assets/logo/noimage.png",
          //                                                 fit: BoxFit.cover,
          //                                               )
          //                                             : Image.network(
          //                                                 data["photoUrl"],
          //                                                 fit: BoxFit.cover),
          //                                   )),
          //                               title: Text(
          //                                 '${data["name"]}',
          //                                 style: TextStyle(
          //                                     fontSize: 20,
          //                                     fontWeight: FontWeight.w600),
          //                               ),
          //                               trailing:
          //                                   allChats[index]["total_unread"] == 0
          //                                       ? Chip(
          //                                           label: Text(
          //                                               '${allChats[index]["total_unread"]}'),
          //                                         )
          //                                       : SizedBox(),
          //                             )
          //                           : ListTile(
          //                               onTap: () {
          //                                 Get.toNamed(Routes.CHAT_ROOM);
          //                               },
          //                               leading: CircleAvatar(
          //                                   radius: 30,
          //                                   backgroundColor: Colors.black26,
          //                                   child: ClipRRect(
          //                                     borderRadius:
          //                                         BorderRadius.circular(100),
          //                                     child:
          //                                         data["photoUrl"] == "noimage"
          //                                             ? Image.asset(
          //                                                 "assets/logo/noimage.png",
          //                                                 fit: BoxFit.cover,
          //                                               )
          //                                             : Image.network(
          //                                                 data["photoUrl"],
          //                                                 fit: BoxFit.cover),
          //                                   )),
          //                               title: Text(
          //                                 '${data["name"]}',
          //                                 style: TextStyle(
          //                                     fontSize: 20,
          //                                     fontWeight: FontWeight.w600),
          //                               ),
          //                               subtitle: Text(
          //                                 '${data["status"]}',
          //                                 style: TextStyle(
          //                                     fontSize: 16,
          //                                     fontWeight: FontWeight.w600),
          //                               ),
          //                               trailing:
          //                                   allChats[index]["total_unread"] == 0
          //                                       ? Chip(
          //                                           label: Text(
          //                                               '${allChats[index]["total_unread"]}'),
          //                                         )
          //                                       : SizedBox(),
          //                             );
          //                     } else {
          //                       return Center(
          //                           child: CircularProgressIndicator());
          //                     }
          //                   });
          //             });
          //       }
          //       return Center(child: CircularProgressIndicator());
          //     },
          //   ),
          //   // child: ListView.builder(
          //   //   padding: EdgeInsets.zero,
          //   //   itemCount: myChats.length,
          //   //   itemBuilder: (context, index) => myChats[index],
          //   // ),
          // )
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
