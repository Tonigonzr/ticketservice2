import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticketservice2/ResetPasswordPage.dart';
import 'package:ticketservice2/Screens/CreateUserPage.dart';
import 'package:ticketservice2/Screens/MyHomePage.dart';
import 'package:ticketservice2/Spinner.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  late String email, password;
  final _formsKey = GlobalKey<FormState>();
  String error = '';
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(20),
              child: Image.asset(
                'assets/images/ticketservice1.png',
                height: 140,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Offstage(
                offstage: error.isEmpty,
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: formulario(),
            ),
            SizedBox(height: 24),
            botonLogin(),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: nuevousuario(),
            ),
          ],
        ),
      ),
    );
  }

  Widget nuevousuario() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateUserPage()),
            );
          },
          child: Text(
            "¿No tienes cuenta? Regístrate",
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ResetPasswordPage()),
            );
          },
          child: Text(
            "¿Has olvidado la contraseña?",
            style: TextStyle(
              fontSize: 16,
              color: Colors.red, // Puedes ajustar el color según tus preferencias
            ),
          ),
        ),
      ],
    );
  }



  Widget formulario() {
    return Form(
      key: _formsKey,
      child: Column(
        children: [
          buildEmail(),
          SizedBox(height: 24),
          buildPassword(),
        ],
      ),
    );
  }

  Widget buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Correo electrónico",
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String? value) {
        email = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  Widget buildPassword() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Contraseña",
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value) {
        password = value!;
      },
    );
  }

  Widget botonLogin() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: ElevatedButton(
        onPressed: () async {
          if (_formsKey.currentState!.validate()) {
            _formsKey.currentState!.save();
            UserCredential? credenciales = await login(email, password);
            if (credenciales != null) {
              if (credenciales.user != null) {
                if (isEmailVerified || credenciales.user!.emailVerified) {
                  isEmailVerified = true; // Marcar como verificado
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => menulateral()),
                        (Route<dynamic> route) => false,
                  );
                } else {
                  setState(() {
                    error = "Debes verificar tu correo para acceder";
                  });
                }
              }
            }
          }
        },
        child: Text(
          "Entrar",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFFA0202),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        isEmailVerified = userCredential.user!.emailVerified;
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          error = "El usuario no fue encontrado. Por favor, verifique sus credenciales.";
        });
      }
      if (e.code == 'wrong-password') {
        setState(() {
          error = "La contraseña es incorrecta. Por favor, verifique sus credenciales.";
        });
      }
    }
  }

}