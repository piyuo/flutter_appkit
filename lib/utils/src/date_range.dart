/// DateRange keeps from and to date
class DateRange {
  DateRange({
    required this.fromDate,
    required this.toDate,
  });
  DateTime fromDate;
  DateTime toDate;

  /// isSame if two DateRange is same
  bool isSame(DateRange other) {
    return fromDate == other.fromDate && toDate == other.toDate;
  }

  /// overlaps return true if two DateRange is overlap
  bool overlaps(DateRange other) {
    return fromDate.isBefore(other.toDate) && other.fromDate.isBefore(toDate);
  }

  /// intersect return DateRange result from intersection between two DateRange
  DateRange? intersect(DateRange other) {
    final start = fromDate.isBefore(other.fromDate) ? other.fromDate : fromDate;
    final end = toDate.isAfter(other.toDate) ? other.toDate : toDate;

    if (start.isBefore(end)) {
      return DateRange(fromDate: start, toDate: end);
    } else {
      return null; // No intersection
    }
  }

  /// difference return list of DateRange result from difference between two DateRange
  List<DateRange> difference(DateRange other) {
    if (!overlaps(other)) {
      return [this]; // No overlap, return the current range
    }

    final ranges = <DateRange>[];

    if (fromDate.isBefore(other.fromDate)) {
      ranges.add(DateRange(fromDate: fromDate, toDate: other.fromDate));
    }

    if (toDate.isAfter(other.toDate)) {
      ranges.add(DateRange(fromDate: other.toDate, toDate: toDate));
    }
    return ranges;
  }

  /// pushLimit push fromDate to min time and toDate to max time
  void pushLimit() {
    fromDate = fromDate.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    toDate =
        toDate.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0).add(const Duration(days: 1));
  }
}
