import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Leaderboard extends StatefulWidget{
  const Leaderboard({super.key});
  @override
  LeaderboardState createState(){
    return LeaderboardState();
  }
}
class LeaderboardState extends State<Leaderboard>{
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blueGrey[100]!, Colors.blueGrey[300]!],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('Leaderboard').orderBy('score', descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No scores available'));
            }

            final scores = snapshot.data!.docs;
            
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Changed to 4 cards in one row
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: scores.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                final doc = scores[index];
                return Card(
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Stack(
                    children: [
                      // Symbol in the middle of the card
                      Center(
                        child: Icon(
                          Icons.star,
                          size: 30, // Reduced the size a bit
                          color: Colors.yellow[700],
                        ),
                      ),
                      // Name in the center
                      Center(
                        child: Text(
                          doc['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepPurple),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Score on top-left
                      Positioned(
                        top: 5,
                        left: 5,
                        child: Text(doc['score'].toString(), style: TextStyle(fontSize: 14, color: Colors.green[700])),
                      ),
                      // Score on bottom-right
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Text(doc['score'].toString(), style: TextStyle(fontSize: 14, color: Colors.green[700])),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
  }
