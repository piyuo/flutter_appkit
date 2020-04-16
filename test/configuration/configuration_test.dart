import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/configuration.dart' as configuration;

void main() {
  group('[vars]', () {
    test('should set/get variable', () {
      configuration.appID = 'piyuo-app';
      configuration.userID = '1-2';
      configuration.branch = configuration.Branches.debug;
      configuration.region = configuration.Regions.us;
      expect(configuration.appID, 'piyuo-app');
      expect(configuration.userID, '1-2');
      expect(configuration.branch, configuration.Branches.debug);
      expect(configuration.region, configuration.Regions.us);
    });

    test('should set current branch', () {
      configuration.branch = configuration.Branches.test;
      expect(configuration.branchString(), 't');
      configuration.region = configuration.Regions.us;
      expect(configuration.regionString(), 'us');
      expect(configuration.host(), 'us-central1');
    });
  });
}
