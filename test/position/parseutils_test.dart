import '../../common/position.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:unittest/unittest.dart';

main() {
  useHtmlEnhancedConfiguration();
  
 test('Test parsePoint', () {
   expect(parsePoint("24"), equals(24));
   expect(parsePoint("bar"), equals(25));
   expect(parsePoint("OFF"), equals(0));
 });
 
 test('Test decodeXGCharcode', () {
   expect(decodeXGCharcode("B".codeUnitAt(0)).nrCheckers, equals(2));
   expect(decodeXGCharcode("B".codeUnitAt(0)).player, equals(0));
 });
}