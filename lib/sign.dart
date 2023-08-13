import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:geocoding/geocoding.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;

import 'package:image_picker/image_picker.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space/BildirimGonderme/bidirimGondermeServis.dart';
import 'package:space/BildirimGonderme/notificationHandler.dart';
import 'package:space/LoginIslemleri/girVeyaKaydol.dart';
import 'package:space/LoginIslemleri/hizliGiris.dart';
import 'package:space/Messenger/mesenger.dart';
import 'package:space/Profil/benimProfilHakkinda.dart';
import 'package:space/animdeneme.dart';
import 'package:space/counterpro.dart';
import 'package:space/gpsKonum.dart';
import 'package:space/gpsKonum2.dart';
import 'package:space/Hakkimda/hakkimda.dart';
import 'package:space/models/Ben.dart';
import 'package:space/picker.dart';
import 'package:space/providerlar/adreseMesajProvider.dart';
import 'package:space/publicMesaj/adreseMesaj.dart';
import 'package:space/publicMesaj/arazlar/chipler.dart';
import 'package:space/toastSnackBar.dart';

import 'LocalVeriTabani/database_helper.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore firestoreRef = FirebaseFirestore.instance;

class SignPage extends StatefulWidget {
  @override
  SignPageState createState() => SignPageState();
}

class SignPageState extends State<SignPage> {
  /////////////////////////////////////////  Galeri değişkenleri

  //var ssProvider;
  late Ben sayfaProvideriBen;
  late AdreseMesajProvider _sayfaProviderChip;
  GpsKonum2 gpsKonum = GpsKonum2();
  late List<Placemark> placemarks;
  NotificationHandler _notificationHandler = NotificationHandler();
  BildirimGondermeServisi _bildirimGondermeServisi = BildirimGondermeServisi();
  late SharedPreferences prefs; 

  late Future<crypto.AsymmetricKeyPair> futureKeyPair;


  late crypto.AsymmetricKeyPair keyPair;
  int sayac=0;

  //DatabaseHelper _db1 = DatabaseHelper();

  @override
  initState() {
    super.initState();

    NotificationHandler().initializeFCMNotification(context);

    // "https://firebasestorage.googleapis.com/v0/b/flutterfirebase-dd58d.appspot.com/o/users%2Fccc?alt=media&token=287feebc-c2b7-4eb5-a903-44f836ad598f";
    //prefss = await SharedPreferences.getInstance ();

    // profilFotoStorageUrl=prefss.getString("profilFotoStorageUrl");
    //print(widget.gelenUrl+"-**---*-*-*-*-*-*-* gelenUrl");
  }

  @override
  void dispose() {
    super.dispose();
  }

  late Widget _form;
  @override
  Widget build(BuildContext context) {
    if (_form == null) {
      print("if in içi-----");
      // Create the form if it does not exist
      _form = _createForm(context); // Build the form
    }
    print("return------");
    return _form; // Show the form in the application
  }

