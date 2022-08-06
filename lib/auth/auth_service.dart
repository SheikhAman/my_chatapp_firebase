import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth
      .instance; // singelton object(pass verify, registration,login etc korar jonno
  static User? get user => _auth.currentUser;

  static Future<bool> login(String email, String password) async {
    //  signIn successfull holee user er info gulo pabo
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return credential.user != null;
    // user je ai matro signin korlo email password diye jodi seta not equal null hoi tahole return korbe true
  }

  static Future<bool> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credential.user != null;
  }

  static Future<void> logout() =>
      _auth.signOut(); // signout ba logout korar jonno

  static bool isEmailVerified() => _auth.currentUser!.emailVerified;

  static Future<void> sendVerificationMail() =>
      _auth.currentUser!.sendEmailVerification();

  // display name update korar jonno firebase e local vaabe

  static Future<void> updateDisplayName(String name) =>
      _auth.currentUser!.updateDisplayName(name);

  static Future<void> updateDisplayImage(String image) =>
      _auth.currentUser!.updatePhotoURL(image);

// phone number update korar age verify kora lagbe
  static Future<void> updatePhoneNumber(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
