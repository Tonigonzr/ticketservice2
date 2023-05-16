import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_user.photoURL ?? ""),
            ),
            SizedBox(height: 16),
            Text(
              "Nombre: ${_user.displayName}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              "Email: ${_user.email}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final imagePicker = ImagePicker();
                final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  // Subir la foto al almacenamiento de Firebase Storage
                  final storageRef = firebase_storage.FirebaseStorage.instance.ref();
                  final fileRef = storageRef.child('perfil/${_user.uid}');
                  await fileRef.putFile(File(pickedFile.path));

                  // Obtener la URL de descarga de la foto
                  final downloadURL = await fileRef.getDownloadURL();

                  // Guardar la URL en la colección "fotos_usuarios" de Firestore
                  final firestore = FirebaseFirestore.instance;
                  final userRef = firestore.collection('fotos_usuarios').doc(_user.uid);
                  await userRef.set({
                    'user_id': _user.uid,
                    'url': downloadURL,
                  });

                  // Actualizar la URL de la foto en el perfil del usuario
                  await _user.updatePhotoURL(downloadURL);

                  setState(() {
                    // Actualizar la imagen mostrada en el avatar
                    _user = FirebaseAuth.instance.currentUser!;
                  });
                }
              },
              child: Text('Seleccionar foto'),
            ),
          ],
        ),
      ),
    );
  }
}
