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

        isAuth.value = true;
        return true;
      } else {
        return false;
      }
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
            "updatedTime": DateTime.now().toIso8601String(),
            "chats": []
          });
        } else {
          await user.doc(_currentUser!.email).update({
            "lastSignInTime":
                userCredential!.user!.metadata.lastSignInTime!.toIso8601String()
          });
        }

        final currentUser = await user.doc(_currentUser!.email).get();
        final curUserData = currentUser.data() as Map<String, dynamic>;

        dataUser(UsersModel.fromJson(curUserData));

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

    final docUser = await users.doc(_currentUser!.email).get();
    final docChat = (docUser.data() as Map<String, dynamic>)["chats"] as List;

    if (docChat.length != 0) {
      docChat.forEach((singleChat) {
        if (singleChat["connection"] == emailFriend) {
          chat_id = singleChat["chat_id"];
        }
      });

      if (chat_id != null) {
        flagNewCollection = false;
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

        docChat.add({
          "connection": emailFriend,
          "chat_id": chatDataId,
          "lastTime": chatsData["lastTime"]
        });

        await users.doc(_currentUser!.email).update({"chats": docChat});
        dataUser.update((user) {
          user!.chats = docChat as List<ChatUser>;
        });

        dataUser.refresh();

        chat_id = chatDataId;
      } else {
        final newChatDoc = await chats.add({
          "connection": [_currentUser!.email, emailFriend],
          "total_chats": 0,
          "total_read": 0,
          "total_unread": 0,
          "chat": [],
          "lastTime": DateTime.now().toIso8601String()
        });

        docChat.add({
          "connection": emailFriend,
          "chat_id": newChatDoc.id,
          "lastTime": DateTime.now().toIso8601String()
        });

        await users.doc(_currentUser!.email).update({"chats": docChat});

        dataUser.update((user) {
          user!.chats = docChat as List<ChatUser>;
        });

        dataUser.refresh();

        chat_id = newChatDoc.id;
      }
    }

    Get.toNamed(Routes.CHAT_ROOM, arguments: chat_id);
  }
}
