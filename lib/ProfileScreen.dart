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
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _nameController.text = _user.displayName ?? '';
  }

  void sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _user.email!);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Correo electrónico enviado'),
            content: Text('Se ha enviado un correo electrónico para restablecer la contraseña.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('No se pudo enviar el correo electrónico de restablecimiento de contraseña.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _updateUserName() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _user.updateDisplayName(_nameController.text);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Nombre actualizado'),
              content: Text('Tu nombre ha sido actualizado correctamente.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
        setState(() {
          _isEditing = false;
        });
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Ha ocurrido un error al actualizar el nombre. Por favor, intenta nuevamente.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    }
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
            SizedBox(height: 16),
            if (!_isEditing)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                child: Text('Cambiar nombre'),
              ),
            if (_isEditing)
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nuevo nombre',
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Ajusta el tamaño del InputDecoration
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingresa un nombre válido.';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: _updateUserName,
                      child: Text('Guardar cambios'),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: sendPasswordResetEmail,
              child: Text('Cambiar contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}
