import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management/confetti.dart';


class MyScorecard extends StatefulWidget {
  final String playerA;
  final String playerB;
  final String playerC;
  final String playerD;

  const MyScorecard({super.key, 
    required this.playerA,
    required this.playerB,
    required this.playerC,
    required this.playerD,
  });

  @override
  MyScorecardState createState() => MyScorecardState();
}

class MyScorecardState extends State<MyScorecard> {
  List<List<int>> scores = [];
  int round=1;
  List<int> totalScores =[0,0,0,0];
  bool addScores = true;
  List<List<int>> history=[];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addData(String name,int score) async{
    await _firestore.collection('Leaderboard').add({
        'name': name,
        'score': score,
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Score Card")),
      body: Column(
        children: [
          Row(
            children: [
              _buildHeaderCell('Rnd'),
              _buildHeaderCell(widget.playerA),
              _buildHeaderCell(widget.playerB),
              _buildHeaderCell(widget.playerC),
              _buildHeaderCell(widget.playerD),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scores.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    _buildScoreCell((index + 1).toString()),
                    _buildScoreCell(scores[index][0].toString()),
                    _buildScoreCell(scores[index][1].toString()),
                    _buildScoreCell(scores[index][2].toString()),
                    _buildScoreCell(scores[index][3].toString()),
                  ],
                );
              },
            ),
          ),
         Padding(padding: const EdgeInsets.all(4),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Total"),
            for (var score in totalScores)
              Text("$score")
          ],
        )
        ),
          Padding(
            padding: const EdgeInsets.all(16),
          child:Row(children: [ 
            ElevatedButton(
            child: const Text('Add Scores'),
            onPressed: () => 
            {
              
              if(addScores){
                
                _inputForm(context, round)
              }
              else{
                
                _showInputBottomSheet(context)
              }
            }//_inputForm(context, round)//_showInputBottomSheet(context),
          ),
          ElevatedButton(onPressed: (){
            if(scores.isNotEmpty){
              if(history.isNotEmpty){
              if(addScores){
                  setState(() {
                    round--;
                    for (int i = 0; i < totalScores.length; i++) {
                     totalScores[i] -= scores.last[i];
                           }
                   scores.removeLast();
                  print(history[0]);
                  scores.add(history[0]);
                });
                _showInputBottomSheet(context);
              }
              else{
                setState(() {
                  //round--;
                  
                  scores.removeLast();
                  history.removeLast();
                });
                _inputForm(context, round);
              }
              setState(() {
                addScores=!addScores;
              });
              }
              else{
                showDialog(context: context, builder: (context){
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding:  EdgeInsets.all(16.0),
                        child: Text('you can\'t undo more than one round'),
                      ),
                      
                    );
                  });
              }
          }
          },
           child: const Text('Undo')
           )
          ],)
          ),
        ],
      ),
    );
  }
  Widget _buildHeaderCell(String title) {
  return Expanded(
    child: Container(
      color: Colors.black, // Set the color of the container to black.
      child: Card(
        margin: EdgeInsets.zero, // Set margin to zero.
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(title)),
        ),
      ),
    ),
  );
}

