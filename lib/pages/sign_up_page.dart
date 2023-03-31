// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_passwords_manager/common/fireabase_services.dart';
import 'package:new_passwords_manager/common/unfocus.dart';
import 'package:new_passwords_manager/provider.dart';

import '../widgets/custom_text_field.dart';
import '../common/common.dart';
import '../model/auth_user.dart ' as model;

class SignUpPage extends StatefulWidget {
  static const String routeName = "./sign-up";

  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController userNameController;

  late TextEditingController emailController;

  late TextEditingController passwordController;

  File? pickedImage;

  void _registerUser(String userName, String email, String password,
      File? image, BuildContext context) async {
    try {
      if (userName.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });

        UserCredential userCred =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String downloadUrl = await uploadToStorage(image);

        model.User user = model.User(
            name: userName,
            email: email,
            uid: userCred.user!.uid,
            image: downloadUrl);
        await firebaseStore
            .collection('users')
            .doc(userCred.user!.uid)
            .set(user.toJson());

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Your account has been Created',
          style: TextStyle(color: Colors.white),
        )));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Please enter all the fields',
          style: TextStyle(color: Colors.white),
        )));
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        e.toString().replaceRange(0, 30, ''),
        style: const TextStyle(color: Colors.white),
      )));
    }
  }

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;
    final deviceWidth =  MediaQuery.of(context).size.width ;
            

    return Unfocus(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: deviceHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 35),
                    child: const Text("Signup",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold))),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 35),
                    child: const Text("Create your account",
                        style: TextStyle(fontSize: 18, color: Colors.black45))),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    pickedImage == null
                        ? CircleAvatar(
                            radius: deviceHeight * 0.07,
                            child: const Icon(Icons.person))
                        :ClipRRect(
                          borderRadius: BorderRadius.circular(deviceWidth * 0.7),
                          child: Image.file(
                            pickedImage!,
                            
                            height: deviceHeight * 0.15,
                            width: deviceWidth * 0.31,
                            
                            fit: BoxFit.cover,
                          ),
                        ),
                    TextButton(
                        onPressed: () async {
                          final ImagePicker imagePicker = ImagePicker();
                          final XFile? image = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              pickedImage = File(image.path);
                            });
                          } else if(image == null){
                            setState(() {
                              pickedImage = null;
                            });
                          }
                        },
                        child: const Text('Choose Image'))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  label: "Full Name",
                  icon: const Icon(Icons.person),
                  controller: userNameController,
                ),
                const SizedBox(
                  height: 10,
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
                    _registerUser(userNameController.text, emailController.text,
                        passwordController.text, pickedImage, context);
                  },
                  child: const Text(
                    "SIGNUP",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: const Text(
                        "Already have an account",
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
