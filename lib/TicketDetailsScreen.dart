import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketDetailsScreen extends StatelessWidget {
  final DocumentSnapshot ticket;

  TicketDetailsScreen({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del ticket'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${ticket['nombre']}'),
            SizedBox(height: 8.0),
            Text('Correo electrónico: ${ticket['email']}'),
            SizedBox(height: 8.0),
            Text('Categoría del problema: ${ticket['categoria']}'),
            SizedBox(height: 8.0),
            Text('Descripción del problema: ${ticket['descripcion']}'),
            SizedBox(height: 8.0),
            Text('Fecha: ${ticket['fecha'].toDate().toString()}'),
          ],
        ),
      ),
    );
  }
}
