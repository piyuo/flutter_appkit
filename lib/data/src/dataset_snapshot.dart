import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class DatasetSnapshot extends HiveObject {
  DatasetSnapshot({
    required this.data,
    this.noRefresh = false,
    this.noMore = false,
  });

  /// _data keep all saved data
  @HiveField(0)
  final List<String> data;

  /// noRefresh means internal data has no need to refresh
  @HiveField(1)
  final bool noRefresh;

  /// noMore means internal data has no need to load more
  @HiveField(2)
  final bool noMore;
}
