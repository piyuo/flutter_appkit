/// master: customer production use
/// beta: customer test on
/// alpha: QA test on
/// test: for unit test
/// debug: can debug local service
enum Branch { debug, test, alpha, beta, master }

/// service deploy location,
enum Region { US, CN, TW }

/// application identity
///
///     envAppID='piyuo-web-index'
String envAppID = '';

/// user identity
///
///     envUserID='user-store'
String envUserID = '';

/// current service branch
///
///     envBranch=Branch.debug
Branch envBranch = Branch.debug;

/// current service region
///
///     envRegion=Region.us
Region envRegion = Region.US;
