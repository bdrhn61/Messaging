import 'package:flutter/material.dart';
class Animdeneme extends StatefulWidget {
  const Animdeneme({ required Key key }) : super(key: key);

  @override
  _AnimdenemeState createState() => _AnimdenemeState();
}

class _AnimdenemeState extends State<Animdeneme> {
  double _width=200;
  double _height=200;
  int sayac=0;
  
  double? _updateState(){
if(sayac%2==0){
    setState(() {  
          _width=200;
          _height=200;
        });
        sayac++;
}else{
  setState(() {  
          _width=0;
          _height=0;
        });
        sayac++;
}
return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children:[ 
            ElevatedButton(onPressed: () {
              _updateState();
              },
            child: Text("anim"),),
            AnimatedContainer(
            width: _width,
            height: _height,
            
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            child: Image.asset(
                  "assets/images/rightt2.png",
                  width: _width,
                  height: _height,
                ),
            
            
          ),
          ]
        ),
      ),
    );
  }
}