Widget _buildScoreCell(String score) {
  return Expanded(
    child: Container(
      color: Colors.black, // Set the color of the container to black.
      child: Card(
        margin: EdgeInsets.zero, // Set margin to zero.
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(score)),
        ),
      ),
    ),
  );
}
void _showInputBottomSheet(BuildContext context) {
  List<bool> roundWinner=[true,true,true,true];
  
  showModalBottomSheet(

    context: context,
    builder: (BuildContext context) {
      return Center(
        heightFactor: 2,
        widthFactor: 2,
        child: 
      Padding(

    padding: const EdgeInsets.all(32.0),
    child: 
           Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child:
          StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
                return Row(children: [
                  Text('${widget.playerA} has won'),
                  Switch(value: roundWinner[0], 
                onChanged: ((value) {

                  stateSetter(() =>roundWinner[0]=value);
                  
                }
                ),

          )
          ]);
          }),
          
           ),
           Container(
            padding: const EdgeInsets.all(8.0),
            child:
          StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
                return Row(children: [
                  Text('${widget.playerB} has won'),
                  Switch(value: roundWinner[1], 
                onChanged: ((value) {

                  stateSetter(() => roundWinner[1] =value);
                  
                }
                ),

          )
          ]);
          }),
          
           ),
           Container(
            padding: const EdgeInsets.all(8.0),
            child:
          StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
                return Row(children: [
                  Text('${widget.playerC} has won'),
                  Switch(value: roundWinner[2], 
                onChanged: ((value) {

                  stateSetter(() =>roundWinner[2]=value);
                  
                }
                ),

          )
          ]);
          }),
          
           ),
           Container(
            padding: const EdgeInsets.all(8.0),
            child:
          StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
                return Row(children: [
                  Text('${widget.playerD} has won'),
                  Switch(value: roundWinner[3], 
                onChanged: ((value) {

                  stateSetter(() =>roundWinner[3]=value);
                  
                }
                ),

          )
          ]);
          }),
          
           ),
           ElevatedButton(
              onPressed: () async {
                int roundWinners=scores.last.asMap().entries.where((entry) {
  int index = entry.key;
  return index < roundWinner.length && roundWinner[index];  // filter by condition
}).fold(0, (prev, entry) => prev + entry.value);
                if(roundWinner[0]&&roundWinner[1]&&roundWinner[2]&&roundWinner[3]){
                  showDialog(context: context, builder: (context){
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding:  EdgeInsets.all(16.0),
                        child: Text('All four player\'s can\'t win'),
                      ),
                      
                    );
                  });

                }
                else if (roundWinners>round){
                  showDialog(context: context, builder: (context){
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Wins greater than round'),
                      ),
                      
                    );
                });
                }
                else{
                
                setState(() {
                  
                  for(int i=0;i<4;i++){
                  scores[round-1][i] = roundWinner[i] ? (10 + (scores[round-1][i] * 11)) : 0;
                  totalScores[i]+=scores.last[i];
                  }
                  addScores = true;
                  round++;
                });
                
                Navigator.of(context).pop();
                if(round>13){
                  String playerName='empty';
                  int maxValue=totalScores.reduce(max);
                  int count = totalScores.where((element) => element == maxValue).length;
                  if(count>1){
                    round--;
                  }
                  else{
                    int index= totalScores.indexOf(maxValue);
                    
                    if(index==0){
                      playerName=widget.playerA;

                    }
                    else if(index==1){
                      playerName=widget.playerB;
                    }
                    else if(index==2){
                      playerName=widget.playerC;
                    }
                    else if(index==3){
                      playerName=widget.playerD;
                    }
                    _addData(playerName, maxValue);
                  }
                    Navigator.push(context, MaterialPageRoute(builder: ((context) =>  MyConfettiPage(playerName: playerName, playerScore: maxValue,) )));
                  


                }
              }
              },
              child: const Text('submit'),
            )

           ])
           )
           );
        
    }
    );
    
}
Future<void> _inputForm(BuildContext context, int value) {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  final TextEditingController controller4 = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // A key to identify the form

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Score'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(  // To avoid overflow if the keyboard covers the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Round : $value'),
                TextFormField(
                  controller: controller1,
                  keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                  decoration: const InputDecoration(hintText: 'Enter score 1'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    else if(int.tryParse(value)! > round){
                      return 'value can\'t be greater than round';

                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: controller2,
                  keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                  decoration: const InputDecoration(hintText: 'Enter score 2'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    else if(int.tryParse(value)! > round){
                      return 'value can\'t be greater than round';

                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: controller3,
                  keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                  decoration: const InputDecoration(hintText: 'Enter score 3'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    else if(int.tryParse(value)! > round){
                      return 'value can\'t be greater than round';

                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: controller4,
                  keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                  decoration: const InputDecoration(hintText: 'Enter score 4'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    else if(int.tryParse(value)! > round){
                      return 'value can\'t be greater than round';

                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if((int.tryParse(controller1.text)!+int.tryParse(controller2.text)!+int.tryParse(controller3.text)!+int.tryParse(controller4.text)!)!=value){
                setState(() {
                  addScores=false;
                  //history.removeLast();
                  scores.add([int.tryParse(controller1.text)!,int.tryParse(controller2.text)!,int.tryParse(controller3.text)!,int.tryParse(controller4.text)!]);
                  if(history.isNotEmpty){
                    history.removeLast();

                  }
                  history.add([int.tryParse(controller1.text)!,int.tryParse(controller2.text)!,int.tryParse(controller3.text)!,int.tryParse(controller4.text)!]);
                });
                
                // Handle the data, e.g., store it or pass it further
                Navigator.of(context).pop();
                }
                else{
                   ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The sum is equal to the round value!'))
    );
                }
              }
            },
            child: const Text('Submit'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}



InputDecoration _inputDecoration() {
  return const InputDecoration(
    labelText: "Enter a number",
    border: OutlineInputBorder(),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
  );
}

String? _numberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a number';
  }
  final isDigitsOnly = int.tryParse(value);
  if (isDigitsOnly == null) {
    return 'Please enter a valid number';
  }
  return null;
}


  
}






