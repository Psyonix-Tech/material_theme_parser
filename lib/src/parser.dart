import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'model.dart';
import 'package:xml2json/xml2json.dart';

class MaterialThemeBuilder {
  const MaterialThemeBuilder._();
  static MaterialThemeColors themeColorsFromZipFile(Uint8List bytes,
          {String? password}) =>
      themeColorsFromXmlString(
          _extractXmlFromZipFile(bytes, password: password));

  static MaterialThemeColors themeColorsFromXmlFile(Uint8List bytes) =>
      themeColorsFromXmlString(String.fromCharCodes(bytes));

  static MaterialThemeColors themeColorsFromXmlString(String xml) {
    String json = _convertXmlToJson(xml);
    return _jsonToModel(json);
  }

  static String _extractXmlFromZipFile(Uint8List bytes, {String? password}) {
    // Decode the Zip file
    Archive archive = ZipDecoder().decodeBytes(bytes, password: password);
    assert(
        archive.files
                .where((element) =>
                    element.isFile == false &&
                    element.name == 'material-theme/')
                .length ==
            1,
        'The compressed file doesn\'t contain the main \'material-theme\' directory.');
    assert(
        archive.files
                .where((element) =>
                    element.isFile == true &&
                    element.name == 'material-theme/values/colors.xml')
                .length ==
            1,
        'The compressed file doesn\'t contain the main \'material-theme/material-theme/values/colors.xml\' colors file.');

    final ArchiveFile colorsFile = archive.files.singleWhere((element) =>
        element.isFile == true &&
        element.name == 'material-theme/values/colors.xml');
    colorsFile.decompress();
    return String.fromCharCodes(colorsFile.content);
  }

  static String _convertXmlToJson(String xml) {
    Xml2Json transformer = Xml2Json();
    transformer.parse(xml);
    return transformer.toBadgerfish();
  }

  static MaterialThemeColors _jsonToModel(String jsonString) {
    Map<String, dynamic> colorsMap = json.decode(jsonString);
    List<MapEntry<String, int>> entries =
        (colorsMap['resources']['color'] as List)
            .map<MapEntry<String, int>>((map) {
      return MapEntry<String, int>(map['@name'], _parseHex(map['\$']));
    }).toList();
    return MaterialThemeColors.fromJson(Map<String, int>.fromEntries(entries));
  }

  static int _parseHex(String hex) {
    return int.parse(hex.replaceAll('#', '0xff'));
  }
}
