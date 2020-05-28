
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sonerkaraevli_firebase_flutterproject/authenticatiaon/auth.dart';
import 'package:sonerkaraevli_firebase_flutterproject/authenticatiaon/sign_in.dart';
import 'package:sonerkaraevli_firebase_flutterproject/stored.dart';





class MyAccount extends StatefulWidget {
  
  const MyAccount({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
   
  
    
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.85),
                  Colors.black,
                ],
                stops: [0.4, 1],
                begin: Alignment.topLeft,
              ),
            ),
          ),

          
       Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
           colors: [
                  Colors.black.withOpacity(0.85),
                  Colors.black,
                ],
                stops: [0.4, 1],
                begin: Alignment.topLeft,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  //user'a ait atadığım değişkenleri çağırıyorum ve gösteriyorum :auth.dart
                  imageUrl,
                ),
                radius: 60,
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 40),
              Text(
                'İsim',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Email',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                //user'a ait atadığım değişkenleri çağırıyorum ve gösteriyorum :auth.dart
                email,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              RaisedButton(
                //firbasedeki fotoğraflarımı gösteren sayfaya yönlendiriyorum.
                onPressed: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ImagesScreen()));
                },
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Fotoğraflarım',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              ),
               SizedBox(height: 40),

              RaisedButton(
                //Log out fonksiyonunu çağırıyorum ve Login sayfasına yönlendiriyorum.
                onPressed: () {
                  signOutGoogle();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
                },
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Çıkış Yap',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              )
            ],
          ),
        ),
      ),
         
        
         
        ],
      ),
    );
  }
}
