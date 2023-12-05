import 'package:flutter/material.dart';

class LoadNewPageNotification extends Notification
{
  final double ? height;
  final double ? width;
  final BoxConstraints ? constraints;

  const LoadNewPageNotification({this.height, this.width, this.constraints});
}