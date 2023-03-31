import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String email;
  String password;
  String accountCompany;
  String logo;
  String createdAt ;

  

  Account(
      {required this.email,
      required this.password,
      required this.logo,
      required this.accountCompany,
       this.createdAt ='' ,
       });

  Map<String, dynamic> toJson() => {
        "createdAt":createdAt,
        "password": password,
        "email": email,
        'logo': logo,
        'company':accountCompany,
        
      };

  static Account fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Account(
        email: snapshot["email"],
        password: snapshot["password"],
        logo: snapshot["logo"],
        accountCompany: snapshot['company'],
        createdAt: snapshot['createdAt']
        );
  }
}
