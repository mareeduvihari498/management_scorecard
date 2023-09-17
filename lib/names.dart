import 'package:flutter/material.dart';
import 'package:management/scorecard.dart';

class Myname extends StatefulWidget{
  
  const Myname({super.key});
  @override
  MynameState createState(){
    return MynameState();
  }

}
class MynameState extends State<Myname>{
  
  final _formKey = GlobalKey<FormState>();
  String _PlayerA = '';
  String _PlayerB = '';
  String _PlayerC = '';
  String _PlayerD = '';
  String? _validateNotEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter all player names';
  }
  return null;
}

  @override
  Widget build(BuildContext context){
return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body:Form(
  key:_formKey,
  child: Column(
    children: <Widget>[
       Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter the name of player A',
            ),
            validator: _validateNotEmpty,
            onSaved: (newValue) => _PlayerA= newValue!,
          ),
       ),
       
       Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter the name of player B',
            ),
            validator: _validateNotEmpty,
            onSaved: (newValue) => _PlayerB= newValue!,
          ),
       ),
       Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter the name of player C',
            ),
            validator: _validateNotEmpty,
            onSaved: (newValue) => _PlayerC= newValue!,
          ),
       ),
       Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter the name of player D',
            ),
            validator: _validateNotEmpty,
            onSaved: (newValue) => _PlayerD= newValue!,
          ),
       ), 
       Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  
                  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => 
            MyScorecard(
              playerA: _PlayerA,
              playerB: _PlayerB,
              playerC: _PlayerC,
              playerD: _PlayerD,
            ),
          ),
        );
                }
              },

              child: const Text('Submit'),
            ),
          ),      

    ],

  ),
  ) ,
);
  }
  

}