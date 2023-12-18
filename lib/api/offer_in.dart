import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserRepository {
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('users');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // This function can be called after a user signs in to save their UID.
  Future<void> saveUserUid() async {
    User? currentUser = _firebaseAuth.currentUser;
    print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
    if (currentUser != null) {
      String uid = currentUser.uid;
      // Optionally, you can also get other user details like email, display name, etc.

      await _usersRef.child(uid).set({
        'uid': uid,
        // 'email': currentUser.email, // Uncomment if you want to save the email as well
        // Add other user details if necessary
      });
      print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk' + uid);
    } else {
      print('No user is signed in.');
    }
  }
}
