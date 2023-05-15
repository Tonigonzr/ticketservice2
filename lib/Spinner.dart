import 'package:flutter/material.dart';
import 'package:ticketservice2/MyHomePage.dart';


class menulateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My app title',
        home: new HomeScreen()
    );
  }
}

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
              accountName: Text("Guillermo García"),
              accountEmail: Text("email@prueba.es"),
              currentAccountPicture: CircleAvatar(backgroundColor: Colors.white),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
              title: Text('Crear Ticket'),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => homepage()),
                );
              },
            ),
            ListTile(
              title: Text('Lista de tickets'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Segunda pantalla'),
      ),
      body: Center(
        child: Text('Contenido de la segunda pantalla'),
      ),
    );
  }
}
