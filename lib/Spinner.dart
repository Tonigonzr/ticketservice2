import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketservice2/AboutUs.dart';
import 'package:ticketservice2/LoginPage.dart';
import 'package:ticketservice2/MyHomePage.dart';
import 'package:ticketservice2/ProfileScreen.dart';
import 'package:ticketservice2/TicketDetailsScreen.dart';

class menulateral extends StatefulWidget {
  @override
  _menulateralState createState() => _menulateralState();
}

class _menulateralState extends State<menulateral> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<User?> userStream;

  @override
  void initState() {
    super.initState();
    userStream = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicketService',
      home: HomeScreen(userStream: userStream),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Stream<User?> userStream;

  const HomeScreen({required this.userStream});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    widget.userStream.listen((User? user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TicketService'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ticketservice1.png',
              width: 350,
            ),
            SizedBox(height: 20),
            Text(
              'Bienvenido a Ticket Service',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            StreamBuilder<User?>(
              stream: widget.userStream,
              builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                User? user = snapshot.data;
                if (user != null) {
                  currentUser = user;
                }
                return UserAccountsDrawerHeader(
                  accountName: Text(currentUser?.displayName ?? ""),
                  accountEmail: Text(currentUser?.email ?? ""),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(currentUser?.photoURL ?? ""),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                );
              },
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
                  MaterialPageRoute(builder: (context) => TicketListScreen(currentUser: currentUser)),
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
              },
            ),
            FutureBuilder<bool>(
              future: isAdmin(currentUser),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                final bool isAdmin = snapshot.data ?? false;

                if (isAdmin) {
                  return ListTile(
                    title: Text('Admin Panel'),
                    leading: Icon(Icons.admin_panel_settings),
                    onTap: () {
                      // Agrega aquí la acción deseada para el panel de administrador
                    },
                  );
                } else {
                  return Container();
                }
              },
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
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> isAdmin(User? user) async {
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('usuarios').doc(user.uid).get();
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('rol')) {
        return userData['rol'] == 'admin';
      }
    }
    return false;
  }
}

class TicketListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser;

   TicketListScreen({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de tickets'),
      ),
      body: FutureBuilder<bool>(
        future: isAdmin(currentUser),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final bool isAdmin = snapshot.data ?? false;

          if (isAdmin) {
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('formularios').orderBy('email', descending: false).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final tickets = snapshot.data!.docs;

                if (tickets.isEmpty) {
                  return Text('No hay tickets disponibles');
                }

                return ListView(
                  children: tickets.map((DocumentSnapshot document) {
                    final date = document['fecha'] as Timestamp;
                    final formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(date.toDate());

                    return Column(
                      children: [
                        SizedBox(height: 16),
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ListTile(
                          title: Text(document['categoria']),
                          subtitle: Text(document['descripcion']),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TicketDetailsScreen(ticket: document)),
                            );
                          },
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            );
          } else {
            return StreamBuilder<QuerySnapshot>(
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
                    final date = document['fecha'] as Timestamp;
                    final formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(date.toDate());

                    return Column(
                      children: [
                        SizedBox(height: 16),
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ListTile(
                          title: Text(document['categoria']),
                          subtitle: Text(document['descripcion']),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TicketDetailsScreen(ticket: document)),
                            );
                          },
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<bool> isAdmin(User? user) async {
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('usuarios').doc(user.uid).get();
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('rol')) {
        return userData['rol'] == 'admin';
      }
    }
    return false;
  }
}
