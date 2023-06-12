import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FormularioFirebase extends StatefulWidget {
  @override
  _FormularioFirebaseState createState() => _FormularioFirebaseState();
}

class _FormularioFirebaseState extends State<FormularioFirebase> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _descripcionController = TextEditingController();

  List<String> _categorias = [
    'Problema en seguridad',
    'Problema en la cuenta',
    'Problema en el producto',
    'Problema con el producto recibido',
  ];

  @override
  void initState() {
    super.initState();
    // Asignar el correo electrónico del usuario actual al controlador de email
    _emailController.text = currentUser?.email ?? '';
    _nombreController.text = currentUser?.displayName ?? '';
  }

  void enviarFormulario(String nombre, String email, String categoria, String descripcion) async {
    try {
      await _firestore.collection('formularios').add({
        'nombre': nombre,
        'email': email,
        'categoria': categoria,
        'descripcion': descripcion,
        'estado': 'Enviado', // Establecer el estado como "enviado"
        'user_id': currentUser!.uid, // Asignar el UID del usuario actual
        'fecha': DateTime.now(),
      });
      print('Formulario enviado correctamente');
    } catch (e) {
      print('Error al enviar formulario: $e');
    }
  }

  void validarYEnviarFormulario() {
    if (_nombreController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _descripcionController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Por favor, complete todos los campos.'),
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
    } else {
      enviarFormulario(
        _nombreController.text,
        _emailController.text,
        _categorias[0], // Establecer la primera categoría por defecto
        _descripcionController.text,
      );
      _nombreController.clear();
      _emailController.clear();
      _descripcionController.clear();
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario Firebase'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
              ),
              enabled: false, // Hacer el campo no editable
            ),
            DropdownButtonFormField<String>(
              value: _categorias[0], // Establecer la primera categoría por defecto
              decoration: InputDecoration(
                labelText: 'Categoría del problema',
              ),
              onChanged: (String? newValue) {
                setState(() {
                  // No se necesita implementar el cambio de categoría en este caso
                });
              },
              items: _categorias
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ),
              )
                  .toList(),
            ),
            TextField(
              controller: _descripcionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Descripción del problema',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: validarYEnviarFormulario,
              child: Text('Enviar'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
