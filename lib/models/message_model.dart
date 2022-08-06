import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  int? msgId; // message koraar jonno unique id ta
  String? userUid; // current user id
  String? userName; // current user name
  String? userImage;
  String email;
  String msg;
  Timestamp timestamp; // ai time sorasori document theke newa jabe
  String? image; // image post korar jonno

  MessageModel(
      {this.msgId,
      this.userUid,
      this.userName,
      this.userImage,
      required this.email,
      required this.msg,
      required this.timestamp,
      this.image});

// toMap returns map database e save hoi
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msgId': msgId,
      'userUid': userUid,
      'userName': userName,
      'userImage': userImage,
      'email': email,
      'msg': msg,
      'timestamp': timestamp,
      'image': image,
    };
  }

// database theke object akare ber kora hoi
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      msgId: map['msgId'],
      userUid: map['userUid'],
      userName: map['userName'],
      userImage: map['userImage'],
      email: map['email'],
      msg: map['msg'],
      timestamp: map['timestamp'],
      image: map['image'],
    );
  }
}