  Widget _createForm(BuildContext context) {
    final double en = MediaQuery.of(context).size.width;
    final double boy = MediaQuery.of(context).size.height;
    
    print("_createForm");
    //ssProvider = Provider.of<CounterPro>(context);
    sayfaProvideriBen = Provider.of<Ben>(context, listen: false);
    _sayfaProviderChip = Provider.of<AdreseMesajProvider>(context);
    //ssProvider.urlgaleri=widget.gelenUrl;
    print("sign build");
    print(sayfaProvideriBen.userName);

    print(sayfaProvideriBen.sayfaKontroller);
    //_db1.kullaniciBilgileriOkuLokal("xD1xCQyCIYX6wsYsao18xjGz25Y2");
    return Container(
      color: Colors.black,

      /////////////////////////////////Singlescrolllll vardı
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(boy / 38)),
        child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: InkWell(
            child: Image.asset(
              "assets/images/focus.png",
              width: boy / 18.5,
              height: boy / 18.5,
            ),
            onTap: () async {
              _sayfaProviderChip.valueNullYap();
              //   print(_sayfaProviderChip.value.toString()+"---------------------------ww");
              _sayfaProviderChip.renkAyarlaNotSelectHepsi();

              _sayfaProviderChip.localAdresGeldiMiTrueYap();
              await gpsKonum.konumal();
              try {
                print(gpsKonum.locationData.latitude.toString() +
                    " ****** " +
                    gpsKonum.locationData.longitude.toString());
                await adresIslemleri(context, gpsKonum.locationData.latitude,
                    gpsKonum.locationData.longitude);
              } catch (e) {
                showInSnackBar("Failed to get current location.", context);
              }
              _sayfaProviderChip.localAdresGeldiMiFalseYap();
            },
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                //   top: boy / 20, left: en / 20, right: en / 20
                Container(
                  width: en,
                  child: Padding(
                    padding: EdgeInsets.only(top: boy / 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              bool? _chosSelect = true;
                              if (sayfaProvideriBen.hakkimdaMap["cinsiyet"] ==
                                  "kadın") {
                                _chosSelect = false;
                              } else if (sayfaProvideriBen
                                      .hakkimdaMap["cinsiyet"] ==
                                  "erkek") {
                                _chosSelect = true;
                              } else {
                                _chosSelect = null;
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Hakkimda(_chosSelect!)));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: en / 35),
                              child: Image.asset(
                                "assets/images/menu.png",
                                width: boy / 25,
                                height: boy / 25,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Mesenger()));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: en / 35),
                              child: Image.asset(
                                "assets/images/mail-inbox-app.png",
                                width: boy / 21,
                                height: boy / 21,
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),

                SizedBox(
                  height: boy / 10,
                ),

                Center(
                  child: ProfilResmi(),
                ),

                // Text(widget.gelenIsim),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.only(
                        top: boy / 25,
                      ),
                      child: Text(
                        sayfaProvideriBen.userName,
                        textScaleFactor: en / (en / 1.1),
                        style: GoogleFonts.montserrat(
                            letterSpacing: 1, fontWeight: FontWeight.bold),
                      )),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.only(
                        
                      ),
                      child: Text(
                      (sayfaProvideriBen.unicUserName==null||sayfaProvideriBen.unicUserName == "")?"":"@"+sayfaProvideriBen.unicUserName  ,
                        textScaleFactor: 0.9,
                        style: GoogleFonts.montserrat(
                             color: Color.fromARGB(255, 174, 153, 90),
                             fontWeight: FontWeight.normal),
                      )),
                ),
/*
                Padding(
                  padding: EdgeInsets.only(left: en / 8, top: 1),
                  child: Center(
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/ok.png",
                          width: en / 20,
                          height: boy / 20,
                        ),
                        Text(
                          "   " + sayfaProvideriBen.begeniSayisi.toString(),
                        ),
                      ],
                    ),
                  ),
                ),
*/

                SizedBox(
                  height: boy / 60,
                ),
                ChiplerSgn(),
/*
                ElevatedButton(
                  onPressed: () async {

                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Animdeneme()));

                 //   prefs = await SharedPreferences.getInstance();
                 // String priv=  prefs.getString(_auth.currentUser.uid+"private");

                //  if(priv==null){
                //    print("null");
                //  }else{
               //     print(priv);
               //   }
                    
/*
sayac++;
                  
                    futureKeyPair = getKeyPair();
                    keyPair = await futureKeyPair;
                   // print(keyPair);
                   

                        String a =
                        helper.encodePrivateKeyToPemPKCS1(keyPair.privateKey);
                      //  print("privat  : "+a);
                        print("+++--------------------++");
                        String b =
                        helper.encodePublicKeyToPemPKCS1(keyPair.publicKey);
                        print(sayac.toString()+ "  public  : "+b);
                       String sifreliMetin= encrypt("hello world",keyPair.publicKey);
                       String duzMetin= decrypt(sifreliMetin,keyPair.privateKey);
                  //     print("sifreli metin  :  "+sifreliMetin);
                 //      print("düz  metin  :  "+duzMetin);
                    var  pub=   helper.parsePublicKeyFromPem(b);
                       String s =
                        helper.encodePublicKeyToPemPKCS1(pub);
                    //    print("public  : "+s);


                //    print("private  :"+a + "  private");
                //    print("public  :"+b + "  private");

                
                    */

                  },
                  child: Text("ww"),
                ),
