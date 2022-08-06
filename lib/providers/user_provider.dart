import 'dart:io';

import 'package:firebase_day36/db/dbhelper.dart';
import 'package:firebase_day36/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UserProvider extends ChangeNotifier {
  // UserModel er list toiri kore user er object rakhbo

  List<UserModel> remainingUserList = []; //  empty list

  Future<void> addUser(UserModel userModel) => DBHelper.addUser(userModel);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserByUid(String uid) =>
      DBHelper.getUserByUid(uid);

  // updateProfile korar jonno boro method
  Future<void> updateProfile(String uid, Map<String, dynamic> map) =>
      DBHelper.updateProfile(uid, map);

// user list page e user list gulo  niye asbe query kore
  getAllRemainingUsers(String uid) {
    DBHelper.getAllRemainingUsers(uid).listen((snapshot) {
      remainingUserList = List.generate(snapshot.docs.length,
          (index) => UserModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<String> updateImage(XFile xFile) async {
    // image name ki hobe ta string e conver kori
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();

    // FirebaseStorage.instance.ref() return  kore root reference
    // tarpor child reference nibo aikhane pictures folder er under e image name er akta file save hobe
    final photoRef =
        FirebaseStorage.instance.ref().child('pictures/$imageName');

    // file upload korar jonnoo putFile method bebohar korbo
    // seta File parameter nei tarvitore xFile.path diye dibo
    // putFile method return kore UploadTask

    final uploadTask = photoRef.putFile(File(xFile.path));

    // uploadTask  complete hoyeche check korar jonno method  call korlam
    // whenComplete return kor snapshot
    final snapshot = await uploadTask.whenComplete(() =>
        null); // complete  howar por kono kichu chaile show o korte partam

    // snapshot.ref photoRef ke reference korche
    return snapshot.ref.getDownloadURL();
  }
}
