import '../common/listutils.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

main() {
  
 test('Test stringToBytes', () {
   expect(stringToBytes("ABC"), equals([65, 66, 67]));
 });
 
 test('Test forceParseInt', () {
   expect(forceParseInt("300px"), equals(300));
 });
}
