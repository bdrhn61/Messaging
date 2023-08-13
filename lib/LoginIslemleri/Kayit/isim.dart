/*
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:space/Animations/FadeAnimation.dart';
import 'package:space/LoginIslemleri/Kayit/e_mail.dart';
import 'package:space/toastSnackBar.dart';

class Isim extends StatefulWidget {
  @override
  _IsimState createState() => _IsimState();
}

class _IsimState extends State<Isim> with TickerProviderStateMixin {
  bool hideIcon = false;

  var _isimController;

  @override
  void initState() {
    _isimController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double en = MediaQuery.of(context).size.width;
    final double boy = MediaQuery.of(context).size.height;
  

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            FadeAnimation(
              0.7,
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:  EdgeInsets.only(top: boy/28, left: 2),  // 21  px
                  child: IconButton(
                    icon: Icon(Icons.chevron_left),
                    iconSize: boy/19,  //   30px
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: boy/11),  //  50  px
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(boy/28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(
                            1,
                            Text(
                              "Name",
                              style:
                                  TextStyle(color: Colors.white, fontSize: boy/11),
                            )),
                        SizedBox(
                          height: boy/38,  //  15  px
                        ),
                        FadeAnimation(
                          1.3,
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(en/32),
                                border: Border.all(
                                  color: Colors.white,
                                )),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: _isimController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: en / 16, vertical: en / 16),  //  20  px
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(.8)),
                                  hintText: "Name"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: boy/4.6,   //   120   px
                        ),
                        FadeAnimation(
                          1.6,
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      boy / 24),
                              child: IconButton(
                                onPressed: () {
                                  if (_isimController.text.trim().length > 0) {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType
                                                .rightToLeftWithFade,
                                            child:
                                                Email(_isimController.text)));
                                  }else{
                                    showInSnackBar("Please write your name", context);
                                  }
                                },
                                icon: Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                  size: boy / 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/