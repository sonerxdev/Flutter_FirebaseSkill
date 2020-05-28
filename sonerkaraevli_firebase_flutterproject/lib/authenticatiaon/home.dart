import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:sonerkaraevli_firebase_flutterproject/authenticatiaon/account.dart';
import 'package:share/share.dart';


class Home extends StatefulWidget {
  const Home({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  //global image değişkenim, bunu hem imagePicker hem de readText() fonksiyonları kullanıyor.
  File _image;
  //abc adında boş bir liste oluşturdum recognize edilen textleri buraya atıyorum.
  List<String> abc = new List<String>();
  String bac = "";
  bool isImageLoaded = false;


  //imagePicker fonksiyonum. seçilen image'ı _image değişkenine atıyorum.
  Future getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ),
    );
    setState(() {
      _image = image;
    });
  }
  
  //recognized edilen text'i bac adında bir string'e atıyorum ve ordan share ediyorum. Share fonksiyonu.
  Future oku() async {
    bac = abc.join(" ");
    final RenderBox box = context.findRenderObject();
    Share.share(bac,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    abc.clear();
  }


//image upload fonksiyonu.Firebase e image upload ediyor.
  Future uploadImage() async {
  
   // get image ile aldigim _image'ı "resim_.jpg" adıyla firebase e upload yapıyorum. 
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("photos").child('image_'+DateTime.now().toString());
    final StorageUploadTask task = firebaseStorageRef.putFile(_image);
    
  }
 
 //Firebase'in Recognize Text Machine Learning Kit Fonksiyonu. Firebase MLvision.dart kütüphanesinden çağrılıyor.
  Future readText() async {

    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(_image);
    //buradaki text recognizer i değiştirip firebase fonksiyonlarını göstericem
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    
    //for loop ile recognized edilen textleri önce ToString() ile stringe çevirip sonra debug console ve abc ismindeki boş listeye atıyorum.
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          abc.add(word.text.toString());
          print(word.text);
        }
      }
    }
  }

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
              margin: EdgeInsets.only(top: 36.0),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: (Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  //Profile Page'e yönlendiriyorum.
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyAccount()));
                    },
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  )
                ],
              ))),
          Container(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 60.0, 10.0, 50.0),
            child: Text(
              'Hesabınıza gitmek istiyorsanız ayarlar"a tıklayın.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //burada picked edilen image'i imageBox da gösteriyorum.
          _image != null
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
                  child: Center(
                      child: Container(
                          height: 250.0,
                          width: 350.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(_image),
                                  fit: BoxFit.cover)))))
              : Container(
                  height: 200.0, width: 200.0, decoration: BoxDecoration()),
          Container(
            padding: EdgeInsets.fromLTRB(30.0, 450.0, 30.0, 250.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
              ),
              color: Color(0xFF5B16D0),
              onPressed: () {
                //get image Fonksiyonunu çağırıyorum.
                getImage(ImgSource.Both);
                // abc.clear();
              },
              child: Center(
                child: Text(
                  'Fotoğraf Seç',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            padding: EdgeInsetsDirectional.fromSTEB(30.0, 550.0, 30.0, 150.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
              ),
              color: Color(0xFF5B16D0),
              onPressed: () {
                //readText Fonksiyonunu çağırıyorum.
                readText();
                //bac = abc.join(" ");
                oku();
              },
              child: Center(
                child: Text(
                  'Text Oku ve Paylaş',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30.0, 650.0, 30.0, 50.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
              ),
              color: Color(0xFF5B16D0),
              //Firebase e upload etmek için uploadImage Fonksiyonunu çağırıyorum. 
              //bu fonksiyon Stored.dart dosyasında. Stored.dart kütüphanesini ekledim
              onPressed: uploadImage,
              child: Center(
                child: Text(
                  'Kaydet',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 60.0, 10.0, 50.0),
          ),
        ],
      ),
    );
  }
}
