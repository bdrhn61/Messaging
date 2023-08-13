import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space/models/Ben.dart';
import 'package:space/publicMesaj/adreseMesaj.dart';
import 'package:space/toastSnackBar.dart';

class HakkimdaVt {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore veritabani = FirebaseFirestore.instance;
  Map<String, String> hakkimdaMap = {
    "hakkimda": "",
    "cinsiyet": "",
    "yas": "",
    "boy": "",
    "ilgi_Alanlari": "",
    "egitim": "",
    "is": "",
    "İnstagram": "",
    "twitter": "",
    "snapchat": "",
    "youtube": ""
  };
  

  girisiOnayla(Map<String, String> _info, List<String> _infoKey) async {
    await veritabani
        .collection("--usersInfo")
        .doc(_auth.currentUser.uid)
        .set(
          _info,
          SetOptions(merge: true),
        )
        .whenComplete(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      for (int i = 0; i < _infoKey.length; i++) {
        print(i.toString());
        print(_info[_infoKey[i]].toString() + "yyyy");
        await prefs.setString(_infoKey[i], _info[_infoKey[i]]);
      }
    });
  }

  degisiklikYap(Map<String, String> _info, List<String> anahtar,
      List<String> deger) async {
    await veritabani
        .collection("--usersInfo")
        .doc(_auth.currentUser.uid)
        .set(
          _info,
          SetOptions(merge: true),
        )
        .whenComplete(() async {
      print("firabaseye yazıldı");
      SharedPreferences prefs = await SharedPreferences.getInstance();

      for (int i = 0; i < anahtar.length; i++) {
        await prefs.setString(anahtar[i], deger[i]);
      }
      print("lokale yazıldı");
    });
  }

  Future<DocumentSnapshot> vTokuIlk() async {
    DocumentSnapshot okunanDeger;
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore veritabani = FirebaseFirestore.instance;
    DocumentSnapshot snapShot = await veritabani
        .collection("--usersInfo")
        .doc(_auth.currentUser.uid)
        .get();

    return snapShot;

    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for(int i=0;i<_infoKey.length;i++){
    prefs.getString(_infoKey[i]);
    }
    */
  }

  vTYazIlk() async {
    DocumentSnapshot okunanDeger;
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore veritabani = FirebaseFirestore.instance;
    await veritabani
        .collection("--usersInfo")
        .doc(_auth.currentUser.uid)
        .set(hakkimdaMap, SetOptions(merge: true));

    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for(int i=0;i<_infoKey.length;i++){
    prefs.getString(_infoKey[i]);
    }
    */
  }
   Future<bool> kullaniciAdiniVTyeYaz(String text,context) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     Ben sayfaProvideriBen = Provider.of<Ben>(context, listen: false);
    
    var kullaniciAdiVarMi= await veritabani.collection("--users").where("unicUserName",isEqualTo: text).limit(1).get();
    if(kullaniciAdiVarMi.size==0){
      
      await veritabani.collection("--users").doc(_auth.currentUser.uid).set({"unicUserName":text},SetOptions(merge: true));
      await prefs.setString("unicUserName", text);
      sayfaProvideriBen.unicUserNameSet(text);
       showInSnackBar("Ok", context);
       return true;
    }else if(kullaniciAdiVarMi.size>0){
      if(kullaniciAdiVarMi.docs[0].id==_auth.currentUser.uid){
        await prefs.setString("unicUserName", text);
      sayfaProvideriBen.unicUserNameSet(text);
      showInSnackBar("Ok", context);
      return true;
      }else{
       showInSnackBar("This username is used", context);
       return false;
      }
      
    }
    print(kullaniciAdiVarMi.size.toString()+"  !!!!!!!!!");

    // veritabani.collection("--users").doc(_auth.currentUser.uid).set({"unicUserName":text},SetOptions(merge: true));
    
  }
}
