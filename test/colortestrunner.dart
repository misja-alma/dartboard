library colorTestRunner;

import 'package:unittest/unittest.dart';
import 'dart:io';


//Usage: useColorTestRunner(); TODO doesnt work in editor (yet?)

/// Overrides default Configuration to provide colorful command line
/// output when tests are run. Loosely based on RSpec (https://www.relishapp.com/rspec).
/// Outputs green (passing) "." and red (failing) "F" characters as tests are running. 
/// If there are failing tests, provides detailed error report in red.
/// Provides a short summary.
class ColorTestRunner extends Configuration {
  const String NEUTRAL_COLOR = "\u001b[33;34m"; // blue
  const String PASS_COLOR = "\u001b[33;32m";    // green
  const String FAIL_COLOR = "\u001b[33;31m";    // red
  const String RESET_COLOR = "\u001b[33;0m";
  const int BORDER_LENGTH = 80;

  Stopwatch stopwatch = new Stopwatch();

  void onInit() => _printResultHeader();
  void onStart() => stopwatch.start();

  void onTestResult(TestCase testCase) {
    var color = testCase.result == PASS ? PASS_COLOR : FAIL_COLOR;
    _colorPrint(color, testCase);
    currentTestCase = null;
  }

  void onDone(int passed, int failed, int errors, List<TestCase> testCases,
              String uncaughtError) {
    stopwatch.stop();

    _printFailingTestInfo(testCases);
    _printSummary(passed, failed, errors, uncaughtError);
    print("${NEUTRAL_COLOR}Total time = ${stopwatch.elapsedMilliseconds / 1000} seconds.$RESET_COLOR");
  }

  void _printFailingTestInfo(List<TestCase> testCases) {
    print(FAIL_COLOR);
    for (var testCase in testCases) {
      if (testCase.result != PASS) {
        print("${testCase.result.toUpperCase()}: ${testCase.description}");

        if (testCase.message != '') {
          print(testCase.message);
        }

        if (testCase.stackTrace != null && testCase.stackTrace != '') {
          print(testCase.stackTrace);
        }

        print(_repeatString(".", BORDER_LENGTH));
      }
    }
    print(RESET_COLOR);
  }

  void _printSummary(int passed, int failed, int errors, String uncaughtError) {
    if (_passed(failed, errors, uncaughtError)) {
      print(PASS_COLOR); 
      print("All $passed tests passed.");
    } else {
      print(FAIL_COLOR); 
      if (_noTestsFound(passed, failed, errors)) {
        print('No tests found.');
      } else if (uncaughtError != null) {
        print("Top-level uncaught error: $uncaughtError");
      } else {
        print("$passed PASSED, $failed FAILED, $errors ERRORS.");
      }
    }
  }

  bool _noTestsFound(int passed, int failed, int errors) {
    return passed == 0 && failed == 0 && errors == 0;
  }

  bool _passed(int failed, int errors, String uncaughtError) {
    return failed == 0 && errors == 0 && uncaughtError == null;
  }

  void _printResultHeader() {
    print(NEUTRAL_COLOR);
    Options options = new Options();  
    String description = "Running tests for ${options.script}";
    String frame = _repeatString("=", description.length);
    print(frame);
    print(description);
    print(frame);
    print(RESET_COLOR);
  }

  String _repeatString(String str, int times) {
    StringBuffer sb = new StringBuffer();
    for (var i = 0; i < times; i++) {
      sb.add(str);  
    }
    return sb.toString();
  }

  void _colorPrint(String color, TestCase testCase) {
    stdout.writeString("${color}${testCase.result == PASS ? '.' : 'F'}$RESET_COLOR");
  }
}

/// The function that should be called right before the tests.
void useColorTestRunner() {
  configure(new ColorTestRunner());
}
