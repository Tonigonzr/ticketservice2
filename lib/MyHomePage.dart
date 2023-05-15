import 'package:flutter/material.dart';

class homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Icon(Icons.add),
            onPressed: () {
              _showFormDialog(context);
            },
          ),
        ),
      ),
    );
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Formulario de problema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Usuario'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Correo electrónico'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Categoría del problema'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Descripción del problema'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text('Enviar'),
              onPressed: () {
                // Aquí se enviará el formulario
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
