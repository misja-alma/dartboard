import "dart:io";
import "dart:isolate";

/**
 * Run through the files that end with Test.dart in this directory.
 * NOTE: Doesn't close the VM when ready ..
 */
void main() {
  ReceivePort receivePort = new ReceivePort();

  var lister = new Directory.current().list(recursive: true);
  lister.onFile = (String path) {
    if (path.endsWith("_test.dart")) {
      SendPort sendPort = spawnUri("file://$path");
    }
  };
}
