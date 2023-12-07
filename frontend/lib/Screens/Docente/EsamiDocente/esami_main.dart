import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/Common/notifications.dart';
import 'esami_screen.dart';
import 'package:frontend/Common/page_dimensions.dart';

class EsamiDocente extends StatefulWidget {
  static const route = '/docente/esami';
  const EsamiDocente({super.key});

  static PageDimensions dimensions = const PageDimensions(
      constraints: BoxConstraints(
    minWidth: 390,
    maxWidth: 600,
    minHeight: 200,
    maxHeight: 600,
  ));

  @override
  State<EsamiDocente> createState() => _Libretto2State();
}

class _Libretto2State extends State<EsamiDocente> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      LoadNewPageNotification(
        width: EsamiDocente.dimensions.width,
        height: EsamiDocente.dimensions.height,
        constraints: EsamiDocente.dimensions.constraints,
      ).dispatch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(child: EsamiDocenteComponent()),
    );
  }
}
