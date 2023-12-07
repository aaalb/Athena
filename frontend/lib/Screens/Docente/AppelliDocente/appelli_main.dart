import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/Common/notifications.dart';
import 'appelli_screen.dart';
import 'package:frontend/Common/page_dimensions.dart';

class AppelliDocente extends StatefulWidget {
  static const route = '/docente/appelli';
  const AppelliDocente({super.key});

  static PageDimensions dimensions = const PageDimensions(
      //width: 800,
      constraints: BoxConstraints(
    minWidth: 390,
    maxWidth: 600,
    minHeight: 200,
    maxHeight: 400,
  ));

  @override
  State<AppelliDocente> createState() => _Libretto2State();
}

class _Libretto2State extends State<AppelliDocente> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      LoadNewPageNotification(
        width: AppelliDocente.dimensions.width,
        height: AppelliDocente.dimensions.height,
        constraints: AppelliDocente.dimensions.constraints,
      ).dispatch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(child: AppelliDocenteComponent()),
    );
  }
}
