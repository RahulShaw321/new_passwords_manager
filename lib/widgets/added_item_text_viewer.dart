import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserDataViewer extends StatelessWidget {
  final double deviceHeight;
  final double deviceWidth;
  final String title;
  final String subtitle;
  const UserDataViewer(
      this.deviceHeight, this.deviceWidth, this.title, this.subtitle,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight * 0.11,
      width: deviceWidth * 0.9,
     
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: deviceWidth * 0.01, top: deviceWidth * 0.02,left: deviceWidth * 0.04,right: deviceWidth * 0.04),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.black45,
                          fontFamily: "fonts/Sono/Sono-Regular.ttf",
                          fontWeight: FontWeight.bold,
                          letterSpacing: deviceWidth * 0.01),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: deviceWidth * 0.01, top: deviceWidth * 0.02,left: deviceWidth * 0.04,right: deviceWidth * 0.04),
                    child: Text(
                    
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        
                        fontSize: deviceHeight * 0.03,
                        fontFamily: "fonts/Sono/Sono-Regular.ttf",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: deviceWidth * 0.05),
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: subtitle)).then((value) =>
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("$title Copied"),
                      duration: const Duration(milliseconds: 1000),
                    )));
              },
              child: Icon(
                Icons.copy_sharp,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
          )
        ],
      ),
    );
  }
}
