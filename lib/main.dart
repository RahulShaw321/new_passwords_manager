import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:new_passwords_manager/pages/edit_account_page.dart';
import 'package:new_passwords_manager/pages/forgot_pass_page.dart';

import '../pages/acc_templates_page.dart';
import 'pages/add_acc_page.dart';
import '../pages/added_account_page.dart';
import '../pages/home.dart';
import '../pages/sign_up_page.dart';
import '../pages/login_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      initialRoute: LoginPage.routeName,
    
      routes: {
        '/': (context) => const MyHomePage(),
        LoginPage.routeName: (context) =>  LoginPage(),
        SignUpPage.routeName: (context) =>  SignUpPage(),
        ForgotPasswordPage.routeName :(context) =>  ForgotPasswordPage(),
        AccountTemplatesPage.routeName: (context) => const AccountTemplatesPage(),
        AddNewAccount.routeName: (context) => const AddNewAccount(),
        AddedAccountPage.routeName:(context) => const AddedAccountPage(),
         EditAccountPage.routeName:(context) =>const  EditAccountPage()
         
      },
    );
  }
}
