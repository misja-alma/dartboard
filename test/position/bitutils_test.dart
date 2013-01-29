import '../../common/position.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:unittest/unittest.dart';

main() {
  useHtmlEnhancedConfiguration();
  
 test('Test that setBit sets correct bit with specified value into specified byte', () {
   List<int> bytes = [0, 1, 2];
   
   setBit(bytes, 0, 0, 1);
   expect(bytes, equals([1, 1, 2]));
   
   setBit(bytes, 0, 0, 0);
   expect(bytes, equals([0, 1, 2]));
   
   setBit(bytes, 1, 1, 1);
   expect(bytes, equals([0, 3, 2]));
 });
 
 test('Test that bitSubString returns accumulated value of bit substring', () {
   expect(bitSubString([0, 0, 0, 0], 0, 1), equals(0));
   expect(bitSubString([1, 0, 0, 0], 0, 1), equals(1));
   expect(bitSubString([0, 1, 1, 0], 1, 3), equals(3));
 });
 
 test('Test that putIntoBitString fills bitString with bits from value', () {
   List<int> bits = [0, 0, 0, 0];
   
   putIntoBitString(bits, 1, 0, 1);
   expect(bits, equals([1, 0, 0, 0]));
   
   putIntoBitString(bits, 1, 1, 2);
   expect(bits, equals([1, 1, 0, 0]));
   
   putIntoBitString(bits, 0, 1, 2);
   expect(bits, equals([1, 0, 0, 0]));
   
   putIntoBitString(bits, 7, 1, 4);
   expect(bits, equals([1, 1, 1, 1]));
 });
}
