import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String name;
  String email;
  String image;
  String uid;

  User({required this.name,required this.email,required this.uid,required this.image});

  Map<String,dynamic> toJson() => {
    "name" : name,
    "email" :email,
    'image':image,
    "uid" :uid,


    



  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;
  return User(name: snapshot['name'], email: snapshot["email"], uid: snapshot["uid"], image: snapshot['image']);
  }



  
}