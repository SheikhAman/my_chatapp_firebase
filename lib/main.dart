import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_day36/auth/auth_service.dart';
import 'package:firebase_day36/pages/chat_room.dart';
import 'package:firebase_day36/pages/launcher_page.dart';
import 'package:firebase_day36/pages/login_page.dart';
import 'package:firebase_day36/pages/user_list_page.dart';
import 'package:firebase_day36/pages/user_profile.dart';
import 'package:firebase_day36/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/chat_room_provider..dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // widget build er age kono kichu initialize korle ai method call korbo
  await Firebase.initializeApp(); // firebase initialize korlam
  runApp(MultiProvider(
    providers: [
      // user er account er jonno userprovider
      ChangeNotifierProvider(
        create: (_) => UserProvider(),
      ),
      // chat related kaj er jonno chatroom provider
      ChangeNotifierProvider(
        create: (_) => ChatRoomProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    // aikhane this hoche myappstate
    WidgetsBinding.instance.addObserver(this); // observer add korlam
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (AuthService.user != null) {
      Provider.of<UserProvider>(context, listen: false)
          .updateProfile(AuthService.user!.uid, {'available': true});
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // observer remove korlam
    WidgetsBinding.instance.removeObserver(this);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (AuthService.user != null) {
        Provider.of<UserProvider>(context, listen: false)
            .updateProfile(AuthService.user!.uid, {'available': false});
      }
    } else if (state == AppLifecycleState.resumed) {
      if (AuthService.user != null) {
        Provider.of<UserProvider>(context, listen: false)
            .updateProfile(AuthService.user!.uid, {'available': true});
      }
    }

    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginPage.routeName,
      routes: {
        LauncherPage.routeName: (context) => const LauncherPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        UserProfile.routeName: (context) => const UserProfile(),
        ChatRoom.routeName: (context) => const ChatRoom(),
        UserListPage.routeName: (context) => const UserListPage(),
      },
    );
  }
}
