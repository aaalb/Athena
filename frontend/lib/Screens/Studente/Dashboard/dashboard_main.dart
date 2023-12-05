import 'package:flutter/material.dart';
import 'package:frontend/models/AuthService.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(alignment: Alignment.center, children: <Widget>[
      Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/wallpaper.jpg"),
                  fit: BoxFit.cover))),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 700,
                width: 1500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0.0, 3.0),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/cf-logo.png',
                          height: 200,
                          width: 300,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.go('/libretto');
                                },
                                child: Column(children: [
                                  Image.asset(
                                    'images/libretto_icon.png',
                                    scale: 2,
                                  ),
                                  const Text(
                                    'Libretto',
                                    style: TextStyle(
                                      fontFamily: "SourceSansPro",
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.go('/prenotazioni');
                                },
                                child: Column(children: [
                                  Image.asset(
                                    'images/bacheca_icon.png',
                                    scale: 2,
                                  ),
                                  const Text(
                                    'Bacheca Prenotazioni',
                                    style: TextStyle(
                                      fontFamily: "SourceSansPro",
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.go('/appelli');
                                },
                                child: Column(children: [
                                  Image.asset(
                                    'images/iscrizione_icon.png',
                                    scale: 2,
                                  ),
                                  const Text(
                                    'Iscrizione Appelli',
                                    style: TextStyle(
                                      fontFamily: "SourceSansPro",
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ]),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Column(children: [
                                  Image.asset(
                                    'images/profile_icon.png',
                                    scale: 2,
                                  ),
                                  const Text(
                                    'Profilo',
                                    style: TextStyle(
                                      fontFamily: "SourceSansPro",
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ]),
                              )
                            ]
                                .map((widget) => Padding(
                                      padding: const EdgeInsets.only(left: 50),
                                      child: widget,
                                    ))
                                .toList(),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              AuthService.logout().then((value) =>
                                  (value) ? context.go('/login') : {});
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/exit.png',
                                  scale: 7,
                                  color: Colors.red,
                                ),
                                const Text(
                                  'Log Out',
                                  style: TextStyle(
                                    fontFamily: "SourceSansPro",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ))
                      ],
                    )),
              )))
    ]));
  }
}
