import 'package:flutter_test/flutter_test.dart';
import 'paginator.dart';

void main() {
  setUp(() async {});

  group('[paginator]', () {
    test('should get page count', () async {
      final paginator = Paginator(rowCount: 0, rowsPerPage: 10);
      expect(paginator.pageCount, 1);
      final paginator1 = Paginator(rowCount: 1, rowsPerPage: 10);
      expect(paginator1.pageCount, 1);
      final paginator2 = Paginator(rowCount: 10, rowsPerPage: 10);
      expect(paginator2.pageCount, 1);
      final paginator3 = Paginator(rowCount: 11, rowsPerPage: 10);
      expect(paginator3.pageCount, 2);
    });

    test('should get row count by page', () async {
      final paginator = Paginator(rowCount: 0, rowsPerPage: 10);
      expect(paginator.getRowCountByPage(0), 0);
      final paginator1 = Paginator(rowCount: 1, rowsPerPage: 10);
      expect(paginator1.getRowCountByPage(0), 1);
      final paginator2 = Paginator(rowCount: 10, rowsPerPage: 10);
      expect(paginator2.getRowCountByPage(0), 10);
      final paginator3 = Paginator(rowCount: 11, rowsPerPage: 10);
      expect(paginator3.getRowCountByPage(1), 1);
      final paginator4 = Paginator(rowCount: 22, rowsPerPage: 10);
      expect(paginator4.getRowCountByPage(0), 10);
      expect(paginator4.getRowCountByPage(1), 10);
      expect(paginator4.getRowCountByPage(2), 2);
    });

    test('should get begin/end index', () async {
      final paginator = Paginator(rowCount: 0, rowsPerPage: 10);
      expect(paginator.getBeginIndex(0), 0);
      expect(paginator.getEndIndex(0), 0);
      final paginator1 = Paginator(rowCount: 1, rowsPerPage: 10);
      expect(paginator1.getBeginIndex(0), 0);
      expect(paginator1.getEndIndex(0), 1);
      final paginator2 = Paginator(rowCount: 10, rowsPerPage: 10);
      expect(paginator2.getBeginIndex(0), 0);
      expect(paginator2.getEndIndex(0), 10);
      final paginator3 = Paginator(rowCount: 11, rowsPerPage: 10);
      expect(paginator3.getBeginIndex(1), 10);
      expect(paginator3.getEndIndex(1), 11);
    });

    test('should determine is last page', () async {
      final paginator = Paginator(rowCount: 0, rowsPerPage: 10);
      expect(paginator.isLastPage(0), isTrue);
      final paginator1 = Paginator(rowCount: 1, rowsPerPage: 10);
      expect(paginator1.isLastPage(0), isTrue);
      final paginator2 = Paginator(rowCount: 10, rowsPerPage: 10);
      expect(paginator2.isLastPage(0), isTrue);
      final paginator3 = Paginator(rowCount: 11, rowsPerPage: 10);
      expect(paginator3.isLastPage(0), isFalse);
      expect(paginator3.isLastPage(1), isTrue);
    });
  });
}
