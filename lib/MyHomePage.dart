import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FormularioFirebase extends StatefulWidget {
  @override
  _FormularioFirebaseState createState() => _FormularioFirebaseState();
}

class _FormularioFirebaseState extends State<FormularioFirebase> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  String? _categoriaSeleccionada;
  final _descripcionController = TextEditingController();

  List<String> _categorias = [    'Problema en seguridad',    'Problema en la cuenta',    'Problema en el producto',    'Problema con el producto recibido',  ];

  void enviarFormulario(String nombre, String email, String categoria, String descripcion) async {
    try {
      await _firestore.collection('formularios').add({
        'nombre': nombre,
        'email': email,
        'categoria': categoria,
        'descripcion': descripcion,
        'fecha': DateTime.now(),
      });
      print('Formulario enviado correctamente');
    } catch (e) {
      print('Error al enviar formulario: $e');
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
    return Padding(
      padding: EdgeInsets.all(380.0),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Tickets'),
                content: SingleChildScrollView(
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
                      ),
                      DropdownButtonFormField<String>(
                        value: _categoriaSeleccionada,
                        decoration: InputDecoration(
                          labelText: 'Categoría del problema',
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _categoriaSeleccionada = newValue;
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
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      enviarFormulario(
                        _nombreController.text,
                        _emailController.text,
                        _categoriaSeleccionada ?? '',
                        _descripcionController.text,
                      );
                      _nombreController.clear();
                      _emailController.clear();
                      _descripcionController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('Enviar'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(8),
          shape: CircleBorder(),
        ),
      ),
    );
  }
}
