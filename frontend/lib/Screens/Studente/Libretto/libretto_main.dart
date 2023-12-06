import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/Common/notifications.dart';
import 'libretto_screen.dart';
import 'package:frontend/Common/page_dimensions.dart';

class Libretto2 extends StatefulWidget {
  const Libretto2({super.key});

  static PageDimensions dimensions = const PageDimensions(
      //width: 800,
      constraints: BoxConstraints(
    minWidth: 390,
    maxWidth: 600,
    minHeight: 200,
    maxHeight: 400,
  ));

  @override
  State<Libretto2> createState() => _Libretto2State();
}

class _Libretto2State extends State<Libretto2> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      LoadNewPageNotification(
        width: Libretto2.dimensions.width,
        height: Libretto2.dimensions.height,
        constraints: Libretto2.dimensions.constraints,
      ).dispatch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(child: Libretto2Component()),
    );
  }
}
