
import 'package:permission_handler/permission_handler.dart';

import '../database.dart';

import 'package:evry_sim_in_phone/evry_sim_in_phone.dart';


List<String> companies = ["mattel", "mauritel", "chinguitel"];
Future<Map<String, dynamic>> getSimInfo() async {
  List<List<String>> sims = [];
  await intializeDatabase();

 
    PermissionStatus state = await Permission.phone.status;
    if (!state.isGranted) {
      bool isGranted = await Permission.phone.request().isGranted;
      if (!isGranted) return {'sims': sims, 'per': true};
    }

    

    String nom = '';
    
    List<String> cards = await EvrySimInPhone.getAllSims();

    for (int i = 0; i < cards.length; i++) {
      nom = CleanName(cards[i].toLowerCase());

      String id = await getIdComp(
          nom == "T-Mobile" || nom == "Android" ? "mattel" : nom);
      print("-----------------------------");
      print(nom);
      print("id : $id");
      sims.add([nom, id]);
    }
    
    return {'sims': sims, 'per': true};
  

}

String CleanName(String name){
  
  List<String> l =name.split(' ');
  
  if(l.first.isNotEmpty) return l.first;
  else if(l.length >=2 && l[1].isNotEmpty) return l[1];
  return '';

}
