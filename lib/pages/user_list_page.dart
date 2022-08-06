import 'package:firebase_day36/auth/auth_service.dart';
import 'package:firebase_day36/providers/user_provider.dart';
import 'package:firebase_day36/widgets/main_drawer.dart';
import 'package:firebase_day36/widgets/use_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  static const String routeName = '/user_list';
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  bool isFirst = true;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      Provider.of<UserProvider>(context, listen: false)
          .getAllRemainingUsers(AuthService.user!.uid);
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) => ListView.builder(
            itemCount: provider.remainingUserList.length,
            itemBuilder: (context, index) {
              final user = provider.remainingUserList[index];
              return UserItem(userModel: user);
            }),
      ),
    );
  }
}
