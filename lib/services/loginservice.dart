import 'package:canabs/models/loginusermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginService {
  LoginService() {
    Firebase.initializeApp();
  }
  LoginUserModel? _userModel;

  LoginUserModel? get loggedInUserModel => _userModel;

  Future<bool> signInWithGoogle() async {
    GoogleSignIn? googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleUser = (await googleSignIn.signIn())!;

    // ignore: unnecessary_null_comparison
    if (googleUser == null) {
      return false;
    }

    // obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // create a new credentail
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    ) as GoogleAuthCredential;

    //once signed in return the userCredential
    UserCredential userCreds =
        await FirebaseAuth.instance.signInWithCredential(credential);
    _userModel = LoginUserModel(
        displayName: userCreds.user!.displayName,
        photoURL: userCreds.user!.photoURL,
        email: userCreds.user!.email,
        userId: userCreds.user!.uid);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userCreds.user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
      } else {
        addUser(
          userCreds.user!.uid,
          userCreds.user!.displayName,
          userCreds.user!.email,
          userCreds.user!.uid,
          userCreds.user!.photoURL,
        );
      }
    });

    return true;
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    _userModel = null;
  }

  bool isUserLoggedIn() {
    return _userModel != null;
  }

  Future<void> addUser(
    String? uesrid,
    name,
    email,
    uid,
    photourl,
  ) {
// Call the user's CollectionReference to add a new user
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users.doc(uesrid).set({
      'UserName': name,
      'Email': email,
      'PhotoUrl': photourl,
      'Id': uid,
      'freinds': [],
      'requests': [],
      'requests_sent': [],
      'requests_Recived': [],
      'UserLocation_lat': null,
      'UserLocation_long': null,
    });
  }
}
