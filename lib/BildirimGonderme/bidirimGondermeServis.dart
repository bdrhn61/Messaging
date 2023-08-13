import 'package:http/http.dart' as http;

class BildirimGondermeServisi {
  
    bildirimGonder(String token, String baslik,String aciklama,String bildirimGondereninIdsi,String adress) async{
    String myUri = "https://fcm.googleapis.com/fcm/send";  
    Uri endURL = Uri.parse(myUri);
    String firebaseKey =
        "AAAADA3tAHs:APA91bFK2FWOCcwZJRchwOk8G7US_N3mpsZ89dLZmxKBK73n_YODh2Zr9qxenT9Y8zbzQ7dBs9KyX9w90ONA7Wpj-ZzaK5STLxTvE6mGE2PLazyDlvrQhJ6t5u-awK3ka-dFctY0WS-7";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$firebaseKey",
    };
    String json =
        '{"to" : "$token","data" : {"title" : "$baslik","body":"$aciklama","id":"$bildirimGondereninIdsi","adress":"$adress","mekan":"1"}}';

      http.Response response= await  http.post(endURL,headers: headers,body: json);

      if(response.statusCode==200)
      print("islem basarili");
      else
      print("basarısız");//+response.statusCode.toString());
  }

  ozelBildirimGonder(String token, String baslik,String aciklama,String bildirimGondereninIdsi,String adress,String onunPhotoUrl) async{
    String myUri = "https://fcm.googleapis.com/fcm/send";  
    Uri endURL = Uri.parse(myUri);

    String firebaseKey =
        "AAAADA3tAHs:APA91bFK2FWOCcwZJRchwOk8G7US_N3mpsZ89dLZmxKBK73n_YODh2Zr9qxenT9Y8zbzQ7dBs9KyX9w90ONA7Wpj-ZzaK5STLxTvE6mGE2PLazyDlvrQhJ6t5u-awK3ka-dFctY0WS-7";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$firebaseKey",
    };
    String json =
        '{"to" : "$token","data" : {"title" : "$baslik","body":"$aciklama","id":"$bildirimGondereninIdsi","adress":"$adress","mekan":"2","onunPhotoUrl":"$onunPhotoUrl"}}';

      http.Response response= await  http.post(endURL,headers: headers,body: json);

      if(response.statusCode==200)
      print("islem basarili");
      else
      print("basarisiz");//+response.statusCode.toString());
  }
}
