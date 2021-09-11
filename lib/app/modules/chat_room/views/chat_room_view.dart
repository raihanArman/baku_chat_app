import 'dart:async';
import 'dart:io';

import 'package:baku_chat_app/app/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  final authC = Get.find<AuthController>();
  final String chat_id = (Get.arguments as Map<String, dynamic>)["chat_id"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          leadingWidth: 100,
          leading: InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 5),
                Icon(Icons.arrow_back),
                SizedBox(width: 5),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  child: StreamBuilder<DocumentSnapshot<Object?>>(
                      stream: controller.streamFriendData((Get.arguments
                          as Map<String, dynamic>)["friend_email"]),
                      builder: (context, snapFriendUser) {
                        if (snapFriendUser.connectionState ==
                            ConnectionState.active) {
                          var dataFriend = snapFriendUser.data!.data()
                              as Map<String, dynamic>;
                          if (dataFriend["photoUrl"] == "moimage") {
                            return Image.asset("assets/logo/noimage.png",
                                fit: BoxFit.cover);
                          } else {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(dataFriend["photoUrl"],
                                  fit: BoxFit.cover),
                            );
                          }
                        }
                        return Image.asset("assets/logo/noimage.png",
                            fit: BoxFit.cover);
                      }),
                )
              ],
            ),
          ),
          title: StreamBuilder<DocumentSnapshot<Object?>>(
              stream: controller.streamFriendData(
                  (Get.arguments as Map<String, dynamic>)["friend_email"]),
              builder: (context, snapFriendUser) {
                if (snapFriendUser.connectionState == ConnectionState.active) {
                  var dataFriend =
                      snapFriendUser.data!.data() as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataFriend["name"],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        dataFriend["status"],
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lorem Ipsum',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'statusnya Lorem Ipsum',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                );
              }),
        ),
        body: WillPopScope(
          onWillPop: () {
            if (controller.isShowEmoji.isTrue) {
              controller.isShowEmoji.value = false;
            } else {
              Navigator.pop(context);
            }
            return Future.value(false);
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: controller.streamChats(chat_id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          var allData = snapshot.data!.docs;
                          Timer(
                              Duration.zero,
                              () => controller.scrollC.jumpTo(
                                  controller.scrollC.position.maxScrollExtent));
                          return ListView.builder(
                              controller: controller.scrollC,
                              itemCount: allData.length,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${allData[index]["groupTime"]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ItemChat(
                                        isSender: allData[index]["pengirim"] ==
                                                authC.dataUser.value.email!
                                            ? true
                                            : false,
                                        msg: "${allData[index]["msg"]}",
                                        time: "${allData[index]["time"]}",
                                      )
                                    ],
                                  );
                                } else {
                                  if (allData[index]["groupTime"] ==
                                      allData[index - 1]["groupTime"]) {
                                    return ItemChat(
                                      isSender: allData[index]["pengirim"] ==
                                              authC.dataUser.value.email!
                                          ? true
                                          : false,
                                      msg: "${allData[index]["msg"]}",
                                      time: "${allData[index]["time"]}",
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        Text(
                                          "${allData[index]["groupTime"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ItemChat(
                                          isSender: allData[index]
                                                      ["pengirim"] ==
                                                  authC.dataUser.value.email!
                                              ? true
                                              : false,
                                          msg: "${allData[index]["msg"]}",
                                          time: "${allData[index]["time"]}",
                                        )
                                      ],
                                    );
                                  }
                                }
                              });
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                  // child: ListView(
                  //   children: [
                  //     ItemChat(isSender: true, msg: "Apa tong"),
                  //     ItemChat(
                  //       isSender: false,
                  //       msg: "Wadidaw",
                  //     )
                  //   ],
                  // ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: controller.isShowEmoji.isTrue
                        ? 5
                        : context.mediaQueryPadding.bottom),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: TextField(
                          autocorrect: false,
                          controller: controller.chatC,
                          focusNode: controller.focusNode,
                          onEditingComplete: () => controller.newChat(
                              authC.dataUser.value.email!,
                              Get.arguments as Map<String, dynamic>,
                              controller.chatC.text),
                          decoration: InputDecoration(
                              prefixIcon: IconButton(
                                  onPressed: () {
                                    controller.isShowEmoji.toggle();
                                    controller.focusNode.unfocus();
                                  },
                                  icon: Icon(Icons.emoji_emotions_outlined)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100))),
                        ),
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.red[900],
                      child: InkWell(
                        onTap: () => controller.newChat(
                            authC.dataUser.value.email!,
                            Get.arguments as Map<String, dynamic>,
                            controller.chatC.text),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => (controller.isShowEmoji.isTrue)
                  ? Container(
                      height: 325,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          controller.addEmojiToChat(emoji);
                        },
                        onBackspacePressed: () {
                          controller.deleteEmoji();
                        },
                        config: Config(
                            columns: 7,
                            emojiSizeMax: 32 *
                                (Platform.isIOS
                                    ? 1.30
                                    : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            initCategory: Category.RECENT,
                            bgColor: Color(0xFFF2F2F2),
                            indicatorColor: Colors.blue,
                            iconColor: Colors.grey,
                            iconColorSelected: Colors.blue,
                            progressIndicatorColor: Colors.blue,
                            showRecentsTab: true,
                            recentsLimit: 28,
                            noRecentsText: "No Recents",
                            noRecentsStyle: const TextStyle(
                                fontSize: 20, color: Colors.black26),
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL),
                      ),
                    )
                  : SizedBox())
            ],
          ),
        ));
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat(
      {Key? key, required this.isSender, required this.msg, required this.time})
      : super(key: key);

  final bool isSender;
  final String msg;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.red[900],
                  borderRadius: isSender
                      ? BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        )
                      : BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        )),
              padding: EdgeInsets.all(15),
              child: Text(
                '$msg',
                style: TextStyle(color: Colors.white),
              )),
          SizedBox(
            height: 5,
          ),
          Text(DateFormat.jm().format(DateTime.parse(time))),
        ],
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
