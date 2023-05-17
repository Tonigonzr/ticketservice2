import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserListScreen extends StatelessWidget {
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('usuarios');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No hay usuarios registrados');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> userData = document.data() as Map<String, dynamic>;

              return ListTile(
                leading: Icon(Icons.person),
                title: Text(userData['correo'] ?? ''),
                subtitle: Text(userData['rol'] ?? ''),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
