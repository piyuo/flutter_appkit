import 'package:localstore/localstore.dart';

final _db = Localstore.instance;

CollectionRef collection(String path) {
  return _db.collection(path);
}
