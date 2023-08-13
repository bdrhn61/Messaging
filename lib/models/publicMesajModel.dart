import 'package:cloud_firestore/cloud_firestore.dart';

class MesajModel {
  String mesaj;
  Timestamp date;
  
  String userID;
  String mesajId;
  String potoUrl;
  String userName;
  bool yorumVarmi;
  String unicUserName;


  MesajModel.mapNesne(Map<String, dynamic> map,String mesajid)
      : mesaj = map["mesaj"],
        date = map["date"],
        userID = map["userID"],
        yorumVarmi=map["yorumVarMi"],
        userName=map["userName"],
        potoUrl=map["photoUrl"],
        unicUserName=map["unicUserName"],
        mesajId=mesajid;

  Map<String, dynamic> nesneMap() {
    return {
      'mesaj': mesaj,
      'date': date ?? FieldValue.serverTimestamp(),
      'userID': userID,
      'photoUrl':potoUrl,
      'userName':userName,
      'unicUserName':unicUserName
    };
  }
}
