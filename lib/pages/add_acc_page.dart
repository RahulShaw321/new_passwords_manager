import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:new_passwords_manager/common/unfocus.dart';
import 'package:new_passwords_manager/widgets/password_generator.dart';
import '../common/fireabase_services.dart';
import '../model/account.dart';

class AddNewAccount extends StatefulWidget {
  static const String routeName = './add-new-acc';

  const AddNewAccount({super.key});

  @override
  State<AddNewAccount> createState() => _AddNewAccountState();
}

class _AddNewAccountState extends State<AddNewAccount> {
  late final TextEditingController emailController;

  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;

    final Account accountTemplate = routeArgs['accountTemplate'];

    final double deviceHeight = routeArgs['height'];
    final double deviceWidth = routeArgs['width'];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(top: deviceWidth * 0.02),
          child: CircleAvatar(
            radius: deviceWidth * 0.05,
            backgroundColor: Colors.greenAccent.withOpacity(0.4),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              splashRadius: deviceWidth * 0.06,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        leadingWidth: deviceWidth * 0.2,
        title: Text('${accountTemplate.accountCompany} Account'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Unfocus(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: deviceWidth * 0.02,
                right: deviceWidth * 0.02,
                top: deviceHeight * 0.04),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.03),
                  child: Center(
                    child: Image.asset(
                      width: deviceWidth * 0.41,
                      accountTemplate.logo,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    accountTemplate.accountCompany,
                    style: TextStyle(
                        fontSize: deviceHeight * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.06,
                ),
                Consumer(builder: (context, ref, _) {
                  return Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            label: const Text('username/e-mail'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: deviceWidth * 0.01,
                                  color: Colors.amber,
                                ))),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.06,
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            label: const Text('Password'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: deviceWidth * 0.01,
                                  color: Colors.amber,
                                ))),
                      ),
                    ],
                  );
                }),
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.05),
                  child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(

                          context: context,
                          builder: (context) =>
                              PasswordGenerator(deviceHeight, deviceWidth,context),
                        );
                      },
                      child: const Text("Password Generator")),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Consumer(builder: (context, ref, _) {
        return FloatingActionButton(
          child: const Icon(Icons.save_sharp),
          onPressed: () {
            if (passwordController.text.isNotEmpty &&
                emailController.text.isNotEmpty) {
              Account newAcc = Account(
                email: emailController.text,
                password: passwordController.text,
                logo: accountTemplate.logo,
                accountCompany: accountTemplate.accountCompany,
                createdAt: Timestamp.now().seconds.toString()
              );

              FireBaseServices().addAccount(newAcc, ref);

              Navigator.pop(context);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(milliseconds: 500),
                  content: Text('Please enteer all the fields !!')));
            }
          },
        );
      }),
    );
  }
}
