import 'dart:io';

extension StringExt on String {
  bool get isFileExistSync {
    final file = File(this);
    final isExists = file.existsSync();
    return isExists;
  }
}
