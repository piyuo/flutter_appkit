/*
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// kBranchMaster is The current tip-of-tree, absolute latest cutting edge build. Usually functional, though sometimes we accidentally break things
const kBranchMaster = 'master';

/// kBranchBeta We will branch from master for a new beta release at the beginning of the month, usually the first Monday
const kBranchBeta = 'beta';

/// kBranchStable is a a branch that has been stabilized on beta will become our next stable branch and we will create a stable release from that branch. We recommend that you use this channel for all production app releases.
const kBranchStable = 'stable';

/// kBranchDebug is a a branch that always direct remove service url to http://localhost:8080
const kBranchDebug = 'debug';

/// _branch used in command pattern, determine which branch to use, default is master branch
String _branch = kBranchMaster;

/// branch used in command pattern, determine which branch to use, default is master branch
String get branch => _branch;

@visibleForTesting
set branch(String value) => _branch = value;
*/