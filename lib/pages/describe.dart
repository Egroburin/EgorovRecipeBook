import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';

class describes extends StatefulWidget {
  const describes({super.key});

  @override
  State<describes> createState() => _describesState();
}

class _describesState extends State<describes> {

  int _myindex = -1;
  String _myid = ' ';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
     Map data = ModalRoute.of(context)?.settings.arguments as Map;
    _myindex = data['IND'];
    _myid = data['ID'];

     String value = '';
      String inter = '';
    void _handleBackButton() {
      Navigator.pushReplacementNamed(context, '/');
    }

    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Рецепт'),
          backgroundColor: Colors.amber,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _handleBackButton,
          ),
        ),
        body: StreamBuilder(
    stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData)
        return Text('Нет записей');
      else {
        value = snapshot.data!.docs[_myindex].get('describe');
        return Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(left: 25),
            ),
            SizedBox(height: 25),
            Container(
              color: Colors.grey[850],
              padding: EdgeInsets.all(16),
                child:Text(value,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),

            ),

            SizedBox(height: 25),
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Впишите Рецепт!'),
                      content: TextField(
                        onChanged: (String _value) {
                          inter = _value;
                        },
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              value = inter;
                              FirebaseFirestore.instance.collection('recipes').doc(_myid).set({
                                'recipe': snapshot.data!.docs[_myindex].get('recipe'),
                                'describe': value
                              });

                              Navigator.of(context).pop();
                            },
                            child: Text('Add'))
                      ],
                    );
                  },
                );
              },
              child: Text('Add'),
              backgroundColor: Colors.amber,
            ),
            SizedBox(height: 25),
          ]),
        );
      }
    }
    )
    );
  }
}
