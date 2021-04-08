/// _testMode true should return success, false return error, otherwise behave normal
///
int _testMode = 0;

/// testModeSuccess will let every function success
///
void testModeSuccess() {
  _testMode = 1;
}

/// testModeAlwayFail will let every function fail
///
void testModeFail() {
  _testMode = -1;
}

/// testModeNone stop test mode and back to normal
///
void testModeNone() {
  _testMode = 0;
}

/// isTestModeSuccess will let every function success
///
bool isTestModeSuccess() {
  return _testMode == 1;
}

/// isTestModeFail will let every function fail
///
bool isTestModeFail() {
  return _testMode == -1;
}

/// isTestModeNone stop test mode and back to normal
///
bool isTestModeNone() {
  return _testMode == 0;
}
