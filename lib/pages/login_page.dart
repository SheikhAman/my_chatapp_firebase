import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_day36/auth/auth_service.dart';
import 'package:firebase_day36/models/user_model.dart';
import 'package:firebase_day36/pages/launcher_page.dart';
import 'package:firebase_day36/pages/user_profile.dart';
import 'package:firebase_day36/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true, isObscure = true;
  final formKey = GlobalKey<FormState>();
  String errMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              children: [
                Text('Welcome User'),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: isObscure,
                  controller: passwordController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility),
                    ),
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      isLogin = true;
                      authenticate();
                      Provider.of<UserProvider>(context, listen: false)
                          .updateProfile(
                              AuthService.user!.uid, {'available': true});
                    },
                    child: Text('Login')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New User?'),
                    TextButton(
                      onPressed: () {
                        isLogin = false;
                        authenticate();
                      },
                      child: Text('Register Here'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Forgot Password?'),
                    TextButton(
                      onPressed: () {},
                      child: Text('Click Here'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  errMsg,
                  style: TextStyle(color: Theme.of(context).errorColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  authenticate() async {
    if (formKey.currentState!.validate()) {
      bool status;
      try {
        if (isLogin) {
          status = await AuthService.login(
              emailController.text, passwordController.text);
        } else {
          status = await AuthService.register(
              emailController.text, passwordController.text);
          await AuthService
              .sendVerificationMail(); // verification korar jonno email e msg send  korbe
          final userModel = UserModel(
            uid: AuthService.user!.uid, // userid pelam current user theke
            email: AuthService
                .user!.email, // current user  email pelam authservice theke
          );
          if (mounted) {
            await Provider.of<UserProvider>(context, listen: false)
                .addUser(userModel);
          } // same user er under e database add hobe
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        }
        if (status) {
          if (!mounted) return; // widget tree te na thakle return korbe
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errMsg = e.message!;
        });
      }
    }
  }
}
