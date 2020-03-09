import 'package:flutter/foundation.dart';
import 'package:libcli/env/env.dart';

/// serviceUrl return service url base on app.branch
///
///     String url = serviceUrl('sys',3001);
String serviceUrl(String funcName, int debugPort) {
  if (!kReleaseMode) {
    if (envBranch == Branch.debug) {
      return 'http://localhost:$debugPort/$funcName';
    }
  }

  /// https://us-central1-piyuo-m-base.cloudfunctions.net/sys
  // return 'https://${host()}-piyuo-${branch()}-${region()}.cloudfunctions.net/$funcName';
  return 'https://us-central1-master-255220.cloudfunctions.net/$funcName';
}

/// branch return tag for service branch
///
///     expect(commandUrl.branch(), 't');
String branch() {
  switch (envBranch) {
    case Branch.test:
      return 't';
    case Branch.alpha:
      return 'a';
    case Branch.beta:
      return 'b';
    case Branch.master:
      return 'm';
    default:
  }
  assert(false, 'branch not support');
  return '';
}

/// host return google cloud platform host location
///
///     expect(commandUrl.host(), 'us-central1');
String host() {
  switch (envRegion) {
    case Region.US:
      return 'us-central1';
    case Region.CN:
      return 'asia-east2';
    case Region.TW:
      return 'asia-east1';
    default:
  }
  assert(false, 'region not support');
  return '';
}

/// region return tag for service region
///
///     expect(commandUrl.region(), 'us');
String region() {
  switch (envRegion) {
    case Region.US:
      return 'us';
    case Region.CN:
      return 'cn';
    case Region.TW:
      return 'tw';
    default:
  }
  assert(false, 'region not support');
  return '';
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
