import 'package:flutter/material.dart';
  import 'package:flutter/animation.dart';
  
  class LikeAnimation extends StatefulWidget {
    AnimationController controller;
    var waveEffectOpacity;
    LikeAnimationState createState() => LikeAnimationState();
  }
  
  class LikeAnimationState extends State<LikeAnimation> with TickerProviderStateMixin {
  
    Animation<double> animation;
    
    initState() {
      super.initState();
      print("likeeeeeee");
      widget.controller = AnimationController(
          duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1)..repeat(reverse:true);
      animation = CurvedAnimation(parent: widget.controller, curve: Curves.fastOutSlowIn);
  
      widget.controller.forward();

     widget.waveEffectOpacity = TweenSequence(
  <TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      weight: 60.0,
    ),
    TweenSequenceItem<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      weight: 40.0,
    ),
  ],
).animate(
  CurvedAnimation(
    parent: widget.controller,
    curve: Interval(0.2, 0.7, curve: Curves.easeInOut),
  ),
);
    }
  
    @override
    dispose() {
      widget.controller.dispose();
      super.dispose();
    }
  
    Widget build(BuildContext context) {
     print("like widgettttt");
      return AnimatedBuilder(
    animation: widget.controller,
    builder: (BuildContext context, Widget child) {
      return Align(
        alignment: Alignment.center,
        child: Opacity(
          opacity: widget.waveEffectOpacity.value,
          child: Container(
           // height: _waveEffectSize.value,
          //  width: _waveEffectSize.value,
            child: FlutterLogo(size: 20,),
          ),

        ),
      );
    });
    }

    animbasla(){
      
 widget.waveEffectOpacity = TweenSequence(
  <TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      weight: 60.0,
    ),
    TweenSequenceItem<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      weight: 40.0,
    ),
  ],
).animate(
  CurvedAnimation(
    parent: widget.controller,
    curve: Interval(0.2, 0.7, curve: Curves.easeInOut),
  ),
);
    }
  }
  
