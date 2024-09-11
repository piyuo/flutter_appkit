# Play

A project to develop libcli ui component

## Github

clone source code to local.

```bash
git clone git@github.com:piyuo/play.git
```

## Project

using project play.code-workspace

### Test

```bash
flutter test lib
```

### Run local web server

``` bash
flutter build web --web-renderer html --profile --dart-define=Dart2jsOptimization=O0 -t lib/web/app/index.dart
cd build/web
http-server -p 3000 --cors
```

### ignore build folder in dropbox

``` bash
xattr -w com.dropbox.ignored 1 /Users/cc/Dropbox/play/build
```

### run web

``` bash
flutter run -d web-server
flutter run -d chrome --verbose
```

### clean if something strange happen

``` bash
flutter clean
flutter pub get
```

### disable chrome CORS

1- Go to flutter\bin\cache and remove a file named: flutter_tools.stamp

2- Go to flutter\packages\flutter_tools\lib\src\web and open the file chrome.dart.

3- Find '--disable-extensions'

4- Add '--disable-web-security'

### CocoaPods's specs repository is too out-of-date to satisfy dependencies

``` bash
delete ios/Podfile.lock
cd ios
pod repo update
```

### if you encounter something like

``` bash
In Podfile:
        mobile_scanner (from `.symlinks/plugins/mobile_scanner/ios`) was resolved to 3.2.0, which depends on
          GoogleMLKit/BarcodeScanning (~> 4.0.0)
```

try

``` bash
rm ios/Podfile.lock
cd ios
pod repo update
```

### sudo gem install cocoapods

ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions for the /usr/bin directory.

this is a macOS problem

try

``` bash
sudo gem install cocoapods -n /usr/local/bin

or

Create a ~/.gemrc file

vim .gemrc
With the following content:

:gemdir:
   - ~/.gem/ruby
install: -n /usr/local/bin
```

### user image picker in mac os

add DebugProfile.entitlements/ Release.entitlements

``` bash
 <key>com.apple.security.files.user-selected.read-only</key>
 <true/>
```

### import 'package:flutter_gen/gen_l10n/app_localizations.dart'; is missing

``` bash
flutter gen-l10n
```
