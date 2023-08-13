import 'package:flutter/material.dart';

class MesajCubuguNotification extends StatefulWidget {
  const MesajCubuguNotification({required Key key}) : super(key: key);

  @override
  _MesajCubuguNotificationState createState() =>
      _MesajCubuguNotificationState();
}

class _MesajCubuguNotificationState extends State<MesajCubuguNotification> {
  late double en;
  late Color renk;
  late String ikonButonAdres;
  @override
  void initState() {
    ikonButonAdres = "assets/images/notification.png";
    renk = Colors.white;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    en = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(right: en / 20),
      child: Container(
        child: InkWell(
          onTap: () async {
            setState(() {
             ikonRenkDegis() ;
            });
          },
          child: Image.asset(
           ikonButonAdres,
            width: en / 10.1,
          //  height: en / 9,
            
          ),
        ),
      ),
    );
  }

  void ikonRenkDegis() {
    print(ikonButonAdres.toString());
    if (renk == Colors.yellow) {
      renk = Colors.white;
      ikonButonAdres = "assets/images/notification.png";
      // ntf.fcm.unsubscribeFromTopic(adrss);
      print("beyaz");
    } else if (renk == Colors.white) {
      renk = Colors.yellow;
      ikonButonAdres = "assets/images/notification1.png";
      print("sarı");
    }
  }
}
