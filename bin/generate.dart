import 'package:material_theme_builder/src/parser.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    throw ArgumentError('Please provide the path of the file to parse.');
  }

  if (args.length > 2) {
    throw ArgumentError(
        'You can only pass up twwo arguments, the first is the file and the second argument is the file extension.');
  }

  if (!(isValidExtension(args.first.split('.').last) ||
      (args.length == 2 && isValidExtension(args[1])))) {
    throw ArgumentError(
        'Either the file extension was not provided or it\'s invalid\n'
        'To provide the file extension either add it to the file like \'colors.xml\' or add it after the file path like \n'
        'flutter pub run material_theme_builder:generate colors xml\n'
        'only supported arguments for the extension are \'xml\' and \'zip\'.');
  }

  String fileExtension;

  if (args.length != 1 && isValidExtension(args[1])) {
    fileExtension = args[1].toLowerCase();
  } else {
    fileExtension = args.first.split('.').last.toLowerCase();
  }
  switch (fileExtension) {
    case 'xml':
      break;
    case 'zip':
      break;
    default:
  }
  // TODO: add the generating logic here after figering out wich value goes where in theme data
}

bool isValidExtension(String type) {
  type = type.toLowerCase();
  return type == 'xml' || type == 'zip';
}
