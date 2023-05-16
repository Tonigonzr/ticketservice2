import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticketservice2/AboutUs.dart';
import 'package:ticketservice2/LoginPage.dart';
import 'package:ticketservice2/MyHomePage.dart';
import 'package:ticketservice2/ProfileScreen.dart';
import 'package:ticketservice2/TicketDetailsScreen.dart';


class menulateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My app title',
        home: new HomeScreen()
    );
  }
}
User? currentUser = FirebaseAuth.instance.currentUser;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi App'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ticketservice1.png',
              width: 200,
            ),
            SizedBox(height: 20),
            Text('Bienvenido a Ticket Service'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(currentUser?.displayName ?? ""),
              accountEmail: Text(currentUser?.email ?? ""),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(currentUser?.photoURL ?? ""),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
              title: Text('Mi perfil'),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),

            ListTile(
              title: Text('Crear Ticket'),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormularioFirebase()),
                );
              },
            ),
            ListTile(
              title: Text('Lista de tickets'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TicketListScreen()  ),
                );
              },
            ),
            ListTile(
              title: Text('Sobre Nosotros'),
              leading: Icon(Icons.accessibility),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsScreen()),
                );
              }, // Add code to sign out the user and navigate to the login screen
            ),
            ListTile(
              title: Text('Cerrar Sesión'),
              leading: Icon(Icons.exit_to_app),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              }, // Add code to sign out the user and navigate to the login screen
            ),
          ],
        ),
      ),
    );
  }
}



class TicketListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de tickets'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('formularios')
            .where('user_id', isEqualTo: currentUser!.uid)
            .orderBy('email', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final tickets = snapshot.data!.docs;

          if (tickets.isEmpty) {
            return Text('No tienes tickets');
          }

          return ListView(
            children: tickets.map((DocumentSnapshot document) {
              return ListTile(
                title: Text(document['categoria']),
                subtitle: Text(document['descripcion']),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TicketDetailsScreen(ticket: document)),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
