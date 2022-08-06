import 'package:firebase_day36/pages/user_list_page.dart';

import '../auth/auth_service.dart';
import 'package:firebase_day36/pages/login_page.dart';
import 'package:firebase_day36/pages/user_profile.dart';
import 'package:flutter/material.dart';

class LauncherPage extends StatefulWidget {
  static final String routeName = '/launcher';
  const LauncherPage({Key? key}) : super(key: key);

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    // auth korar somoy Future.delayed method call korte hobe init state e nahole error dibe
    Future.delayed(Duration.zero, () {
      if (AuthService.user == null) {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, UserListPage.routeName);
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
