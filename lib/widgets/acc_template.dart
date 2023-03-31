import 'package:flutter/material.dart';
import 'package:new_passwords_manager/pages/add_acc_page.dart';

import '../model/account.dart';

class AccTemplate extends StatelessWidget {
  final Account acc;
  final double height;
  final double width;

  const AccTemplate(this.acc, this.height, this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    void addNewAccount()  {
       Navigator.pushNamed(context, AddNewAccount.routeName, arguments: {
        'accountTemplate': acc,
        'height': height,
        "width": width,
      });
    }

    return GestureDetector(
      onTap: addNewAccount,
      child: Padding(
        padding: EdgeInsets.all(height * 0.015),
        child: Container(
          height: height * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.greenAccent.withOpacity(.4),
          ),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(height * 0.02),
              child: Image.asset(
                acc.logo,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              acc.accountCompany,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [BoxShadow(blurRadius: 3,spreadRadius: 3)]),
            )
          ]),
        ),
      ),
    );
  }
}
