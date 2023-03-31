import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemTile extends StatelessWidget {
  final String logo;
  final String title;
  final String subtitle;
  final double deviceHeight;
  final double deviceWidth;
  final VoidCallback deletePressed;
  final VoidCallback tilePressed;
  const ItemTile({
    super.key,
    required this.logo,
    required this.title,
    required this.subtitle,
    required this.deviceHeight,
    required this.deviceWidth,
    required this.tilePressed,
    required this.deletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tilePressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        child: Container(
          padding: EdgeInsets.all(deviceHeight * 0.012),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color:
                Colors.greenAccent.withOpacity(.4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: deviceWidth * .75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: deviceHeight * 0.08,
                      width: deviceWidth * 0.13,
                      padding: EdgeInsets.all(deviceWidth * 0.015),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Image.asset(logo, fit: BoxFit.contain),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: deviceWidth * 0.035),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: deviceHeight * 0.028),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: deviceHeight * 0.022,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: subtitle)).then(
                      (value) => ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Password Copied"),
                            duration: Duration(milliseconds: 500),
                          )));
                },
                child: Icon(
                  Icons.copy_sharp,
                  color: Colors.grey.withOpacity(0.5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
