import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:oknos/services/local_id_generator.dart';

class Category{
  bool active;
  String id, title, location;
  Color color;
  DateTime created, modified;

  // Two categories are equal if they have the same id
  @override
  bool operator ==(Object other) => other is Category && other.id == id;

  @override
  int get hashCode => id.hashCode;  

  Category(
    { 
      @required this.color,
      @required this.title,
      @required this.location,
      this.active = true,
      String id,
      DateTime created, 
      DateTime modified,
    }) : this.id = id ?? LocalIdGenerator().getId(), 
    this.created = created ?? DateTime.now(),
    this.modified = modified ?? DateTime.now();

  @override
  List<Object> get props => [active, id, title, location, color, created, modified];
}