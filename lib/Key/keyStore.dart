import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class KeySrore{
final _fbReal = FirebaseDatabase.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> keyGetir(String _onunUid) async {
     final ref = _fbReal.ref();
        DatabaseEvent _sonuc= await ref.child("public").child(_onunUid).once();
        print(_sonuc.snapshot.value.toString()+"   sonuc");
        if(_sonuc.snapshot.value!=null){
        return _sonuc.snapshot.value;
        }else
        return null;

  }
}