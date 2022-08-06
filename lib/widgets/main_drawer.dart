import 'package:firebase_day36/auth/auth_service.dart';
import 'package:firebase_day36/pages/chat_room.dart';
import 'package:firebase_day36/pages/launcher_page.dart';
import 'package:firebase_day36/pages/login_page.dart';
import 'package:firebase_day36/pages/user_list_page.dart';
import 'package:firebase_day36/pages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.blue,
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, UserProfile.routeName);
            },
            leading: Icon(Icons.person),
            title: const Text('My Profile'),
          ),
          ListTile(
              // tap korle chatroom page e chole jabo
              onTap: () {
                Navigator.pushReplacementNamed(context, UserListPage.routeName);
              },
              leading: Icon(Icons.group),
              title: Text('User List')),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, ChatRoom.routeName);
            },
            leading: Icon(Icons.chat),
            title: const Text('Chat Room'),
          ),
          ListTile(
            onTap: () async {
              await Provider.of<UserProvider>(context, listen: false)
                  .updateProfile(AuthService.user!.uid, {'available': false});
              AuthService.logout().then((value) =>
                  Navigator.pushReplacementNamed(
                      context, LauncherPage.routeName));
            },
            leading: Icon(Icons.logout),
            title: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }
}
