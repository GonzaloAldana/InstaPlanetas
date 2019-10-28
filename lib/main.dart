import 'dart:io';
import 'package:path/path.dart';
import 'package:animated_card/animated_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'card_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

File imagen;
String filename;

class _MyAppState extends State<MyApp> {
  Future _getImage(ImageSource source) async {
    var selectedImage = await ImagePicker.pickImage(source: source);

    setState(() {
      if (selectedImage != null) {
        imagen = selectedImage;
        filename = basename(imagen.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'InstaPlanetas',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("NASA Space Apps"),
          ),
          body: Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('planetas').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return new Text('Loading...');
                return ListView(
                    shrinkWrap: true,
                    children: snapshot.data.documents.map((document) {
                      return Column(
                        children: <Widget>[
                          AnimatedCard(
                              child: CardWidget("Planeta",
                                  document['imagen'].cast<String>()))
                        ],
                      );
                    }).toList());
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.publish),
            onPressed: () {
              _getImage(ImageSource.gallery);
            },
          ),
        ));
  }
}

Future<String> uploadImage(double lat, double lon, String nombre) async {
  StorageReference ref = FirebaseStorage.instance.ref().child(filename);
  StorageUploadTask uploadTask = ref.putFile(imagen);
  var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
  var url = downUrl.toString();
  List<String> urls = [];
  urls.add(url);

  print("URL de imagen: $url");
  Firestore.instance
      .collection('marcadorNombre')
      .document()
      .setData({'lat': lat, 'lon': lon, 'nombre': nombre, 'imagen': urls});
  imagen = null;
  return url;
}
