import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/common.dart';
import '../common/fireabase_services.dart';
import '../common/unfocus.dart';
import '../model/account.dart';
import '../provider.dart';
import '../widgets/password_generator.dart';

class EditAccountPage extends ConsumerStatefulWidget {
  static const String routeName = './edit-acc-page';
  const EditAccountPage({super.key});

  @override
  ConsumerState<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends ConsumerState<EditAccountPage> {
  late TextEditingController emailController;

  late TextEditingController passwordController;

  @override
  void initState() {
    Account acc = ref.read(edittingProvider);
    emailController = TextEditingController(text: acc.email);
    passwordController = TextEditingController(text: acc.password);
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

    final Account acc = routeArgs['account'];

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
        title: Text('${acc.accountCompany} Account'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
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
                      acc.logo,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    acc.accountCompany,
                    style: TextStyle(
                        fontSize: deviceHeight * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.06,
                ),
                Column(
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
                          label: const Text('password'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: deviceWidth * 0.01,
                                color: Colors.amber,
                              ))),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.05),
                  child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => PasswordGenerator(
                              deviceHeight, deviceWidth, context),
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
              Account edittedAcc = Account(
                  email: emailController.text,
                  password: passwordController.text,
                  logo: acc.logo,
                  accountCompany: acc.accountCompany,
                  createdAt: acc.createdAt);
              FireBaseServices().editAccount(ref, acc.createdAt, edittedAcc);
              Navigator.pop(context);
              Navigator.pop(context);
            } else {
              customScaffoldMessenger(
                  context, 'Please enteer all the fields !!');
            }
          },
        );
      }),
    );
  }
}
