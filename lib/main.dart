import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ticketservice2/LoginPage.dart';
import 'package:ticketservice2/MyHomePage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyCD-yTlDWQk82O04klN3A0JPVnjSHmDkWA", appId: "1:165920359102:android:c885adbde4a523d24ed4ef", messagingSenderId: "165920359102", projectId: "ticketservice4-909f1"));

  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State createState() {
    return _MyAppState();
  }

}
class _MyAppState extends State<MyApp>{

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TicketService",
      home: LoginPage(),
    );

  }
}