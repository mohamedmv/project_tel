import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

CollectionReference service = FirebaseFirestore.instance.collection('Service');
CollectionReference company = FirebaseFirestore.instance.collection('Company');
CollectionReference typeserv = FirebaseFirestore.instance.collection('Type');
FirebaseApp ?instance;





Future<String> getIdComp(String nomComp) async {
 nomComp = nomComp;
  dynamic d = '';
  try {
    dynamic value = await company.where("nom", isEqualTo: nomComp).get();
    d = value.docs.first.id;
    print("laal $d");
  } catch (e) {
    print(e);
  }
  return d.toString();
}