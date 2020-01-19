import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'logger.dart';

final _log = getLogger();

/// Length of the keys which are menat for human consumption
const int globalKeyLength = 6;

/// Minimum length of any rental
const Duration minimumRentalPeriod = Duration(days: 1);

/// List of icons available within the app
const List<String> availableIcons = ['blender', 'yinYang'];

/// List of colors available within the app
const List<String> availableColors = ['black', 'white'];

/// Retrieve a color by a name-string
Color getColorByName(String _name) {
  switch (_name) {
    case 'black':
      return Colors.black;
      break;
    case 'white':
      return Colors.white;
      break;
    default:
      _log.e('Unknown color $_name requested - '
          'add it to the list of supported colors?');
      throw Exception('Unknown icon name');
  }
}

/// Retrieve an icon by a name-string
Icon getIconByName(String _name, {Color color = Colors.black}) {
  switch (_name) {
    case 'blender':
      return Icon(FontAwesomeIcons.blender, color: color);
      break;
    case 'yinYang':
      return Icon(FontAwesomeIcons.yinYang, color: color);
      break;
    default:
      _log.e('Unknown icon $_name requested - '
          'add it to the list of supported icons?');
      throw Exception('Unknown icon name');
  }
}
