# Permission

## iOS

Add the following keys to your Info.plist file, located in root/ios/Runner/Info.plist:

``` bash
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires access to the photo library.</string>
<key>NSCameraUsageDescription</key>
<string>This app requires access to the camera.</string>
```

## Android
