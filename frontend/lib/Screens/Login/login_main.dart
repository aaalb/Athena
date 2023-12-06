import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/Common/notifications.dart';
import 'package:frontend/Screens/Login/form.dart';
import 'package:frontend/Common/page_dimensions.dart';

class LoginPage extends StatefulWidget
{
  const LoginPage({super.key});

  static PageDimensions dimensions = const PageDimensions
  (
    width: 390,
    constraints: BoxConstraints
    (
      minWidth: 390,
      maxWidth: 600,
      minHeight: 230,
      maxHeight: 600,
    )
  );
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
{
  @override
  void initState()
  {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp)
    {
      LoadNewPageNotification
      (
        width: LoginPage.dimensions.width,
        height: LoginPage.dimensions.height,
        constraints: LoginPage.dimensions.constraints,
      ).dispatch(context);
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return const Padding
    (
      padding: EdgeInsets.fromLTRB(55, 40, 55, 40),
      child: Center(child: SingleChildScrollView(child: LoginFormComponent())),
    );
  }
}