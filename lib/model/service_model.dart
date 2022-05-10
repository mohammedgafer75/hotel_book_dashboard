import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  String? id;
  String? name;
  int? price;


  Service({
    this.id,
    required this.name,
    required this.price,

  });

  Service.fromMap(DocumentSnapshot data) {
    id = data.id;
    name = data["name"];
    price = data["price"];


  }
}