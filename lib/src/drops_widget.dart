import 'package:flutter/cupertino.dart';

import 'drop_position.dart';
import 'drop_shape.dart';

class Drop {
  final String title;
  final Duration duration;
  final Duration? transitionDuration;
  final TextStyle? textStyle;
  final Curve curve;
  final Curve? reverseCurve;
  final String? subtitle;
  final IconData? icon;
  final bool isDestructive;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final DropPosition position;
  final EdgeInsets? padding;
  final DropShape shape;
  final bool highContrastText;
  final Color? iconColor;
  final int titleMaxLines;
  final int subtitleMaxLines;

  Drop({
    required this.title,
    this.duration = const Duration(seconds: 3),
    this.transitionDuration = const Duration(milliseconds: 700),
    this.textStyle,
    this.curve = Curves.easeOutExpo,
    this.reverseCurve,
    this.subtitle,
    this.icon,
    this.isDestructive = false,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.position = DropPosition.top,
    this.padding,
    this.shape = DropShape.pill,
    this.highContrastText = true,
    this.iconColor,
    this.titleMaxLines = 1,
    this.subtitleMaxLines = 1,
  });

  void show(BuildContext context) {
    Drops._enqueue(this, context);
  }
}

class Drops {
  static final List<Drop> _dropsQueue = [];

  static bool _isShowingDrop = false;

  static void _enqueue(Drop drop, BuildContext context) {
    _dropsQueue.add(drop);

    if (!_isShowingDrop) {
      _showNextDrop(context);
    }
  }

  static void showFromDrop(BuildContext context, Drop drop) {
    _enqueue(drop, context);
  }

  static void show(
    BuildContext context, {
    required String title,
    Duration duration = const Duration(seconds: 3),
    Duration? transitionDuration = const Duration(milliseconds: 700),
    TextStyle? textStyle,
    Curve curve = Curves.easeOutExpo,
    Curve? reverseCurve,
    String? subtitle,
    IconData? icon,
    bool isDestructive = false,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    DropPosition position = DropPosition.top,
    EdgeInsets? padding,
    DropShape shape = DropShape.pill,
    bool highContrastText = true,
    Color? iconColor,
    int titleMaxLines = 1,
    int subtitleMaxLines = 1,
  }) {
    final drop = Drop(
      title: title,
      duration: duration,
      transitionDuration: transitionDuration,
      textStyle: textStyle,
      curve: curve,
      reverseCurve: reverseCurve,
      subtitle: subtitle,
      icon: icon,
      isDestructive: isDestructive,
      titleTextStyle: titleTextStyle,
      subtitleTextStyle: subtitleTextStyle,
      position: position,
      padding: padding,
      shape: shape,
      highContrastText: highContrastText,
      iconColor: iconColor,
      titleMaxLines: titleMaxLines,
      subtitleMaxLines: subtitleMaxLines,
    );

    _enqueue(drop, context);
  }

  static void _showNextDrop(BuildContext context) {
    if (_dropsQueue.isEmpty) {
      _isShowingDrop = false;
      return;
    }

    _isShowingDrop = true;
    final drop = _dropsQueue.removeAt(0);

    OverlayEntry? currentOverlay;
    currentOverlay = OverlayEntry(
      builder:
          (context) => _DropsWidget(
            title: drop.title,
            backgroundColor: drop.iconColor,
            duration: drop.duration,
            transitionDuration: drop.transitionDuration,
            curve: drop.curve,
            reverseCurve: drop.reverseCurve,
            isDestructive: drop.isDestructive,
            subtitle: drop.subtitle,
            titleMaxLines: drop.titleMaxLines,
            subtitleMaxLines: drop.subtitleMaxLines,
            titleTextStyle: drop.titleTextStyle,
            subtitleTextStyle: drop.subtitleTextStyle,
            position: drop.position,
            padding: drop.padding,
            shape: drop.shape,
            iconColor: drop.iconColor,
            highContrastText: drop.highContrastText,
            icon: drop.icon,
            onDismiss: () {
              currentOverlay?.remove();
              currentOverlay = null;

              _showNextDrop(context);
            },
          ),
    );

    Overlay.of(context).insert(currentOverlay!);
  }
}

class _DropsWidget extends StatefulWidget {
  final String title;
  final Color? backgroundColor;
  final Duration duration;
  final Duration? transitionDuration;
  final Curve curve;
  final Curve? reverseCurve;
  final VoidCallback onDismiss;
  final IconData? icon;
  final String? subtitle;
  final bool isDestructive;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final DropPosition? position;
  final EdgeInsets? padding;
  final DropShape shape;
  final bool highContrastText;
  final Color? iconColor;
  final int titleMaxLines;
  final int subtitleMaxLines;

