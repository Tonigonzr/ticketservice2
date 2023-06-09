import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ticketservice2/AboutUs.dart';
import 'package:ticketservice2/Screens/LoginPage.dart';
import 'package:ticketservice2/Screens/MyHomePage.dart';
import 'package:ticketservice2/Spinner.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: FirebaseOptions(
        apiKey: "AIzaSyCD-yTlDWQk82O04klN3A0JPVnjSHmDkWA",
        appId: "1:165920359102:android:c885adbde4a523d24ed4ef",
        messagingSenderId: "165920359102",
        projectId: "ticketservice4-909f1"));
  }on Exception catch(_){

  }

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
      debugShowCheckedModeBanner: false,
      title: "TicketService",
      home: LoginPage(),
    );

  }
}