*/
                // BenimProfilHakkinda(sayfaProvideriBen),

                // Text(ssProvider.sayac.toString()),  //  ÖNEMLİ OLABİLİR

                //  *-*-*-*-*-  TRANSECTİON  ÖRNEK  *-*-*-*-*-*-*-*-*-*
                /*
                    ElevatedButton(
                      onPressed: () async {
                        var veritabani = FirebaseFirestore.instance;
                        var temp = await veritabani
                            .collection("Türkiye")
                            .doc("dwQYFmI1pP34dh2QixaW")
                            .collection("Begenenler")
                            .doc("hgf")
                            .get()
                            .then((value) async {
                          print(value.data().toString() + "--");
                          if (value.data() == null) {
                            DocumentReference docRef = veritabani
                                .collection("--users")
                                .doc("s8neXJ54ZUfBrdPuYz2lAMbsS9o1");
                            print("1");
                            veritabani.runTransaction((Transaction transaction) async {
                              await transaction.get(docRef).then((value) async {
                                print("2");
                                if (value.exists) {
                                  print("3");

                                  await transaction.update(docRef, {
                                    "begeniSayisi": (value.data()["begeniSayisi"] + 1)
                                  });
                                  print("4");
                                }
                              });
                            });
                          }
                        });
                      },

                      child: Text('aaaaaaaaaa'),
                    ),
              */

                /*
                    ElevatedButton(
                      onPressed: loadAssets,
                     

                      child: Text('galeri'),
                    ),
                    
                    */

                /*
                    -*-*-*-*-*-  EN YAKINDAKINE MESAJ ATMA  -**-*-*-*-*-*-*-*-*
                    ElevatedButton(
                      onPressed: enyakin,

                      child: Text('enyakin'),
                    ),
                    */
              ],
            ),
          ),
        ),
      ),
    );
  }

  late RsaKeyHelper helper;
  

  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
      getKeyPair() {
    helper = RsaKeyHelper();

    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }

/*
  List<Asset> resultList;
  Future<void> loadAssets() async {
    resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    //setState(()  async {
    print("tıklandiiiiiiiiiiii");

    await resimVeriTabaniYukle();
    images = resultList;

    _error = error;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignPage()));
    // });
  }
  
  resimVeriTabaniYukle() async {
    FirebaseFirestore _veriTabani = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    //DatabaseHelper _db1 = DatabaseHelper();
     Foto foto = Foto();
    ByteData byteData = await resultList[0]
        .getByteData(); // requestOriginal is being deprecated
    List<int> imageData = byteData.buffer.asUint8List();

    var ref =
        FirebaseStorage.instance.ref("users").child(_auth.currentUser.uid);
    var uploadTask =
        await (ref.putData(imageData)).whenComplete(() => ref.getDownloadURL());
    String urlgaleri = await ref.getDownloadURL();

    print(urlgaleri.toString() + "------------");

    if (urlgaleri != null) {
      await _veriTabani
          .collection("--users")
          .doc(_auth.currentUser.uid)
          .set({"photoUrl": urlgaleri}, SetOptions(merge: true));
      // Uint8List _fotoByte = await foto.urlToBytes(urlgaleri);

      //  await _db1.kullaniciFotoEkle(_auth.currentUser.uid, _fotoByte, urlgaleri);

      // sayfaProvideriBen.photoByteLokalSet(_fotoByte);

      sayfaProvideriBen.photoUrlSet(urlgaleri);
    }
  }
*/

  Map<String, dynamic> kul = {
    'userID': "uid",
    'userName': "userName",
    'eMail': "email",
    'sifre': "sifre"
  };

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        tempPath + '/file_01.png'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  haritayaDokundum() {
    // _sayfaProviderChip.haritayaDokun(placemarks[0].country.toString() +
    //    "  " +
    //    placemarks[0].isoCountryCode.toString());

    _sayfaProviderChip.adresGir(
        placemarks[0].country.toString(),
        placemarks[0].administrativeArea.toString(),
        placemarks[0].subAdministrativeArea.toString(),
        placemarks[0].street.toString(),
        placemarks[0].thoroughfare.toString());
  }

  adresIslemleri(BuildContext context, double? lat, double? lang) async {
    // print(lat.toString()+" ******** "+lang.toString());
    try {
      placemarks = await placemarkFromCoordinates(lat!, lang!);
      haritayaDokundum();
    } catch (e) {
      
     //  showInSnackBar(e.code, context);
    }
  }

/*
  void enyakin() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<EnYakinaMesajProvider>(
                  create: (_) => EnYakinaMesajProvider(0, 0),
                  child: EnYakindakiler(),
                )));
  }

  */

}

class ProfilResmi extends StatelessWidget {
  late Ben sayfaProvideriBen;
  final double resimSize = 50;

