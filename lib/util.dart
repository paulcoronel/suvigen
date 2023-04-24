import 'dart:io';

void deleteFile(File file) {
  file.exists().then((exists) {
    if (exists) {
      try {
        file.delete();
      } on Exception catch (e, stack) {
        //print("Exception thrown inside deleteFile block. $e");
        //print(stack);
      }
    }
  });
}
