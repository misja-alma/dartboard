import "dart:io";
import "dart:isolate";
import "dart:async";

/**
 * Run through the files that end with Test.dart in this directory.
 * NOTE: Doesn't close the VM when ready ..
 */
void main() {
  ReceivePort receivePort = new ReceivePort();

  Stream<FileSystemEntity> lister = new Directory.current().list(recursive: true);
  lister.where((FileSystemEntity entity) => entity.path.endsWith("_test.dart"))
        .every(runTest);
}

void runTest(FileSystemEntity entity) {
  String path = entity.path; 
  spawnUri("file://$path");
}
