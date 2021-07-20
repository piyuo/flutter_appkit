# fonts

svg icons font

## reference

find new icon, download svg
<https://fonts.google.com/icons>

## install

Flutter Icon Font Generator

```bash
pub global activate icon_font_generator
```

## env

add to path $HOME/.pub-cache/bin to .zshrc

## usage

```bash
icon_font_generator --package=libcli --from=fonts/icons --class-name=CustomIcons --out-font=fonts/custom-icons.ttf --out-flutter=lib/src/icons/icons.dart
```
