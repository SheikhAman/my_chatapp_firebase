import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_day36/auth/auth_service.dart';
import 'package:firebase_day36/models/user_model.dart';
import 'package:firebase_day36/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class UserProfile extends StatefulWidget {
  static const String routeName = '/user_profile';
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final txtController = TextEditingController();

  @override
  void dispose() {
    txtController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Center(
        child: Consumer<UserProvider>(
          builder: (context, provider, _) => StreamBuilder<
                  DocumentSnapshot<Map<String, dynamic>>>(
              stream: provider.getUserByUid(AuthService.user!
                  .uid), // stream tai snapshot e jache, ar sei data  amra use korchi
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // snapshot e documentSnapshot akare map ache tai seta data method diye map e convert kore formMap kore userModel er object akare nilam
                  final userModel = UserModel.fromMap(snapshot.data!
                      .data()!); // jar info show korbo tar model peye gechi

                  return ListView(
                    children: [
                      Center(
                          child: userModel.image == null
                              ? Image.asset(
                                  'images/person.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  userModel.image!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )),
                      TextButton.icon(
                        onPressed: _updateImage,
                        icon: Icon(Icons.camera),
                        label: Text('Change Image'),
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                      ListTile(
                        title: Text(userModel.name ??
                            'No Display name'), // null hole No Display name show korbe
                        trailing: IconButton(
                            onPressed: () {
                              showInputDialog('Display Name', userModel.name,
                                  (value) async {
                                // ai line er madhome database e update kortasi
                                await provider.updateProfile(
                                    AuthService.user!.uid, {'name': value});

                                // ai line er madhome Authservice user er account e update kortasi
                                await AuthService.updateDisplayName(value);
                              });
                            },
                            icon: Icon(Icons.edit)),
                      ),
                      ListTile(
                        title: Text(userModel.mobile ??
                            'No Mobile number'), // null hole No Display name show korbe
                        trailing: IconButton(
                            onPressed: () {
                              showInputDialog(
                                  'Display Number', userModel.mobile,
                                  (onSaved) {
                                provider.updateProfile(
                                    AuthService.user!.uid, {'mobile': onSaved});
                              });
                            },
                            icon: Icon(Icons.edit)),
                      ),
                      ListTile(
                        title: Text(userModel.email ??
                            'No Email Address'), // null hole No Display name show korbe
                        trailing: IconButton(
                            onPressed: () {
                              showInputDialog('Display Email', userModel.email,
                                  (onSaved) {
                                provider.updateProfile(
                                    AuthService.user!.uid, {'email': onSaved});
                              });
                            },
                            icon: Icon(Icons.edit)),
                      ),
                    ],
                  );
                }
                if (snapshot.hasError) {
                  return const Text('Failed to fetch data');
                }
                return const CircularProgressIndicator(); // data aste late hole  aita show korbe
              }),
        ),
      ),
    );
  }

  void _updateImage() async {
    final xFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 75); // imageQuality  0-100 porjonoto very kore

    if (xFile != null) {
      try {
        // downloadUrl pelam
        final downloadUrl =
            await Provider.of<UserProvider>(context, listen: false)
                .updateImage(xFile);

// image ta database e pathachi
// image ta update korlam profile e
// package use kore progress bar ghurabo
        await Provider.of<UserProvider>(context, listen: false)
            .updateProfile(AuthService.user!.uid, {'image': downloadUrl});
        // firebase auth user e display name set kore dilamm
        await AuthService.updateDisplayImage(downloadUrl);
      } catch (e) {
        rethrow;
      }
    }
  }

// title hoche dialogue er title ki edit korbe se
  showInputDialog(String title, String? value, Function(String) onSaved) {
    txtController.text = value ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: txtController,
            decoration: InputDecoration(
              hintText: 'Enter $title',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              // call back function
              onSaved(txtController.text);
              Navigator.pop(context);
            },
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
  }
}
