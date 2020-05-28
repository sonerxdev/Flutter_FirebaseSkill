import 'package:flutter/material.dart';
import 'package:sonerkaraevli_firebase_flutterproject/infostyles/infoscreen1.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //yalnızca Infoscreeni çalıştırıyorum main.dart ilk çalıştığı için uygulamanın hızlı çalışması için.
      home: InfoScreen(),
    );
  }
}
