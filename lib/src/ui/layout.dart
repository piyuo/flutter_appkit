enum Layout { mobile, tablet, desktop }

///  layout return current layout is mobile, tablet, desktop
Layout layout(double windowWidth) {
  if (windowWidth < 600) {
    return Layout.mobile;
  }
  if (windowWidth < 1200) {
    return Layout.tablet;
  }
  return Layout.desktop;
}

///  isMobileLayout return true if use mobile layout
bool isMobileLayout(double windowWidth) {
  return layout(windowWidth) == Layout.mobile;
}

///  isTabletLayout return true if use mobile layout
bool isTabletLayout(double windowWidth) {
  return layout(windowWidth) == Layout.tablet;
}

///  isDesktopLayout return true if use mobile layout
bool isDesktopLayout(double windowWidth) {
  return layout(windowWidth) == Layout.desktop;
}
