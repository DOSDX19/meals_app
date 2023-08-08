import 'package:flutter/material.dart';

class Category {
  const Category({this.id, this.title, this.color = Colors.orange});

  final String id;
  final String title;
  final Color color;
}
