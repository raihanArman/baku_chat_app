import 'package:baku_chat_app/app/data/models/user_model.dart';
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

  UserModel dataUser = UserModel();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> firstInitialized() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });

    await skipIntro().then((value) {
      if (value) {
        isSkipIntro.value = true;
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

        user.doc(_currentUser!.email).update({
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String()
        });

        final currentUser = await user.doc(_currentUser!.email).get();
        final curUserData = currentUser.data() as Map<String, dynamic>;

        dataUser = UserModel(
            name: curUserData["name"],
            email: curUserData["email"],
            photoUrl: curUserData["photoUrl"],
            status: curUserData["status"],
            creationTime: curUserData["creationTime"],
            lastSignInTime: curUserData["lastSignInTime"],
            updatedTime: curUserData["updatedTime"]);
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
          user.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "email": _currentUser!.email,
            "photoUrl": _currentUser!.photoUrl ?? "noimage",
            "status": "",
            "creationTime":
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
          });
        } else {
          user.doc(_currentUser!.email).update({
            "lastSignInTime":
                userCredential!.user!.metadata.lastSignInTime!.toIso8601String()
          });
        }

        final currentUser = await user.doc(_currentUser!.email).get();
        final curUserData = currentUser.data() as Map<String, dynamic>;

        dataUser = UserModel(
            name: curUserData["name"],
            email: curUserData["email"],
            photoUrl: curUserData["photoUrl"],
            status: curUserData["status"],
            creationTime: curUserData["creationTime"],
            lastSignInTime: curUserData["lastSignInTime"],
            updatedTime: curUserData["updatedTime"]);

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
}
