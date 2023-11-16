import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:conexionfirebase/models/crud.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void getDatos() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('tb_demo');
    QuerySnapshot personas = await collectionReference.get();
    if (personas.docs.length != 0) {
      for (var doc in personas.docs) {
        print(doc.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'holi',
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Page 1'),
              onTap: () {
                // Aquí puedes navegar a la primera página o realizar otras acciones
              },
            ),
            ListTile(
              title: Text('Page 2'),
              onTap: () {
                // Aquí puedes navegar a la segunda página o realizar otras acciones
              },
            ),
            ListTile(
              title: Text('Page 3'),
              onTap: () {
                // Aquí puedes navegar a la tercera página o realizar otras acciones
              },
            ),
            ListTile(
              title: Text('Page 4'),
              onTap: () {
                // Aquí puedes navegar a la cuarta página o realizar otras acciones
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getDatos();
  }
}
