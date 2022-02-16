import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'models.dart';
import 'recommandation/reco.dart';

DatabaseReference databaseRef = FirebaseDatabase.instance.reference();

CollectionReference service = FirebaseFirestore.instance.collection('Service');
CollectionReference company = FirebaseFirestore.instance.collection('Company');
CollectionReference typeserv = FirebaseFirestore.instance.collection('Type');
FirebaseApp ?instance;

Future<void> intializeDatabase() async {
  if (instance == null) {
    WidgetsFlutterBinding.ensureInitialized();
    instance = await Firebase.initializeApp();
  }
}



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

Stream<QuerySnapshot<Map<String, dynamic>>> getCompTypeService(
    String nomComp, String id) async* {
  print("id : '$id'");
  yield* company.doc(id).collection('Type_service').snapshots();
}

List<TypeService> toTypeServiceList(
    QuerySnapshot<Map<String, dynamic>> element) {
  return element.docs.map((e) {
    print(e.get('nom'));
    return TypeService(nom: e.get('nom'), id: e.id.toString());
  }).toList();
}

/*------------------------------------*/
Stream<List<Service>> getCompService(TypeService type) async* {
  yield* company
      .doc(type.idComp)
      .collection('Type_service')
      .doc(type.id)
      .collection("Service")
      .snapshots()
      .map((event) {
    return event.docs.map((e) {
      print(e.data());
      return Service(
          nom: e.data()['nom'] ?? "Unknown",
          idComp: type.idComp,
          idType: type.id,
          id: e.id.toString(),
          prix: e.data()['prix'] ?? "Unknown",
          code: e.data()['code'] ?? "Unknown",
          duree: e.data()['date'] ?? "Unknown");
    }).toList();
  });
}

/*---------------------------------------------------*/
Future<List<Service>> getrecomandedServices(String nomsim) async {
  List<String> ls = await sortedListService(nomsim);
  
  
  List<Service> result = [];


   QuerySnapshot data =  await FirebaseFirestore.instance
      .collectionGroup('Service').get();

      for(QueryDocumentSnapshot d in data.docs){
        if( ls.contains(d.id) ){
            Map service = d.data() as Map;
            print(service);
          result.add(
            Service(
            nom: service['nom'] ?? "Unknown",
            //idComp: ls.first.idComp,
            id: d.id.toString(),
            prix:service['prix'] ?? "Unknown",
            code:service['code'] ?? "Unknown",
            duree:service['date'] ?? "Unknown")
          );
     
        }
      }
      List<Service> Sorted = [];
      for(String id in ls){

        for(Service ss in result){
          if(ss.id == id) Sorted.add(ss);
        }
      }

  return Sorted;
}
