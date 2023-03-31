import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/common.dart';
import '../data/password_gen_data.dart';

class PasswordGenerator extends StatefulWidget {
  final double deviceHeight, deviceWidth;
  final BuildContext ctx;

  const PasswordGenerator(this.deviceHeight, this.deviceWidth, this.ctx,
      {super.key});

  @override
  State<PasswordGenerator> createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  List<List> passData = [letters, symbols, numbers];

  String password = '';

  double passLength = 8;

  @override
  Widget build(BuildContext context) {
    void passGenerate() {
      password = '';

      while (passLength.toInt() > 0) {
        var randomizer = Random().nextInt(passData.length - 1);

        setState(() {
          if (passData[randomizer] == letters) {
            password += letters[Random().nextInt(letters.length - 1)];
            passLength -= 1;
          } else if (passData[randomizer] == symbols) {
            password += symbols[Random().nextInt(symbols.length - 1)];
            passLength -= 1;
          } else if (passData[randomizer] == numbers) {
            password += numbers[Random().nextInt(numbers.length - 1)];
            passLength -= 1;
          }
        });
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
          child: Container(
            height: widget.deviceHeight * 0.1,
            width: widget.deviceWidth * 0.9,
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    password,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: widget.deviceHeight * 0.035,
                        fontFamily: "assets/fonts/Sono-SemiBold.ttf",
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: widget.deviceWidth * 0.05),
                  child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: password)).then(
                          (value) { customScaffoldMessenger(
                              context, 'Password Copied');
                              Navigator.pop(context);});
                      
                      
                    },
                    child: Icon(
                      Icons.copy_sharp,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                )
              ],
            )),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              passGenerate();
            },
            child: const Text('Generate Password')),
        Padding(
          padding: EdgeInsets.symmetric(vertical: widget.deviceHeight * 0.02),
          child: Container(
            height: widget.deviceHeight * 0.13,
            width: widget.deviceWidth * 0.95,
            decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: widget.deviceHeight * 0.015),
                  child: Text(
                    'Password Length',
                    style: TextStyle(
                        fontSize: widget.deviceHeight * 0.03,
                        color: Colors.blueGrey),
                  ),
                ),
                Slider(
                  value: passLength / 20,
                  divisions: 10,
                  onChanged: (value) {
                    setState(() {
                      passLength = value * 20;
                    });
                  },
                  label: passLength.toInt().toString(),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
