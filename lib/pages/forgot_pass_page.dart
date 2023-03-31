// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/common.dart';
import '../common/unfocus.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordPage extends ConsumerWidget {
  static const String routeName = 'forgot-pass-page';
  final emailController = TextEditingController();
   ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    
    final deviceHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;

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
                    child: const Text("Forgot Password",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold))),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 35),
                    child: const Text("Reset Your Password Here",
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
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async{
                    FocusManager.instance.primaryFocus?.unfocus();
                    
                      try {
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        if (emailController.text.isNotEmpty) {
                          await firebaseAuth.sendPasswordResetEmail(
                              email: emailController.text);
                          customScaffoldMessenger(
                              context, "Password Reset Email has been Sent");
                        } 
                        else{

                        }

                        Navigator.pop(context);
                      } catch (e) {
                        Navigator.pop(context);
                        customScaffoldMessenger(
                            context, e.toString());
                      };
                   
                  },
                  child: const Text(
                    "Send Password Reset Link",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                GestureDetector(
                    onTap:() => Navigator.pop(context) ,
                    child: Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: const Text(
                        "Already have An Account",
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
