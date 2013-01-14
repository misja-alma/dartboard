import '../common/parseutils.dart';
import 'package:unittest/unittest.dart';

main() {
 test('Test parsePoint', () {
   expect(parsePoint("24"), equals(24));
   expect(parsePoint("bar"), equals(25));
   expect(parsePoint("OFF"), equals(0));
 });
 
 test('Test decodeXGCharcode', () {
   expect(decodeXGCharcode("B".charCodeAt(0)).nrCheckers, equals(2));
   expect(decodeXGCharcode("B".charCodeAt(0)).player, equals(0));
 });
}