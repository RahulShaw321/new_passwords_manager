import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_passwords_manager/provider.dart';

class CustomSearchBar extends StatelessWidget {
  final String label;
  final Icon icon;
  final TextEditingController controller ;
  

   const CustomSearchBar(
      {required this.label,
      required this.icon,
      required this.controller,
      super.key});

  @override
  Widget build(BuildContext context) {
    

    return Consumer(builder: (context, ref, _) {


      return 
          Container(
              padding: const EdgeInsets.only(left: 20,bottom: 10,right: 8),
              child: TextField(
                controller: controller,
                onSubmitted:(value) =>  ref.read(searchProvider.notifier).update((state) => value),
                decoration: InputDecoration(
                    prefixIcon: icon,
                    prefixIconColor: Colors.greenAccent,
                    label: Text(label),
                    border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(40))),
              ));
        
    });
  }
}
