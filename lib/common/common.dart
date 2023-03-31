import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_passwords_manager/model/account.dart';
import 'package:new_passwords_manager/provider.dart';


//Firbase
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firebaseStore= FirebaseFirestore.instance;

//scaffold messenger
void customScaffoldMessenger(BuildContext context,String text){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.fixed,
    duration: const Duration(milliseconds: 800),
          content: Text(
       text,
        style: const TextStyle(color: Colors.white),
      )));
  
  
}
List<Account> filterAccountList(List<Account>accounts,WidgetRef ref){
  List<Account> filteredList = [];
  String searchedText = ref.watch(searchProvider);
  if(searchedText.isEmpty){
    ref.invalidate(searchProvider);
    return accounts;
  }

  for(Account item in accounts){
    if(item.accountCompany.toLowerCase().contains(searchedText.toLowerCase())){
      filteredList.add(item);
    }
    else  if(item.email.toLowerCase().contains(searchedText.toLowerCase())){
      filteredList.add(item);
    }

   
  }

return filteredList;
  
  

}


//Is Selected Function
  // void longPressed(String createdAt, WidgetRef ref,index) {
  //   bool isHold = ref.watch(cloudItemsProvider).value![index].isHold;
  //   List <Account> accounts = ref.read(cloudItemsProvider).value!;
    
  //     for(int i = 0 ; i<= accounts.length-1 ; i++){
  //       firebaseStore
  //         .collection('users')
  //         .doc(ref.read(uidProvider))
  //         .collection('accounts')
  //         .doc(accounts[i].createdAt)
  //         .update({"isHold": false});
        
  //     }
          
    

  //   if (isHold) {
  //     firebaseStore
  //         .collection('users')
  //         .doc(ref.read(uidProvider))
  //         .collection('accounts')
  //         .doc(createdAt)
  //         .update({"isHold": false});
  //   } else {
  //     firebaseStore
  //         .collection('users')
  //         .doc(ref.read(uidProvider))
  //         .collection('accounts')
  //         .doc(createdAt)
  //         .update({"isHold": true});
  //   }
  // }






