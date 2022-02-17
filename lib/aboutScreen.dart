import 'package:flutter/material.dart';
import 'package:card_numbers_form_camera/card_numbers_form_camera.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'recommandation/reco.dart';

class About extends StatefulWidget {
  final String nomSim;
  About({required this.nomSim});
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {

  late TextEditingController _number ;
  late TextEditingController _code ;
    late TextEditingController _credit ;
    final _formKey = GlobalKey<FormState>();
  

  @override
  void initState() {
    _number = TextEditingController(text: "",);
     _code = TextEditingController(text: "0000");
     _credit = TextEditingController(text: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 5),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(20)),
                 contentPadding: EdgeInsets.only(left: 25, top: 20,bottom: 20) ,
                  label: Text("Numero")
                  ),
                
                controller: _number,
                validator: (value){
                  
                  return valudateNumber(simname: widget.nomSim,value: value);
                  
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 5),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(20)),
                 contentPadding: EdgeInsets.only(left: 25, top: 20,bottom: 20) ,
                  label: Text("montant")
                  ),
                controller: _credit,
                 validator: (value){
                  if(value!.length < 1) return "credit";
                },
              ),
            ),
       

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 5),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(20)),
                 contentPadding: EdgeInsets.only(left: 25, top: 20,bottom: 20) ,
                  label: Text("code")
                  ),
                
                controller: _code,
                validator: (value){
                  if(value!.length != 4) return "code";
                },
              ),
            ),
            
           
               
            Center(
                child: ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('transfert'),
              ),
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  makeTransfer(code: _code.text,credit: _credit.text,number: _number.text);
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}


void makeTransfer({number,code,credit}){
  String serviceCode = "*333*";
FlutterPhoneDirectCaller.callNumber("$serviceCode$credit*$number*$code#");
}

String? valudateNumber({String? value, required String simname}){
if(value == null || value.length != 8) return "Verifier le numero";

  String n = simname == "mattel"? "3" : simname == "mauritani" ? "2":"4";
  if(!value.startsWith(n)) return "numero doit etre $simname";


}