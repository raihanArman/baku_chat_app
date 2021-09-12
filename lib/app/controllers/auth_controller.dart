import 'package:baku_chat_app/app/data/models/users_model.dart';
import 'package:baku_chat_app/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  var dataUser = UsersModel().obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> firstInitialized() async {
    print("Proses");
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      } else {
        print("False ki login");
      }
    });

    await skipIntro().then((value) {
      if (value) {
        isSkipIntro.value = true;
      } else {
        print("False ki skip intro");
      }
    });
  }

  Future<bool> skipIntro() async {
    final box = GetStorage();
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);

        final googleAuth = await _currentUser!.authentication;
        final credentials = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

        await FirebaseAuth.instance
            .signInWithCredential(credentials)
            .then((value) => userCredential = value);

        print(userCredential);

        CollectionReference user = firestore.collection('users');

        await user.doc(_currentUser!.email).update({
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String()
        });

        final currentUser = await user.doc(_currentUser!.email).get();
        final curUserData = currentUser.data() as Map<String, dynamic>;

        dataUser(UsersModel.fromJson(curUserData));
        dataUser.refresh();

        final listChats =
            await user.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatUser> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat["connection"],
                lastTime: dataDocChat["lastTime"],
                total_unread: dataDocChat["total_unread"]));
          });
          dataUser.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          dataUser.update((user) {
            user!.chats = [];
          });
        }

        dataUser.refresh();
        return true;
      }
      return false;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<void> login() async {
    // Get.offAllNamed(Routes.HOME);
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);
      final isSignIn = await _googleSignIn.isSignedIn();

      if (isSignIn) {
        print(_currentUser);

        final googleAuth = await _currentUser!.authentication;
        final credentials = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

        await FirebaseAuth.instance
            .signInWithCredential(credentials)
            .then((value) => userCredential = value);

        print(userCredential);

        final box = GetStorage();
        if (box.read('skipIntro') != null) {
          box.remove('skipIntro');
        }
        box.write('skipIntro', true);

        CollectionReference user = firestore.collection('users');

        final checkUser = await user.doc(_currentUser!.email).get();
        if (checkUser.data() == null) {
          await user.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "email": _currentUser!.email,
            "keyName": _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            "photoUrl": _currentUser!.photoUrl ?? "noimage",
            "status": "",
            "creationTime":
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String()
          });

          await user.doc(_currentUser!.email).collection("chats");
        } else {
          await user.doc(_currentUser!.email).update({
            "lastSignInTime":
                userCredential!.user!.metadata.lastSignInTime!.toIso8601String()
          });
        }

        final currentUser = await user.doc(_currentUser!.email).get();
        final curUserData = currentUser.data() as Map<String, dynamic>;

        dataUser(UsersModel.fromJson(curUserData));
        dataUser.refresh();

        final listChats =
            await user.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatUser> dataListChats = List.empty();
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat["connection"],
                lastTime: dataDocChat["lastTime"],
                total_unread: dataDocChat["total_unread"]));
          });
          dataUser.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          dataUser.update((user) {
            user!.chats = [];
          });
        }

        dataUser.refresh();

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {
        print("Tidak berhasil login");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void changeProfile(String name, String status) {
    CollectionReference user = firestore.collection('users');
    user.doc(_currentUser!.email).update({
      "name": name,
      "keyName": name.substring(0, 1).toUpperCase(),
      "status": status,
      "lastSIgnInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updateTime": DateTime.now().toIso8601String()
    });

    dataUser.update((user) {
      user!.name = name;
      user.status = status;
      user.keyName = name.substring(0, 1).toUpperCase();
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = DateTime.now().toIso8601String();
    });

    dataUser.refresh();

    Get.defaultDialog(
        title: "Success", middleText: "Change Profile Successfully");
  }

  void updateStatus(String status) {
    CollectionReference user = firestore.collection('users');
    user.doc(_currentUser!.email).update({
      "status": status,
      "lastSIgnInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updateTime": DateTime.now().toIso8601String()
    });

    dataUser.update((user) {
      user!.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = DateTime.now().toIso8601String();
    });

    dataUser.refresh();

    Get.defaultDialog(
        title: "Success", middleText: "Update status Successfully");
  }

  void addNewConnection(String emailFriend) async {
    var chat_id;
    bool flagNewCollection = false;
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final docChat =
        await users.doc(_currentUser!.email).collection("chats").get();

    if (docChat.docs.length != 0) {
      final checkConnection = await users
          .doc(_currentUser!.email)
          .collection("chats")
          .where("connection", isEqualTo: emailFriend)
          .get();

      if (checkConnection.docs.length != 0) {
        flagNewCollection = false;
        chat_id = checkConnection.docs[0].id;
      } else {
        flagNewCollection = true;
      }
    } else {
      flagNewCollection = true;
    }

    if (flagNewCollection) {
      // Check Collection
      final chatsDocs = await chats.where("connection", whereIn: [
        [_currentUser!.email, emailFriend],
        [emailFriend, _currentUser!.email]
      ]).get();

      if (chatsDocs.docs.length != 0) {
        final chatDataId = chatsDocs.docs[0].id;
        final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(chatDataId)
            .set({
          "connection": emailFriend,
          "lastTime": chatsData["lastTime"],
          "total_unread": 0
        });

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatUser> dataListChats = List<ChatUser>.empty();
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat["connection"],
                lastTime: dataDocChat["lastTime"],
                total_unread: dataDocChat["total_unread"]));
          });
          dataUser.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          dataUser.update((user) {
            user!.chats = [];
          });
        }
        chat_id = chatDataId;

        dataUser.refresh();
      } else {
        final newChatDoc = await chats.add({
          "connection": [_currentUser!.email, emailFriend]
        });

        await chats.doc(newChatDoc.id).collection("chat");

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(newChatDoc.id)
            .set({
          "connection": emailFriend,
          "lastTime": DateTime.now().toIso8601String(),
          "total_unread": 0
        });

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatUser> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat["connection"],
                lastTime: dataDocChat["lastTime"],
                total_unread: dataDocChat["total_unread"]));
          });
          dataUser.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          dataUser.update((user) {
            user!.chats = [];
          });
        }

        chat_id = newChatDoc.id;

        dataUser.refresh();
      }
    }

    final updateStatusRead = await chats
        .doc(chat_id)
        .collection("chat")
        .where("isRead", isEqualTo: false)
        .where("penerima", isEqualTo: _currentUser!.email)
        .get();

    updateStatusRead.docs.forEach((element) async {
      await chats
          .doc(chat_id)
          .collection("chat")
          .doc(element.id)
          .update({"isRead": true});
    });

    await users
        .doc(_currentUser!.email)
        .collection("chats")
        .doc(chat_id)
        .update({"total_unread": 0});

    Get.toNamed(Routes.CHAT_ROOM,
        arguments: {"chat_id": "$chat_id", "friend_email": emailFriend});
  }

  void updatePhotoUrl(String url) async {
    CollectionReference user = firestore.collection('users');
    await user.doc(_currentUser!.email).update(
        {"photoUrl": url, "updateTime": DateTime.now().toIso8601String()});

    dataUser.update((user) {
      user!.photoUrl = url;
      user.updatedTime = DateTime.now().toIso8601String();
    });

    dataUser.refresh();

    Get.defaultDialog(
        title: "Success", middleText: "Change photo profile Successfully");
  }
}
