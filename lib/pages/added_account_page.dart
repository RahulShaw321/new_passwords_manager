import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/fireabase_services.dart';
import '../pages/edit_account_page.dart';
import '../model/account.dart';
import '../widgets/added_item_text_viewer.dart';

class AddedAccountPage extends StatelessWidget {
  static const String routeName = './added-acc';

  const AddedAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceHeight = mediaQuery.size.height -
        mediaQuery.padding.bottom -
        AppBar().preferredSize.height;
    final deviceWidth = mediaQuery.size.width;
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final Account account = routeArgs['account'];

    alerDialog() {
      var dialog = Consumer(builder: (context, ref, _) {
        return AlertDialog(
          title: const Text('Do you to delete?'),
          actions: [
            TextButton(
                onPressed: () {
                  FireBaseServices().deletAccount(ref, account.createdAt);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Yes')),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No')),
          ],
        );
      });

      return showDialog(
        context: context,
        builder: (context) => dialog,
      );
    }

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text("${account.accountCompany} Account"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
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
        leadingWidth: deviceWidth * 0.23,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth * 0.025),
            child: CircleAvatar(
              radius: deviceWidth * 0.058,
              backgroundColor: Colors.greenAccent.withOpacity(0.4),
              child: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                splashRadius: deviceWidth * 0.055,
                position: PopupMenuPosition.under,
                itemBuilder: (_) => [
                  PopupMenuItem(
                      value: "edit",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.edit),
                          Text("Edit"),
                        ],
                      )),
                  PopupMenuItem(
                    value: "delete",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        Text("Delete"),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    alerDialog();
                  } else if (value == 'edit') {
                    Navigator.pushNamed(context, EditAccountPage.routeName,
                        arguments: {
                          'account': account,
                          'height': deviceHeight,
                          'width': deviceWidth,
                        });
                  }
                },
              ),
            ),
          )
        ],
      ),
      body: SizedBox(
        height: deviceHeight * .98,
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
                      account.logo,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    account.accountCompany,
                    style: TextStyle(
                        fontSize: deviceHeight * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.06,
                ),
                UserDataViewer(
                    deviceHeight, deviceWidth, "Email/UserID", account.email),
                SizedBox(
                  height: deviceHeight * 0.06,
                ),
                UserDataViewer(
                    deviceHeight, deviceWidth, "Password", account.password),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