  const _DropsWidget({
    required this.title,
    required this.duration,
    required this.onDismiss,
    required this.highContrastText,
    required this.isDestructive,
    required this.curve,
    required this.shape,
    this.reverseCurve,
    this.backgroundColor,
    this.icon,
    this.subtitle,
    this.transitionDuration,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.position,
    this.padding,
    this.iconColor,
    required this.titleMaxLines,
    required this.subtitleMaxLines,
  });

  @override
  _DropsWidgetState createState() => _DropsWidgetState();
}

class _DropsWidgetState extends State<_DropsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.transitionDuration,
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, widget.position == DropPosition.top ? -1 : 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve ?? widget.curve.flipped,
      ),
    );

    _animationController.forward();

    Future.delayed(widget.duration, () {
      if (mounted) _dismissAlert();
    });

    _scrollController.addListener(() {
      if (_scrollController.offset > 30 &&
          widget.position == DropPosition.top) {
        _dismissAlert();
      }

      if (_scrollController.offset < -30 &&
          widget.position == DropPosition.bottom) {
        _dismissAlert();
      }
    });
  }

  void _dismissAlert() {
    _animationController.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  EdgeInsets getPadding() {
    double baseHorizontalPadding = 20;
    double baseVerticalPadding = widget.subtitle != null ? 9 : 15;

    if (widget.subtitle == null && widget.icon == null) {
      return EdgeInsets.symmetric(
        vertical: baseVerticalPadding + 3,
        horizontal: baseHorizontalPadding + 20,
      );
    }
    if (widget.icon == null && widget.subtitle != null) {
      return EdgeInsets.symmetric(
        horizontal: baseHorizontalPadding + 20,
        vertical: baseVerticalPadding,
      );
    }

    if (widget.icon != null && widget.subtitle != null) {
      return EdgeInsets.symmetric(
        horizontal: baseHorizontalPadding,
        vertical: baseVerticalPadding,
      );
    }

    if (widget.icon != null && widget.subtitle == null) {
      return EdgeInsets.symmetric(
        horizontal: baseVerticalPadding,
        vertical: baseVerticalPadding,
      );
    }

    return EdgeInsets.all(0);
  }

  @override
  Widget build(BuildContext context) {
    final double iconSize = widget.icon != null ? 24.0 : 0;

    return Positioned(
      left: 0,
      top: widget.position == DropPosition.top ? 0 : null,
      bottom:
          widget.position == DropPosition.bottom
              ? 0 + MediaQuery.of(context).viewPadding.bottom
              : null,
      right: 0,
      child: SlideTransition(
        position: _offsetAnimation,
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          controller: _scrollController,
          hitTestBehavior: HitTestBehavior.deferToChild,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: SafeArea(
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                clipBehavior:
                    widget.shape == DropShape.squared
                        ? Clip.none
                        : Clip.antiAlias,

                decoration: ShapeDecoration(
                  shape: const StadiumBorder(),
                  shadows: [
                    BoxShadow(
                      color: CupertinoColors.black.withAlpha(30),
                      blurRadius: 40,
                      spreadRadius: 20,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: CupertinoPopupSurface(
                  child: Padding(
                    padding: widget.padding ?? getPadding(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null)
                          Icon(
                            widget.icon,
                            color:
                                widget.iconColor ??
                                (widget.isDestructive
                                    ? CupertinoColors.destructiveRed
                                        .resolveFrom(context)
                                    : CupertinoColors.secondaryLabel
                                        .resolveFrom(context)),
                          ),
                        SizedBox(width: widget.icon != null ? 13 : 0),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: widget.icon != null ? iconSize : 0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.title,
                                  maxLines: widget.titleMaxLines,
                                  overflow: TextOverflow.ellipsis,
                                  style: (widget.titleTextStyle ??
                                          TextStyle(
                                            color:
                                                widget.highContrastText
                                                    ? CupertinoColors.label
                                                        .resolveFrom(context)
                                                    : CupertinoColors
                                                        .secondaryLabel
                                                        .resolveFrom(context),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ))
                                      .copyWith(
                                        decoration: TextDecoration.none,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                if (widget.subtitle != null)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.subtitle!,
                                        maxLines: widget.subtitleMaxLines,
                                        overflow: TextOverflow.ellipsis,
                                        style: (widget.subtitleTextStyle ??
                                                TextStyle(
                                                  color:
                                                      widget.highContrastText
                                                          ? CupertinoColors
                                                              .secondaryLabel
                                                              .resolveFrom(
                                                                context,
                                                              )
                                                          : CupertinoColors
                                                              .tertiaryLabel
                                                              .resolveFrom(
                                                                context,
                                                              ),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ))
                                            .copyWith(
                                              decoration: TextDecoration.none,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
