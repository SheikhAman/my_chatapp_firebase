// UserModel class create kora hoyeche database er jonno
// UserModel class er object amra thokon create korbo  jokhon amra registration korbo

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? mobile;
  String? image;
  bool available;
  String? deviceToken; // notification pathanor somoy kaje dibe

  UserModel(
      {this.uid,
      this.name,
      this.email,
      this.mobile,
      this.image,
      this.available = true,
      this.deviceToken}); // named optional

// map e convert kora field niye
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'mobile': mobile,
      'image': image,
      'available': available,
      'deviceToken': deviceToken,
    };
  }

// object e covert kora map e key use kore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      mobile: map['mobile'],
      image: map['image'],
      available: map['available'],
      deviceToken: map['deviceToken'],
    );
  }
}
