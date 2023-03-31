// ignore_for_file: use_build_context_synchronously, sized_box_for_whitespace

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_passwords_manager/common/unfocus.dart';
import 'package:new_passwords_manager/pages/forgot_pass_page.dart';

import '../common/common.dart';
import '../pages/home.dart';
import '../pages/sign_up_page.dart';
import '../provider.dart';
import '../widgets/custom_text_field.dart';
import '../model/auth_user.dart ' as model;

class LoginPage extends ConsumerWidget {
  static const String routeName = './login-page';
  final emailController = TextEditingController();
    final passwordController = TextEditingController();

   LoginPage({super.key});

  void _userLogin(String email, String password, BuildContext context,
      WidgetRef ref) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
        UserCredential userCred = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        String uid = userCred.user!.uid;

        Navigator.popAndPushNamed(context, MyHomePage.routeName);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Logged In Successfully",
          style: TextStyle(color: Colors.white),
        )));
        firebaseStore.collection('users').doc(uid).snapshots().listen((snap) {
          model.User user = model.User.fromSnap(snap);
          ref.read(profileNameProvider.notifier).update((state) => user.name);
          ref.read(uidProvider.notifier).update((state) => user.uid);
          ref.read(imageAvatarProvider.notifier).update((state) => user.image);
        });

        // ignore: avoid_print
        print("Logged in");
      } else {
        Navigator.pop(context);
        customScaffoldMessenger(context, 'Please enter all the fields');
      }
    } catch (e) {
      Navigator.pop(context);
      customScaffoldMessenger(
          context, e.toString().replaceRange(0, 30, '').trimLeft());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
     final deviceHeight = MediaQuery.of(context).size.height-MediaQuery.of(context).padding.bottom;

    return Unfocus(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: deviceHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 35),
                    child: const Text("Login",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold))),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 35),
                    child: const Text("Please Sign in to continue",
                        style: TextStyle(fontSize: 18, color: Colors.black45))),
                const SizedBox(
                  height: 50,
                ),
                CustomTextField(
                  label: "Email",
                  icon: const Icon(Icons.email),
                  controller: emailController,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: "Password",
                  icon: const Icon(Icons.lock),
                  controller: passwordController,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();

                    _userLogin(emailController.text, passwordController.text,
                        context, ref);
                  },
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                GestureDetector(
                    onTap: ()  {
                      Navigator.pushNamed(context, ForgotPasswordPage.routeName);
                     
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignUpPage.routeName);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: const Text(
                        "Create An Account",
                        style: TextStyle(fontSize: 18),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
