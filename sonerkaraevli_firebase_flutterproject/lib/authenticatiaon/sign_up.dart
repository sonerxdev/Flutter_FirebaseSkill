import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sonerkaraevli_firebase_flutterproject/authenticatiaon/auth.dart';
import 'package:sonerkaraevli_firebase_flutterproject/authenticatiaon/home.dart';
import 'package:sonerkaraevli_firebase_flutterproject/authenticatiaon/sign_in.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                          child: Text('Kayıt',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 175.0, 0.0, 0.0),
                          child: Text('Ol',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                            padding:
                                EdgeInsets.fromLTRB(100.0, 175.0, 0.0, 0.0),
                            child: Text('.',
                                style: TextStyle(
                                  fontSize: 80.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5B16D0),
                                )))
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Lütfen Email girin.';
                            }
                          },
                          onSaved: (input) => _email = input,
                          decoration: InputDecoration(
                              labelText: 'EMAIL',
                              labelStyle: TextStyle(
                                  fontFamily: 'MontSerrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF5B16D0)))),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          validator: (input) {
                            if (input.length < 6) {
                              return 'Şifreniz en az 6 karakter olmalı.';
                            }
                          },
                          onSaved: (input) => _password = input,
                          decoration: InputDecoration(
                              labelText: 'PASSWORD',
                              labelStyle: TextStyle(
                                  fontFamily: 'MontSerrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF5B16D0)))),
                          obscureText: true,
                        ),
                        SizedBox(height: 5.0),
                        SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Color(0xFF5B16D0),
                            color: Color(0xFF5B16D0),
                            elevation: 7.0,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              color: Color(0xFF5B16D0),
                              onPressed: signUp,
                              child: Center(
                                child: Text(
                                  'KAYIT OL',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        FlatButton(
                            onPressed: () {
                              signInWithGoogle().whenComplete(() {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Home();
                                    },
                                  ),
                                );
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 32,
                                  width: 32,
                                  child: Image.asset("assets/google.png"),
                                ),
                                SizedBox(width: 10.0),
                                Center(
                                  child: Text(
                                    'Google ile kaydol',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                )
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                                side: BorderSide(
                                    color: Colors.black,
                                    style: BorderStyle.solid)))
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Zaten hesabınız var mı?',
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
                      SizedBox(width: 5.0),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Text(
                          'Giriş Yapın!',
                          style: TextStyle(
                              color: Color(0xFF5B16D0),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )));
  }
 
 //Firebase'in register fonksiyonu. Login page sayfasına yönlendiriyorum.
  Future<void> signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        AuthResult user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        user.user.sendEmailVerification();
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
