import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sonerkaraevli_firebase_flutterproject/authenticatiaon/auth.dart';
import 'package:sonerkaraevli_firebase_flutterproject/authenticatiaon/home.dart';
import 'package:sonerkaraevli_firebase_flutterproject/authenticatiaon/sign_up.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Global olarak email ve Password stringi tanımladım tanımladım.
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
                          child: Text('Hoş',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 175.0, 0.0, 0.0),
                          child: Text('geldiniz',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                            padding:
                                EdgeInsets.fromLTRB(300.0, 175.0, 0.0, 0.0),
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
                          //burada email input alıyorum
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
                          //password input alıyorum
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
                        Container(
                          alignment: Alignment(1.0, 0.0),
                          padding: EdgeInsets.only(top: 15.0, left: 20.0),
                          child: InkWell(
                            child: Text(
                              'Şifrenizi mi unuttunuz?',
                              style: TextStyle(
                                  color: Color(0xFF5B16D0),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
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
                              //giriş yap butonu signIn fonksiyonunu çağırıyor.
                              onPressed: signIn,
                              child: Center(
                                child: Text(
                                  'GİRİŞ YAP',
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
                          //Google ile giriş yap butonu signInWithGoogle fonksiyonunu çağırıyor.WhenComplete fonksiyonu true olursa Home sayfasına yönlendiriyor.
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
                                    'Google ile giriş yap',
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
                        'Karaevli"de yeni misiniz?',
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
                      SizedBox(width: 5.0),
                      InkWell(
                        //register sayfasına yönlendiriyor.
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                        child: Text(
                          'kaydolun!',
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
 //firebase in signIn fonksiyonu. Bütün dillerde aynıdır.
  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        //_email ve _password değişkenlerini signInwithEmailandPassword fonksiyonu ile çaıştırıyorum true dönerse Home sayfasına yönlendiriyor.
        AuthResult user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Home(user: user.user)));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
