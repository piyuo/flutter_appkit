// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import 'date_range.dart';

void main() {
  group('[utils/date_range]', () {
    test('isSame should return true for identical DateRange instances', () {
      final fromDate = DateTime(2023, 1, 1);
      final toDate = DateTime(2023, 12, 31);

      final range1 = DateRange(fromDate: fromDate, toDate: toDate);
      final range2 = DateRange(fromDate: fromDate, toDate: toDate);

      expect(range1.isSame(range2), true);
    });

    test('isSame should return false for different DateRange instances', () {
      final fromDate1 = DateTime(2023, 1, 1);
      final toDate1 = DateTime(2023, 12, 31);

      final fromDate2 = DateTime(2023, 2, 1);
      final toDate2 = DateTime(2023, 2, 28);

      final range1 = DateRange(fromDate: fromDate1, toDate: toDate1);
      final range2 = DateRange(fromDate: fromDate2, toDate: toDate2);

      expect(range1.isSame(range2), false);
    });

    test('overlaps should return true for overlapping DateRange instances', () {
      final range1 = DateRange(fromDate: DateTime(2023, 1, 1), toDate: DateTime(2023, 1, 31));
      final range2 = DateRange(fromDate: DateTime(2023, 1, 15), toDate: DateTime(2023, 2, 15));

      expect(range1.overlaps(range2), true);
    });

    test('overlaps should return false for non-overlapping DateRange instances', () {
      final range1 = DateRange(fromDate: DateTime(2023, 1, 1), toDate: DateTime(2023, 1, 31));
      final range2 = DateRange(fromDate: DateTime(2023, 2, 1), toDate: DateTime(2023, 2, 28));

      expect(range1.overlaps(range2), false);
    });

    test('intersect should return the correct intersection for overlapping DateRange instances', () {
      final range1 = DateRange(fromDate: DateTime(2023, 1, 1), toDate: DateTime(2023, 1, 31));
      final range2 = DateRange(fromDate: DateTime(2023, 1, 15), toDate: DateTime(2023, 2, 15));

      final intersection = range1.intersect(range2);

      expect(intersection!.fromDate, DateTime(2023, 1, 15));
      expect(intersection.toDate, DateTime(2023, 1, 31));
    });

    test('intersect should return null for non-overlapping DateRange instances', () {
      final range1 = DateRange(fromDate: DateTime(2023, 1, 1), toDate: DateTime(2023, 1, 31));
      final range2 = DateRange(fromDate: DateTime(2023, 2, 1), toDate: DateTime(2023, 2, 28));

      final intersection = range1.intersect(range2);

      expect(intersection, null);
    });

    test('difference should return the original range for non-overlapping DateRange instances', () {
      final range1 = DateRange(fromDate: DateTime(2023, 1, 1), toDate: DateTime(2023, 1, 31));
      final range2 = DateRange(fromDate: DateTime(2023, 2, 1), toDate: DateTime(2023, 2, 28));

      final difference = range1.difference(range2);

      expect(difference.length, 1);
      expect(difference[0].fromDate, DateTime(2023, 1, 1));
      expect(difference[0].toDate, DateTime(2023, 1, 31));
    });

    test('difference should return the correct difference for overlapping DateRange instances', () {
      final range1 = DateRange(fromDate: DateTime(2023, 1, 1), toDate: DateTime(2023, 1, 31));
      final range2 = DateRange(fromDate: DateTime(2023, 1, 15), toDate: DateTime(2023, 2, 15));

      final difference = range1.difference(range2);
      expect(difference.length, 1);

      final difference1 = difference[0];
      expect(difference1.fromDate, DateTime(2023, 1, 1));
      expect(difference1.toDate, DateTime(2023, 1, 15));
    });

    test('difference should return the correct difference when range2 has older from date', () {
      final range1 = DateRange(fromDate: DateTime(2023, 1, 1), toDate: DateTime(2023, 1, 31));
      final range2 = DateRange(fromDate: DateTime(2022, 12, 15), toDate: DateTime(2023, 2, 15));

      final difference = range1.difference(range2);
      expect(difference.length, 0);
    });

    test('difference should return the correct difference when range 2 has older to date', () {
      final range1 = DateRange(fromDate: DateTime(2023, 1, 1), toDate: DateTime(2023, 1, 31));
      final range2 = DateRange(fromDate: DateTime(2023, 1, 15), toDate: DateTime(2023, 1, 25));

      final difference = range1.difference(range2);
      expect(difference.length, 2);

      final difference1 = difference[0];
      expect(difference1.fromDate, DateTime(2023, 1, 1));
      expect(difference1.toDate, DateTime(2023, 1, 15));

      final difference2 = difference[1];
      expect(difference2.fromDate, DateTime(2023, 1, 25));
      expect(difference2.toDate, DateTime(2023, 1, 31));
    });

    test('difference should return the correct difference when has older to date', () {
      final range1 = DateRange(fromDate: DateTime(2023, 1, 15), toDate: DateTime(2023, 1, 31, 23, 59, 59));
      final range2 = DateRange(fromDate: DateTime(2023, 1, 15), toDate: DateTime(2023, 1, 31));

      final difference = range1.difference(range2);
      expect(difference.length, 1);

      final difference1 = difference[0];
      expect(difference1.fromDate, DateTime(2023, 1, 31));
      expect(difference1.toDate, DateTime(2023, 1, 31, 23, 59, 59));
    });

    test('difference should return the correct difference when has older to date', () {
      final range1 = DateRange(fromDate: DateTime(2023, 1, 15), toDate: DateTime(2023, 1, 31, 23, 59, 59));
      final range2 = DateRange(fromDate: DateTime(2023, 1, 15), toDate: DateTime(2023, 1, 31));

      final difference = range1.difference(range2);
      expect(difference.length, 1);

      final difference1 = difference[0];
      expect(difference1.fromDate, DateTime(2023, 1, 31));
      expect(difference1.toDate, DateTime(2023, 1, 31, 23, 59, 59));
    });
  });
}
