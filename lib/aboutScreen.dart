import 'package:flutter/material.dart';
import 'package:card_numbers_form_camera/card_numbers_form_camera.dart';
import 'recommandation/reco.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
              onPressed: () async {
                String? s = await getCardNumbers(context);
                print(s);
              },
              child: Text("wright")),
          Center(
              child: Text(
            "Bienvenue",
            style: TextStyle(fontSize: 30),
          )),
        ],
      ),
    );
  }
}
