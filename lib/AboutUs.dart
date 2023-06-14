import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ticketservice1.png',
                width: 350,
              ),
              SizedBox(height: 20),
              Text(
                'TicketService',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
                Text(
                  '¡Bienvenido a Ticket Service, la plataforma líder en gestión de tickets y servicio al cliente! Somos una empresa dedicada a proporcionar una solución integral para empresas y organizaciones que buscan optimizar su atención al cliente y brindar un servicio eficiente y de calidad.',
                  style: TextStyle(fontSize: 18,),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 20),
              Text(
                'Misión',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Ticket Service es una aplicación móvil y web que permite a las empresas gestionar de manera efectiva los tickets de soporte, consultas y problemas reportados por sus clientes. Nuestra plataforma simplifica el proceso de seguimiento y resolución de tickets, mejorando la comunicación entre el equipo de soporte y los clientes.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              ],
          ),
        ),
      ),
    );
  }
}
