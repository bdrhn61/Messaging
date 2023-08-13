import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginVeriTabani{

FirebaseFirestore _firebaseAuth = FirebaseFirestore.instance;


  ilkVeriTabaniOku(User kayituser) async {
     DocumentSnapshot snapShot = await FirebaseFirestore.instance
              .collection("--users")
              .doc(kayituser.uid)
              .get();
              print("Giriste veri tabani --users koleksiyonu  okundu  -------------------------");

              return snapShot;
  }

  kullaniciBilgileriniGirFirebase(User kayituser, Map<String, dynamic> kullaniciMap) async {
     print("Burası bos --users koleksiyonuna yazıldı");

            await _firebaseAuth
                .collection('--users')
                .doc(kayituser.uid)
                .set(kullaniciMap);
  }
}