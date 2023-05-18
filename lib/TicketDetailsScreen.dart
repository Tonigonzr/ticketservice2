import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketDetailsScreen extends StatefulWidget {
  final DocumentSnapshot ticket;

  TicketDetailsScreen({required this.ticket});

  @override
  _TicketDetailsScreenState createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _ticketStatus;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _ticketStatus = widget.ticket['estado'] ?? 'En espera'; // Set the initial ticket status
    _checkAdmin();
  }

  void _checkAdmin() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot snapshot = await _firestore.collection('usuarios').doc(currentUser.uid).get();
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('rol')) {
        setState(() {
          _isAdmin = userData['rol'] == 'admin';
        });
      }
    }
  }

  void _updateTicketStatus(String newStatus) async {
    if (_isAdmin) {
      try {
        await widget.ticket.reference.update({'estado': newStatus});
        setState(() {
          _ticketStatus = newStatus;
        });
        print('Ticket status updated successfully');
      } catch (e) {
        print('Error updating ticket status: $e');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Access Denied'),
            content: Text('Only admin can change the ticket status.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _deleteTicket() async {
    if (_isAdmin) {
      try {
        await widget.ticket.reference.delete();
        Navigator.pop(context); // Navigate back to the ticket list screen
        print('Ticket deleted successfully');
      } catch (e) {
        print('Error deleting ticket: $e');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Acceso denegado'),
            content: Text('Solo un administrador puede borrar el ticket'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

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
            SizedBox(height: 16),
            Text(
              'Usuario: ${widget.ticket['nombre']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Email: ${widget.ticket['email']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Categoría: ${widget.ticket['categoria']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Descripción: ${widget.ticket['descripcion']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Estado: $_ticketStatus',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (_isAdmin)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _updateTicketStatus('En proceso'),
                    child: Text('Marcar como en Proceso'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _updateTicketStatus('Resuelto'),
                    child: Text('Marcar como Resuelto'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _deleteTicket(),
                    child: Text('Borrar ticket'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
