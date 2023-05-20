import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String recipetext = '';
  String CookBookStr = '';
 void initFirebase() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
 }

  @override
  void initState() {

 //   initFirebase();


  }


  FirebaseFirestore firestore = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    Map? data = ModalRoute.of(context)?.settings.arguments as Map?;


    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Книга рецептов'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
        if(!snapshot.hasData) return Text('Нет записей');
        else {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(snapshot.data!.docs[index].id),
                  child: Card(
                    child: ListTile(
                      title: Text(snapshot.data!.docs[index].get('recipe')),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: Colors.amber,
                        ),
                        onPressed: () {

                          Navigator.pushNamedAndRemoveUntil(
                              context, '/desc', (Route) => false,
                              arguments: {
                                'IND': index, //snapshot.data!.docs[index].id
                                'ID' : snapshot.data!.docs[index].id
                              });
                        },
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    FirebaseFirestore.instance.collection('recipes').doc(snapshot.data!.docs[index].id).delete();
                  },
                );
              });
        }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Добавить рецепт'),
                  content: TextField(
                    onChanged: (String value) {
                      CookBookStr = value;
                    },
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                        FirebaseFirestore.instance.collection('recipes').add({'recipe': CookBookStr, 'describe': "Добавьте свой рецепт!"});
                          Navigator.of(context).pop();
                        },
                        child: Text('Добавить'))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add_box,
          color: Colors.grey[900],
        ),
      ),
    );
  }
}
