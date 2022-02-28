/// Paginator can calculate the page count, current page, and the first index on the page for a given list.
/// ```dart
/// final paginator = Paginator(rowCount: 0, rowsPerPage: 10);
/// expect(paginator.pageCount, 1);
/// ```
class Paginator {
  /// Paginator can calculate the page count, current page, and the first index on the page for a given list.
  /// ```dart
  /// final paginator = Paginator(rowCount: 0, rowsPerPage: 10);
  /// expect(paginator.pageCount, 1);
  /// ```
  Paginator({
    required this.rowCount,
    required this.rowsPerPage,
  });

  /// rowCount is total number of rows in the table
  final int rowCount;

  /// rowsPerPage is rows per page
  int rowsPerPage;

  /// pageCount return total page count
  /// ```dart
  /// var count = pageCount;
  /// ```
  int get pageCount {
    if (rowCount == 0) {
      return 1;
    }
    return (rowCount / rowsPerPage).ceil();
  }

  /// getRowCountByPage return row total row count in current page
  /// ```dart
  /// getRowCountByPage(0);
  /// ```
  int getRowCountByPage(int page) {
    if (page >= pageCount) {
      return 0; // page not exists
    }
    if (page == pageCount - 1) {
      return rowCount - page * rowsPerPage;
    }
    return rowsPerPage;
  }

  /// getBeginIndex return start index in  page
  /// ```dart
  /// paginator.getBeginIndex(0);
  /// ```
  int getBeginIndex(int page) => page * rowsPerPage;

  /// currentIndexEnd return end index in current page
  /// ```dart
  /// paginator.getEndIndex(0);
  /// ```
  int getEndIndex(int page) => getBeginIndex(page) + getRowCountByPage(page);

  /// isLastPage return true if page is the last page
  /// ```dart
  /// paginator.isLastPage(0);
  /// ```
  bool isLastPage(int page) => page == pageCount - 1;
}
