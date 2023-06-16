import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String ticketId;

  ChatScreen({required this.ticketId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late CollectionReference _messagesCollection;
  late String _userRole;

  @override
  void initState() {
    super.initState();
    _messagesCollection =
        FirebaseFirestore.instance.collection('tickets/${widget.ticketId}/messages');
    _getUserRole();
  }

  void _getUserRole() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(currentUser.uid)
          .get();
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('rol')) {
        setState(() {
          _userRole = userData['rol'];
        });
      }
    }
  }

  void _sendMessage() async {
    final String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      await _messagesCollection.add({
        'message': messageText,
        'sender': _userRole, // Utilizar el rol del remitente
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat de Soporte'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> messages =
                  snapshot.data!.docs.reversed.toList();
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final messageText = message['message'];
                      final sender = message['sender'];

                      // Determinar el alineamiento del mensaje
                      final alignment = sender == 'admin'
                          ? Alignment.centerRight
                          : Alignment.centerLeft;

                      // Establecer el color de fondo del mensaje
                      final color =
                      sender == 'admin' ? Colors.green : Colors.blueGrey;

                      return Container(
                        alignment: alignment,
                        child: Card(
                          color: color,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              messageText,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error al cargar los mensajes'),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
