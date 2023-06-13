import 'package:flutter_test/flutter_test.dart';
import 'list.dart';

void main() {
  group('[utils.list]', () {
    test('splitList should split long list to sublist', () {
      List<int> longList = List.generate(19, (index) => index + 1);
      List<List<int>> subLists = longList.split(5);
      expect(subLists.length, equals(4)); // Expect 4 sub lists
      expect(subLists[0], equals([1, 2, 3, 4, 5])); // First sublist should contain [1, 2, 3, 4, 5]
      expect(subLists[1], equals([6, 7, 8, 9, 10])); // Second sublist should contain [6, 7, 8, 9, 10]
      expect(subLists[2], equals([11, 12, 13, 14, 15])); // Third sublist should contain [11, 12, 13, 14, 15]
      expect(subLists[3], equals([16, 17, 18, 19])); // Fourth sublist should contain [16, 17, 18, 19, 20]
    });
  });
}
