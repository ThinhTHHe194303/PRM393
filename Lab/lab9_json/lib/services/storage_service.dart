
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class StorageService {
  // Get the JSON file in the application's documents directory.
  Future<File> get _file async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/products.json');
  }

  // Load products from the local JSON file.
  Future<List<dynamic>> loadData() async {
    final file = await _file;

    // Create the file with an empty list if it does not exist.
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
    }

    // Read the file contents.
    final content = await file.readAsString();

    // Return an empty list if the file contains no data.
    if (content.trim().isEmpty) {
      return [];
    }

    // Decode the JSON string into a Dart list.
    return jsonDecode(content) as List<dynamic>;
  }

  // Save products to the local JSON file.
  Future<void> saveData(List<dynamic> data) async {
    final file = await _file;
    print('JSON file path: ${file.path}');

    // Format the JSON with indentation for readability.
    final jsonString = const JsonEncoder.withIndent('  ')
        .convert(data);

    await file.writeAsString(jsonString);
  }
}
