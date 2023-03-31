import 'package:flutter/material.dart';

import '../data/acc_templates.dart';
import '../model/account.dart';
import '../widgets/acc_template.dart';

class AccountTemplatesPage extends StatelessWidget {
  static const String routeName = './acc-template';
  const AccountTemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final double height = routeArgs['height'];
    final double width = routeArgs['width'];

    final List<Account> templates = accountTemplates;

  

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding:  EdgeInsets.only(top: width * 0.02),
          child: CircleAvatar(
            radius: width * 0.05,
            backgroundColor: Colors.greenAccent.withOpacity(0.4),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              splashRadius: width * 0.06,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        leadingWidth: width * 0.2,
        title: const Text("Account Templates"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding:  EdgeInsets.only(top:height * 0.03,left: width*0.02,right: width*0.02),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisExtent: height * 0.22),
          itemBuilder: (context, index) {
            return AccTemplate(templates[index], height, width);
          },
          itemCount: accountTemplates.length,
        ),
      ),
    );
  }
}