  Widget build(BuildContext context) {
    print("profil build");
    sayfaProvideriBen = Provider.of<Ben>(context, listen: true);
    final double en = MediaQuery.of(context).size.width;
    final double boy = MediaQuery.of(context).size.height;

    return Container(
      // top: boy / 40,

      child: InkWell(
        onTap: () => {
          neverSatisfied(context),
        },
        child: profilResmi(boy),
      ),
    );
  }

  profilResmi(double boy) {
    //print(sayfaProvideriBen.photoUrl + "   ---sayfaProvideriBen.photoUrl");
    if (sayfaProvideriBen.photoUrl != null &&
        sayfaProvideriBen.photoUrl != 'null') {
      return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(boy / 15),
            topRight: Radius.circular(boy / 15),
            bottomLeft: Radius.circular(boy / 15),
            bottomRight: Radius.circular(boy / 15)),
        child: _resim(boy),

        /*
        
        */
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(boy / 15),
            topRight: Radius.circular(boy / 15),
            bottomLeft: Radius.circular(boy / 15),
            bottomRight: Radius.circular(boy / 15)),
        child: Image.asset(
          "assets/images/userprofil2.png", // sayfaProvideriBen.photoUrl,
          width: boy / 6,
          height: boy / 6,
          //MediaQuery.of(context).size.width -
          //MediaQuery.of(context).size.width / 1.7,
          fit: BoxFit.fill,
        ),
      );
    }
  }

  var aa;
  void neverSatisfied(BuildContext cntx) {
    var en = MediaQuery.of(cntx).size.width;
    print(en / 30);
    showGeneralDialog(
        context: cntx,
        pageBuilder: (cntx, anim1, anim2) {},
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        barrierLabel: 'aaaaa',
        transitionBuilder: (cntx, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;

          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: anim1.value,
              child: AlertDialog(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      // side:  BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(16.0)),
                  content: Builder(
                    builder: (cntx) {
                      double height = MediaQuery.of(cntx).size.height;
                      double width = MediaQuery.of(cntx).size.width;
                      return Container(
                        height: height / 4,
                        width: width / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(cntx).pop();
                                galeriyeeris(cntx);
                              },
                              child: Image.asset(
                                "assets/images/gallery.png",
                                width: width / 6,
                                height: width / 6,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: width / 30,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(cntx).pop();
                                camerayaEris();
                              },
                              child: Image.asset(
                                "assets/images/camera.png",
                                width: width / 6,
                                height: width / 6,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )

              
                  ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 450));
  }

  void galeriyeeris(BuildContext ctnx) async {
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///      GALERİYE  ERİŞME KODLARIIIIIIIII

/*
    Navigator.of(ctnx, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<CounterPro>(
              create: (_) => CounterPro(1, false, 0),
              child: PhotoPicker(),
            )));

            */
  }

  camerayaEris() async {
    final imagePicker = ImagePicker();

    final image = await imagePicker.getImage(source: ImageSource.camera);
    if (image != null) {
      var ref =
          FirebaseStorage.instance.ref("users").child(_auth.currentUser!.uid);

      print(image.path + "   path");

      var upload = (await ref.putFile(File(image.path)));

      String urlcamera = await ref.getDownloadURL();

      FirebaseFirestore _veriTabani = FirebaseFirestore.instance;
      if (urlcamera != null) {
        await _veriTabani
            .collection("--users")
            .doc(_auth.currentUser?.uid)
            .set({"photoUrl": urlcamera}, SetOptions(merge: true));

        // _db1.yerOkuHepsini();
        // print( sayfaProvideriBen.benMapGetir().toString()+"-----------*********************-*-*-*-");
        //   print("veri tabanına kaydedildi" + sayfaProvideriBen.userid.toString());
        //  print("user id" + sayfaProvideriBen.userid.toString());
        //  print("user name" + sayfaProvideriBen.userName.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("benimPhotoUrl", urlcamera);

        sayfaProvideriBen.photoUrlSet(urlcamera);

        print(urlcamera.toString() + "*******");
      }
    }
  }

  _resim(double boy) {
    try {
      return Image.network(
        sayfaProvideriBen.photoUrl,
        width: boy / 6,
        height: boy / 6,
        fit: BoxFit.fill,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace stackTrace) {
          return Container(
            width: boy / 6,
            height: boy / 6,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          );
        },
        loadingBuilder:
            (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Container(
              width: boy / 6,
              height: boy / 6,
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      return Text("Loading ..");
    }
  }
}
