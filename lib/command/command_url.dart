import 'package:flutter/foundation.dart';
import 'package:libcli/hook/vars.dart' as vars;

/// serviceUrl return service url base on app.branch
///
///     String url = serviceUrl('sys',3001);
String serviceUrl(String funcName, int debugPort) {
  if (!kReleaseMode) {
    if (vars.branch == vars.Branches.debug) {
      return 'http://localhost:$debugPort/$funcName';
    }
  }

  /// https://us-central1-piyuo-m-base.cloudfunctions.net/sys
  // return 'https://${host()}-piyuo-${branch()}-${region()}.cloudfunctions.net/$funcName';
  return 'https://us-central1-master-255220.cloudfunctions.net/$funcName';
}

/*
停止使用 rxdart 因為很難同時處理同步及非同步程序
  Observable<ProtoObject> execute(ProtoObject obj) {
    assert(url != null && url.length > 0);
    if (this.mockResponse != null) return Observable.just(this.mockResponse);
    if (this.mockResponder != null) return Observable.just(mockResponder(obj));
    Uint8List bytes = this.encode(obj);
    var fromFutureObservable = Observable.fromFuture(this.post(bytes));
    return fromFutureObservable.switchMap<ProtoObject>((List<int> i) {
      return Observable.just(this.decode(i));
    });
  }
  */
