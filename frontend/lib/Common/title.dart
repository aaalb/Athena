import 'package:flutter/material.dart';
import 'package:frontend/Common/notifications.dart';
import 'package:frontend/Common/search.dart';
import 'package:go_router/go_router.dart';


class WindowTitle extends StatefulWidget
{
  String title;
  WindowTitle({required this.title});

  @override
  State<WindowTitle> createState() => WindowTitleState(title: title);
}

class WindowTitleState extends State<WindowTitle>
{
  static GlobalKey<TitleSearchBarState> searchBarKey = GlobalKey<TitleSearchBarState>();

  String title;
  IconData backIcon = Icons.arrow_circle_left_outlined;
  IconData searchIcon = Icons.search;
  
  WindowTitleState({required this.title});

  @override
  Widget build(BuildContext context)
  {
    return Row
    (
      children: 
      [
        Align
        (
          alignment: Alignment.centerRight,
          child: InkWell
          (
            child: Icon
            (
              backIcon, 
              color: Color.fromARGB(255, 209, 67, 67),
              size: 40,
            ),
            onTap: () {
              //context.go("/studente");
              context.pop();
            },
            onHover: (hovered)
            {
              setState(() {
                backIcon = hovered ? Icons.arrow_circle_left_rounded : Icons.arrow_circle_left_outlined;
              });
            },
          )
        ),
        
        Expanded
        (
          child: Align
          (
            alignment: Alignment.center,
            child: Text(title,style: TextStyle
            (
              color: Color.fromARGB(255, 209, 67, 67),
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.w600,
              fontSize: 44,
            ),),
          )
        ),

        Align
        (
          alignment: Alignment.centerLeft,
          child: InkWell
          (
            child: Icon
            (
              searchIcon, 
              color: Color.fromARGB(255, 209, 67, 67),
              size: 40,
            ),
            onTap: () {
              setState(() 
              {
                TitleSearchBarState? searchBarState = searchBarKey.currentState;
                if(searchIcon == Icons.search)
                {
                  searchIcon = Icons.search_off;
                  if(searchBarState != null)
                  {
                    searchBarState.setBar(open: true);
                  }
                }
                else
                {
                  searchIcon = Icons.search;
                  if(searchBarState != null)
                  {
                    searchBarState.setBar(open: false);
                  }
                  SearchRequestedNotification(open: false).dispatch(context);
                }
              });
            },
          )
        ),
      ],
    );
  }
}


