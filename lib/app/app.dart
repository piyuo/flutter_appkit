/// master: customer production use
/// beta: customer test on
/// alpha: QA test on
/// test: for unit test
/// debug: can debug local service
enum Branch { debug, test, alpha, beta, master }

/// service deploy location,
enum Region { us, cn, tw }

/// application identity
///
///     application='piyuo-web-index'
String piyuoid = '';

/// user identity
///
///     piyuoId='user-store'
String identity = '';

/// current service branch
///
///     branch=Branch.debug
Branch branch = Branch.debug;

/// current service region
///
///     region=Region.us
Region region = Region.us;
