import 'package:flutter/material.dart';

class ShoeModel {
  final int id;
  final String name;
  final String imgPath;
  final String description;
  final double price;
  final Color color;
  final bool isFavorite;

  ShoeModel({
    required this.id,
    required this.name,
    required this.imgPath,
    required this.description,
    required this.price,
    this.color = Colors.blue,
    this.isFavorite = false,
  });
}
