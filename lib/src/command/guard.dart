final DefaultGuardRule = GuardRule();

/// Rule define how action can pass guard,duration is zero or count is 0 mean always pass
///
class GuardRule {
  Duration? duration1;

  int? count1;

  Duration? duration2;

  int? count2;

  GuardRule({
    this.duration1,
    this.count1,
    this.duration2,
    this.count2,
  });
}

/// book keep action send log
///
class GuardRecord {
  final DateTime access;

  final Type commandType;

  final GuardRule rule;

  GuardRecord({
    required this.access,
    required this.commandType,
    required this.rule,
  });
}

List<GuardRecord> guardRecords = [];

/// guardCheck return 0 when pass, return 1 for violate rule1, return 2 for violate rule2
///
int guardCheck(Type commandType, GuardRule rule) {
  rule.duration1 = rule.duration1 ?? Duration(seconds: 5);
  rule.count1 = rule.count1 ?? 1;
  rule.duration2 = rule.duration2 ?? Duration(minutes: 5);
  rule.count2 = rule.count2 ?? 10;

  var now = DateTime.now();
  var base1 = now.subtract(rule.duration1!);
  var base2 = now.subtract(rule.duration2!);

  int total1 = 0;
  int total2 = 0;
  for (int i = guardRecords.length - 1; i >= 0; i--) {
    var record = guardRecords[i];
    var time1 = now.subtract(record.rule.duration1!);
    var time2 = now.subtract(record.rule.duration2!);
    if (record.access.isBefore(time1) && record.access.isBefore(time2)) {
      guardRecords.removeAt(i);
    } else {
      if (record.commandType == commandType) {
        if (rule.duration1 != Duration.zero && rule.count1! > 0 && record.access.isAfter(base1)) {
          total1++;
        }

        if (rule.duration2 != Duration.zero && rule.count2! > 0 && record.access.isAfter(base2)) {
          total2++;
        }
      }
    }
  }

  if (total1 > 0 && total1 >= rule.count1!) {
    return 1;
  }

  if (total2 > 0 && total2 >= rule.count2!) {
    return 2;
  }

  guardRecords.add(GuardRecord(
    access: DateTime.now(),
    commandType: commandType,
    rule: rule,
  ));
  return 0;
}
