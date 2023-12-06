import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/Common/notifications.dart';
import 'package:frontend/Common/page_dimensions.dart';
import 'package:frontend/Screens/Login/login_main.dart';

class WhiteBox extends StatefulWidget
{
  final Widget child;

  const WhiteBox({required this.child});

  @override
  State<WhiteBox> createState() => WhiteBoxState(child: child,);
}

class WhiteBoxState extends State<WhiteBox>
{
  Widget? child;
  double? width;
  double ?height;
  BoxConstraints? constraints;

  WhiteBoxState({required this.child});

  @override
  void  initState()
  {
    super.initState();

    PageDimensions dimensions = const PageDimensions
    (
      constraints: BoxConstraints.tightFor(width: 2000, height: 2000),
      height: 1000,
      width: 1000
    );
    width = dimensions.width;
    height = dimensions.height;
  }

  @override
  Widget build(BuildContext context)
  {
    return NotificationListener<LoadNewPageNotification>
    (
      onNotification: (notification)
      {
        setState(() 
        {
          constraints = notification.constraints;
          width = notification.width;
          height = notification.height;
        });
        return false;
      }, 
      child: SizedBox
      (
        //constraints: BoxConstraints(maxHeight: 2000, minHeight: 20, maxWidth: 2000, minWidth: 20),
        child: Center
        (
          //child: SingleChildScrollView
          //(
            child: Padding
            (
              padding: EdgeInsets.all(20),
              child: AnimatedContainer
              (
                //width: width,
                //height: height,
                constraints: constraints,

                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration
                (
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const
                  [
                    BoxShadow
                    (
                      offset: Offset(0.0, 3.0),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: child,
              )
            )
          //)
        )
      )
    );
  }
}

