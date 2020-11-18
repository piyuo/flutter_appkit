# libcli

library for flutter projects

## Github

clone source code to local.

```bash
git clone git@github.com:piyuo/fl-libcli.git
```

## Project

using project libcli.code-workspace

### Test

unit test

```bash
flutter test  --enable-experiment=non-nullable --no-sound-null-safety lib
```

debug test using vscode flutter extension

### Contributing packages

test to see if libcli is ready to publish

```bash
flutter packages pub publish --dry-run
```

publish libcli to pub.dev

```bash
flutter packages pub publish  --force
```
