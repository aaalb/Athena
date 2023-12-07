import 'package:flutter/material.dart';
import 'package:frontend/Common/notifications.dart';


class TitleSearchBar extends StatefulWidget
{
  String hint;
  TitleSearchBar({Key? key, required this.hint}) : super(key: key);

  @override
  State<TitleSearchBar> createState() => TitleSearchBarState(hint: hint);
}

class TitleSearchBarState extends State<TitleSearchBar>
{
  String hint;
  bool active = false;

  IconData backIcon = Icons.arrow_circle_left_outlined;
  IconData searchIcon = Icons.search;

  bool noDataVisible = false;
  //List<dynamic> pool;
  
  TitleSearchBarState({required this.hint});

  @override
  Widget build(BuildContext context)
  {
    return AnimatedSize
    (
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
      child: Container
      (
        height: active? null : 0,
        child: Column
        (
          children: 
          [
            TextField
            (
              //controller: emailController,
              decoration: InputDecoration
              (
                hintText: hint,
                focusedBorder: OutlineInputBorder
                (
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color.fromARGB(255, 209, 67, 67), width: 3),
                ),
              ),

              onChanged: (value)
              {
                SearchQueryNotification(text: value).dispatch(context);
              }
            ),
            Divider(height: 20,),
          ]
        )
      )
    );
  }

  void setBar({required bool open})
  {
    setState(() {
      active = open;
    });
  }
}


