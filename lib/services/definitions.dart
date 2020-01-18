import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ocnus/services/logger.dart';

final log = getLogger();

const int globalKeyLength = 4;

Color getColorByName(String _name){
  switch (_name) {
    case 'black':
      return Colors.black;
      break;
    case 'white':
      return Colors.white;
      break;
    default:
    log.e('Unknown color $_name requested - add it to the list of supported colors?');
    throw Exception('Unknown icon name');
  }
}

Icon getIconByName(String _name, {Color color = Colors.black}){
  switch (_name) {
    case 'blender':
      return Icon(FontAwesomeIcons.blender, color: color);
      break;
    default:
    log.e('Unknown icon $_name requested - add it to the list of supported icons?');
    throw Exception('Unknown icon name');
  }
}