import 'dart:io';
import 'dart:typed_data';

Future<void> saveFile(Uint8List bytes) async {
  final file = File('Download/');
  await file.writeAsBytes(bytes);
}
