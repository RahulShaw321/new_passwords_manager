
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_passwords_manager/provider.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final Icon icon;
  final TextEditingController controller;

  const CustomTextField(
      {required this.label,
      required this.icon,
      required this.controller,
      super.key});
   

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      if(controller.text.isEmpty){
        ref.invalidate(searchProvider);
      }
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          child: TextFormField(
            controller: controller,           
            onTapOutside:(event) {

            
            },
            obscureText: label == "Password",
            decoration: InputDecoration(
                prefixIcon: icon,
                prefixIconColor: Colors.greenAccent,
                label: Text(label),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ));
    });
  }
}
