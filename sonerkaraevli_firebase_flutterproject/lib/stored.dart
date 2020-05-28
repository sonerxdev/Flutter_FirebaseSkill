import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'data_holder.dart';


class ImagesScreen extends StatelessWidget {



  //burası ImageGridView arayüzü, 12 satır ve her satırda 2 grid olacak diyorum. Daha sonra içine Image ekliyorum.
  Widget makeImagesGrid() {
    return GridView.builder(
        itemCount: 12,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return ImageGridItem(index + 1);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //MakeImagesGrid fonksiyonunu çalıştırıyorum sadece
        body: Container(
          child: makeImagesGrid(),
        ));
  }
}

class ImageGridItem extends StatefulWidget {
  int _index;
  ImageGridItem(int index) {
    this._index = index;
  }
  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {
//uint8list türünde bir imageFile adında değişken oluşturdum.
  Uint8List imageFile;
//burada firebasedeki verileri çekeceğim adresi object oluşturarak yol tanımladım.
  StorageReference photosReference =
      FirebaseStorage.instance.ref().child("photos.jpg");

  getImage() { 
    //requestedIndexes benim data_holder'daki Listem. Index' e göre Data_holderdaki image map'ten görselleri çekiyor.
    if(!requestedIndexes.contains(widget._index)){
    //fotoğrafların maximum size tanımlıyorum
    int MAX_SIZE = 7 * 1024 * 1024;
    photosReference
        
        .getData(MAX_SIZE)
        .then((data) {
      this.setState(() {
        imageFile = data;

      });
      imageData.putIfAbsent(widget._index, (){
        return data;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });
    //burada uygulamayı açtığımızda her seferinde yeniden yüklenmesin diye data_holder classına imagelari yüklüyorum listview gibi.
    requestedIndexes.add(widget._index);
    }
  }
//Gridviewda ne göstereceğine karar veriyor eğer boş ise null yazdırıyorum.
  Widget decideGridTileWidget() {
    if (imageFile == null) {
      return Center(child: Text("No data"));
    } else {
      return Image.memory(imageFile, fit: BoxFit.cover,);
    }
  }

  @override
  void initState() {
    super.initState();
    if(!imageData.containsKey(widget._index)){
      getImage();
    } else{
      this.setState(() {
        imageFile=imageData[widget._index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(child: decideGridTileWidget());
  }
}
