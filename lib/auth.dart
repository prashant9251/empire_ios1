import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class firebaseAuthfunction {
  static Future<void> createUserInFirebase(dynamic UserObj) async {
    await fireBCollection
        .collection("supuser")
        .doc(UserObj["CLIENTNO"])
        .collection("user")
        .doc("${UserObj["user"]}")
        .set({"userID": "${UserObj["user"]}"}).then((value) async {});
  }

  static Future<void> SignInEmail(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password).then((value) {}).onError((error, stackTrace) {
      //print(stackTrace);
    }).catchError((onError) {
      //print(onError);
    });
  }

  Future<User> handleSignUp(email, password) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
    final User user = result.user!;
    return user;
  }
}
