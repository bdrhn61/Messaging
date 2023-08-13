import 'package:flutter/material.dart';
import 'package:space/LoginIslemleri/login_islemleri.dart';

class Passs extends StatefulWidget {
  String gelenEmail;
  String gelenIsim;
  Passs(this.gelenEmail, this.gelenIsim);
  @override
  _PasssState createState() => _PasssState();
}

class _PasssState extends State<Passs> {
  bool _isVisible = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  LoginIslemleri loginIslemleri = new LoginIslemleri();
  TextEditingController  _passwordController1 = TextEditingController();
  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final harficRegex = RegExp(r'[a-z]');
    final buyukHarficRegex = RegExp(r'[A-Z]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) _isPasswordEightCharacters = true;

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password) &&
          harficRegex.hasMatch(password) &&
          buyukHarficRegex.hasMatch(password)) _hasPasswordOneNumber  = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double en = MediaQuery.of(context).size.width;
    final double boy = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:  EdgeInsets.only(top: boy/28, left: 2),  //   20  px
                child: IconButton(
                  icon: Icon(Icons.chevron_left),
                  iconSize: boy/19,  //  30  px
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: en/16, vertical: en/32),   //  20   ,   10
              child: Text(
                "Password",
                style: TextStyle(color: Colors.white, fontSize: boy / 11),  //   50
              ),
            ),
            SizedBox(
              height: boy/14,
            ),
          
            Padding(
              padding: EdgeInsets.symmetric(horizontal: en/16, vertical: en/32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(en/32),
                    border: Border.all(
                      color: Colors.white,
                    )),
                child: TextField(
                  controller: _passwordController1,
                  style: TextStyle(color: Colors.white),
                  onChanged: (password) => onPasswordChanged(password),
                  obscureText: !_isVisible,
                  decoration: InputDecoration(
                    
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                      icon: _isVisible
                          ? Icon(
                              Icons.visibility,
                              color: Colors.grey,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            ),
                    ),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: en/16, vertical: en/16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(en/64)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0)),
                      borderRadius: BorderRadius.all(Radius.circular(en/64)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: boy/19,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: en/16,
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: en/16,
                    height: en/16,
                    decoration: BoxDecoration(
                        color: _isPasswordEightCharacters
                            ? Colors.green
                            : Colors.transparent,
                        border: _isPasswordEightCharacters
                            ? Border.all(color: Colors.transparent)
                            : Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(boy / 11)),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: boy / 38,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: en/32,
                  ),
                  Text(
                    "Contains at least 8 characters",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            SizedBox(
              height: boy/55,  //  10
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: en/16,
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: boy/28,
                    height: boy/28,
                    decoration: BoxDecoration(
                        color: _hasPasswordOneNumber
                            ? Colors.green
                            : Colors.transparent,
                        border: _hasPasswordOneNumber
                            ? Border.all(color: Colors.transparent)
                            : Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(boy / 11)),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: boy / 38,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: en/32,
                  ),
                  Expanded(
                    child: Text(
                      "Number must contain uppercase and lowercase letters",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: boy / 11,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:en/16, vertical: en/16),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(en/32),
                    border: Border.all(
                      color: Colors.white,
                    )),
                child: MaterialButton(
                  height: boy/14,  //   40  px
                  minWidth: double.infinity,
                  onPressed: () {
                    if (_hasPasswordOneNumber   &&
                         _isPasswordEightCharacters)
                      loginIslemleri.esKullaniciOlustur(
                          widget.gelenIsim,
                          widget.gelenEmail,
                          _passwordController1.text,
                          _passwordController1.text,
                          context);
                  },
                  child: Text(
                    "CREATE ACCOUNT",
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(en/64)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
