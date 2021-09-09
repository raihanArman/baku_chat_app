import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  var isShowEmoji = false.obs;
  late FocusNode focusNode;
  late TextEditingController chatC;
  int total_unread = 0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addEmojiToChat(Emoji emoji) {
    chatC.text = chatC.text + emoji.emoji;
  }

  void deleteEmoji() {
    chatC.text = chatC.text.substring(0, chatC.text.length - 2);
  }

  void newChat(
      String email, Map<String, dynamic> arguments, String chat) async {
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");
    String date = DateTime.now().toIso8601String();
    print(email);
    final newChat =
        await chats.doc(arguments["chat_id"]).collection("chat").add({
      "pengirim": email,
      "penerima": arguments["friend_email"],
      "msg": chat,
      "time": date,
      "isRead": false
    });

    await users
        .doc(email)
        .collection("chats")
        .doc(arguments["newChat.id"])
        .update({"lastTime": date});

    final checkChatsFriend = await users
        .doc(arguments["friend_email"])
        .collection("chats")
        .doc(arguments["chat_id"])
        .get();

    if (checkChatsFriend.exists) {
      await users
          .doc(arguments["friend_email"])
          .collection("chats")
          .doc(arguments["chat_id"])
          .get()
          .then((value) => total_unread = value.data()!["total_unread"] as int);

      await users
          .doc(arguments["friend_email"])
          .collection("chats")
          .doc(arguments["chat_id"])
          .update({"lastTime": date, "total_unread": total_unread + 1});
    } else {
      await users
          .doc(arguments["friend_email"])
          .collection("chats")
          .doc(arguments["chat_id"])
          .set({
        "connection": email,
        "lastTime": date,
        "total_unread": total_unread += 1
      });
    }
  }

  @override
  void onInit() {
    chatC = TextEditingController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    chatC.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
