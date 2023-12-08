import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/Common/notifications.dart';
import 'package:frontend/Common/page_dimensions.dart';

import './appelli_screen.dart';

class Appelli extends StatefulWidget {
  const Appelli({super.key});

  static PageDimensions dimensions = const PageDimensions(
      //width: 800,
      constraints: BoxConstraints(
    minWidth: 390,
    maxWidth: 600,
    minHeight: 200,
    maxHeight: 400,
  ));

  @override
  State<Appelli> createState() => Appelli2State();
}

class Appelli2State extends State<Appelli> {
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      LoadNewPageNotification(
        width: Appelli.dimensions.width,
        height: Appelli.dimensions.height,
        constraints: Appelli.dimensions.constraints,
      ).dispatch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(child: Appelli2Component()),
    );
  }
}
