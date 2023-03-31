
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/account.dart';
import '../provider.dart';
import 'common.dart';

class FireBaseServices {
  void addAccount(Account acc, WidgetRef ref) {
    var uid = ref.read(uidProvider);

    firebaseStore
        .collection('users')
        .doc(uid)
        .collection('accounts')
        .doc(acc.createdAt)
        .set(acc.toJson());
  }

  void deletAccount(WidgetRef ref, String createdAt) async {
    var uid = ref.read(uidProvider);
    await firebaseStore
        .collection('users')
        .doc(uid)
        .collection('accounts')
        .doc(createdAt)
        .delete();
  }

  void editAccount(WidgetRef ref, String createdAt, Account updatedAcc) {
    firebaseStore
        .collection('users')
        .doc(ref.read(uidProvider))
        .collection('accounts')
        .doc(createdAt)
        .update(updatedAcc.toJson());
  }
   
}


Future<String> uploadToStorage(File image) async{
  Reference ref = firebaseStorage.ref().child('profilepics').child(firebaseAuth.currentUser!.uid);

  UploadTask uploadTask = ref.putFile(image);
  TaskSnapshot snap = await uploadTask;
  String downloadUrl = await snap.ref.getDownloadURL();
 
  

  return downloadUrl;

   
  







  
}
