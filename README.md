<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

A pacakge for showing alerts like the one used when copying from pasteboard or connecting Apple pencil and the alert shown on iPhones when using the silent toggle.

## Features

<img src="screenshots/example.gif" width="300">

## Getting started

Add to your dependencies:

```yaml
dependencies:
  drops: ^0.0.1
```

Then import:

```dart
import 'package:drops/drops.dart';
```

## Usage

To show a Drop all you have to do it the following:

```dart
Drops.show(context, title: 'Why did dash cross the road?',);
```

this displays a bare minimum Drop, to get the most, you can customize them like this:

```dart
Drops.show(
    context,
    title: 'Title',
    subtitle: 'subtitle',
    icon: CupertinoIcons.smiley_fill,
    isDestructive: false,
    highContrastText: true,
    position: DropPosition.top,
    shape: DropShape.pill,
 );
```

Heres the full list of parameters that you can use to adjust the Drop to match your needs:

```dart
    required String title
    Duration duration
    Duration? transitionDuration
    TextStyle? textStyle
    Curve curve = Curves.easeOutExpo
    Curve? reverseCurve
    String? subtitle
    IconData? icon
    bool isDestructive
    TextStyle? titleTextStyle
    TextStyle? subtitleTextStyle
    DropPosition position
    EdgeInsets? padding,
    DropShape shape
    bool highContrastText
    Color? iconColor
    int titleMaxLines
    int subtitleMaxLines
```

## Additional information

Report any bugs if any via github.

## TODO

- [x] Fix yellow underlines that shows up when using drops in an app without cupertino ancestor
- [ ] add action button for drops
- [ ] add theming to drops (Road map to material)
