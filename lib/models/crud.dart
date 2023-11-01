import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

//Metodo para consultar toda la informacion de la base de datos

Future<List> getDatos() async{

  List estudiantes =[];

  CollectionReference collectionReference = db.collection('tb_demo');
  QuerySnapshot querySnapshot= await collectionReference.get();

  querySnapshot.docs.forEach((documento) {
    estudiantes.add(documento.data());

  });

  return estudiantes;
}