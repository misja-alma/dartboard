import '../common/stringutils.dart';
import '../packages/unittest/unittest.dart';

main() {
 test('Test stringToBytes', () {
   expect(stringToBytes("ABC"), equals([65, 66, 67]));
 });
}
