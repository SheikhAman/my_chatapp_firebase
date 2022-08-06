import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_day36/auth/auth_service.dart';
import 'package:firebase_day36/db/dbhelper.dart';
import 'package:firebase_day36/pages/chat_room.dart';
import 'package:flutter/material.dart';

import '../models/message_model.dart';

class ChatRoomProvider extends ChangeNotifier {
  // message  gulo sob database theke niye ase aikhane rakhbo
  List<MessageModel> msgList = [];

  // message add korlam database e
  Future<void> addMsg(String msg) {
    final messageModel = MessageModel(
        msgId: DateTime.now().millisecondsSinceEpoch,
        userUid: AuthService.user!.uid,
        userName: AuthService.user!.displayName,
        email: AuthService.user!.email!,
        userImage: AuthService.user!.photoURL,
        msg: msg,
        timestamp: Timestamp.fromDate(DateTime.now()));

    return DBHelper.addMsg(messageModel);
  }

// addMsg korle ai list run hobe r snapshot return kore notify korbe
  getAllChatRoomMessages() {
    // snapshot hoche  onnekgulo document er snapshot
    // loop chaliye porthome snapshot ke from map kore maodel e convert kore
    // tarpor msgList e add korte hobe
    DBHelper.getAllChatRoomMessages().listen((snapshot) {
      // snapshot hoche list of document

      // snapshot er vitore data namer method map return kore
      msgList = List.generate(snapshot.docs.length,
          (index) => MessageModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });

    // notun kew subscribe korle listen korbe
  }
}
