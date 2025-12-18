import 'dart:io';

extension StringExt on String {
  /// 判断文件是否存在
  /// [return] true 存在 false 不存在
  bool get isFileExistSync {
    final file = File(this);
    final isExists = file.existsSync();
    return isExists;
  }
}
