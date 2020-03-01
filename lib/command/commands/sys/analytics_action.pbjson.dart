///
//  Generated code. Do not modify.
//  source: analytics_action.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const AnalyticsAction$json = const {
  '1': 'AnalyticsAction',
  '2': const [
    const {'1': 'logs', '3': 1, '4': 3, '5': 11, '6': '.Log', '10': 'logs'},
    const {'1': 'errors', '3': 2, '4': 3, '5': 11, '6': '.Error', '10': 'errors'},
  ],
};

const Log$json = const {
  '1': 'Log',
  '2': const [
    const {'1': 'time', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'time'},
    const {'1': 'msg', '3': 2, '4': 1, '5': 9, '10': 'msg'},
    const {'1': 'user', '3': 3, '4': 1, '5': 9, '10': 'user'},
    const {'1': 'app', '3': 4, '4': 1, '5': 9, '10': 'app'},
    const {'1': 'where', '3': 5, '4': 1, '5': 9, '10': 'where'},
    const {'1': 'level', '3': 6, '4': 1, '5': 5, '10': 'level'},
  ],
};

const Error$json = const {
  '1': 'Error',
  '2': const [
    const {'1': 'msg', '3': 1, '4': 1, '5': 9, '10': 'msg'},
    const {'1': 'user', '3': 2, '4': 1, '5': 9, '10': 'user'},
    const {'1': 'app', '3': 3, '4': 1, '5': 9, '10': 'app'},
    const {'1': 'where', '3': 4, '4': 1, '5': 9, '10': 'where'},
    const {'1': 'stack', '3': 5, '4': 1, '5': 9, '10': 'stack'},
    const {'1': 'errid', '3': 6, '4': 1, '5': 9, '10': 'errid'},
  ],
};

