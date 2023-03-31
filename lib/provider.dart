import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/common.dart';
import 'model/account.dart';

final profileNameProvider = StateProvider<String>((ref) => '');
final uidProvider = StateProvider<String>((ref) => '');
final emailProvider = StateProvider<String>((ref) => '');
final searchProvider = StateProvider<String>((ref) => '');
final imageAvatarProvider = StateProvider<String>((ref) => '');

final edittingProvider = StateProvider<Account>((ref)=>Account(email: '', password: '', logo: '', accountCompany: ''));




final cloudItemsProvider = StreamProvider((ref) {
  var cloudAccounts = firebaseStore
      .collection('users')
      .doc(ref.watch(uidProvider))
      .collection('accounts')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapShot) => snapShot.docs.map((DocumentSnapshot doc) {
            var acc = Account.fromSnap(doc);

            return acc;
          }).toList());

  return cloudAccounts;
});
