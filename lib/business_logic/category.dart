import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:oknos/services/local_id_generator.dart';

class Category extends Equatable{
  final bool active;
  final String id, title, location;
  final Color color;
  final DateTime _created, _modified;

  Category(
    {
      this.color,
      this.title = '',
      this.location = '',
      this.active = true,
      String note,
      String id,
      DateTime created, 
      DateTime modified,
    }) : this.id = id ?? LocalIdGenerator().getId(), 
    this._created = created ?? DateTime.now(),
    this._modified = modified ?? DateTime.now();

  @override
  List<Object> get props => [id];
}