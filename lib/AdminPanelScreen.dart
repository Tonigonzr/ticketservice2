import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListScreen extends StatelessWidget {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('usuarios');

  Future<void> updateUserRole(String userId, String newRole) async {
    DocumentReference userRef = _usersCollection.doc(userId);

    await userRef.update({'rol': newRole});
  }

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
              final userId = document.id;
              final userData = document.data() as Map<String, dynamic>;
              final email = userData['correo'];

              bool canChangeRole = true;

              if (email == 'antoniomiguelcaro02@gmail.com') {
                canChangeRole = false;
              }

              return ListTile(
                leading: Icon(Icons.person),
                title: Text(email ?? ''),
                subtitle: Text(userData['rol'] ?? ''),
                trailing: ElevatedButton(
                  child: Text('Cambiar Rol'),
                  onPressed: canChangeRole
                      ? () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Cambiar Rol'),
                          content: Text('Selecciona el nuevo rol para el usuario.'),
                          actions: [
                            TextButton(
                              child: Text('Cliente'),
                              onPressed: () {
                                updateUserRole(userId, 'cliente');
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('Admin'),
                              onPressed: () {
                                updateUserRole(userId, 'admin');
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                      : null,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
