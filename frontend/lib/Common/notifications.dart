import 'package:flutter/material.dart';

class LoadNewPageNotification extends Notification
{
  final double ? height;
  final double ? width;
  final BoxConstraints ? constraints;

  const LoadNewPageNotification({this.height, this.width, this.constraints});
}

class SearchQueryNotification extends Notification
{
  final String ? text;

  const SearchQueryNotification({this.text});
}

class SearchRequestedNotification extends Notification
{
  final bool ? open;

  const SearchRequestedNotification({this.open});
}