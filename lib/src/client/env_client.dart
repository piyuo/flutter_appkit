import 'package:libcli/preference.dart' as preference;
import 'package:libcli/configuration.dart' as configuration;

const kBranch = 'kBranch';

const kRegion = 'kRegion';

setupEnv() async {
  String branchStr = await preference.getString(kBranch);
  if (branchStr != '') {
    //configuration.branch = configuration.stringToBranch(branchStr);
  }
  String regionStr = await preference.getString(kRegion);
  if (regionStr != '') {
    //configuration.region = configuration.stringToRegion(regionStr);
  }
}
