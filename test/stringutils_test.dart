import '../common/stringutils.dart';
import '../packages/unittest/unittest.dart';

main() {
 test('Test stringToBytes', () {
   expect(stringToBytes("ABC"), equals([65, 66, 67]));
 });
 
 test('Test forceParseInt', () {
   expect(forceParseInt("300px"), equals(300));
 });
}
