import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_day36/models/message_model.dart';

import '../models/user_model.dart';

class DBHelper {
  static const String collectionUser =
      'User'; // collection er name const declare korlam karon collection pele document er data peye jabo

  static const String collectionRoomMessage = 'ChatRoomMessages';

// object create korlam database er
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addUser(UserModel userModel) {
    final doc = _db
        .collection(collectionUser)
        .doc(userModel.uid); // document pelam bolte row pelam
    return doc.set(
        userModel.toMap()); // document open kore key value akare set korechi
  }

  static Future<void> addMsg(MessageModel messageModel) {
    // doc e kono value na dile se auto generated id create kore column ba map er jonno
    return _db
        .collection(collectionRoomMessage)
        .doc()
        .set(messageModel.toMap());

    // doc e map set korlam ba pathalam
  }

// user er unique id ba row pelam
  static Stream<
      DocumentSnapshot<
          Map<String, dynamic>>> getUserByUid(String uid) => _db
      .collection(collectionUser)
      .doc(uid)
      .snapshots(); // function e notun kono kichu change hole se notun snapshot return korbe

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserByUidFuture(
          String uid) =>
      _db.collection(collectionUser).doc(uid).get();

// collection er under e sob gulo document ba message tule niye asbo
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllChatRoomMessages() =>
      _db
          .collection(collectionRoomMessage)
          .orderBy('msgId', descending: true)
          .snapshots();

// nijer uid bade sob user er id niya asbe userlist e
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllRemainingUsers(
          String uid) =>
      _db
          .collection(collectionUser)
          .where('uid',
              isNotEqualTo: uid) // where method e field match kore bad dichi
          .snapshots();

// gono method banalam user r sokol info update korar jonno
// sokol info update korte uid r map lage, uid hoche row r map hoche column
  static Future<void> updateProfile(String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUser).doc(uid).update(map);
  }
}
