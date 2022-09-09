import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const Curve _kResizeTimeCurve = Interval(0.4, 1.0, curve: Curves.ease);
const double _kMinFlingVelocity = 700.0;
const double _kMinFlingVelocityDelta = 400.0;
const double _kFlingVelocityScale = 1.0 / 300.0;
const double _kDismissThreshold = 0.4;

typedef DismissDirectionCallback = void Function(DismissDirection direction);
typedef ConfirmDismissCallback = Future<bool?> Function(
    DismissDirection direction);
typedef DismissUpdateCallback = void Function(DismissUpdateDetails details);

enum DismissDirection {
  vertical,

  horizontal,

  endToStart,

  startToEnd,

  up,

  down,

  none,

  all,
}

class MyDismissible extends StatefulWidget {
  MyDismissible({
    required Key key,
    required this.child,
    this.background,
    this.secondaryBackground,
    this.confirmDismiss,
    this.onResize,
    this.onUpdate,
    this.onDismissed,
    this.direction = DismissDirection.horizontal,
    this.resizeDuration = const Duration(milliseconds: 300),
    this.dismissThresholds = const <DismissDirection, double>{},
    this.movementDuration = const Duration(milliseconds: 200),
    this.crossAxisEndOffset = 0.0,
    this.dragStartBehavior = DragStartBehavior.start,
    this.behavior = HitTestBehavior.opaque,
  })  : assert(secondaryBackground == null || background != null),
        super(key: key);

  final Widget child;
  final Widget? background;
  final Widget? secondaryBackground;
  final ConfirmDismissCallback? confirmDismiss;
  final VoidCallback? onResize;
  final DismissDirectionCallback? onDismissed;
  late DismissDirection direction;
  final Duration? resizeDuration;
  final Map<DismissDirection, double> dismissThresholds;
  final Duration movementDuration;
  final double crossAxisEndOffset;
  final DragStartBehavior dragStartBehavior;
  final HitTestBehavior behavior;
  final DismissUpdateCallback? onUpdate;

  @override
  State<MyDismissible> createState() => _MyDismissibleState();
}

class DismissUpdateDetails {
  DismissUpdateDetails(
      {this.direction = DismissDirection.all,
        this.reached = false,
        this.previousReached = false});

  final DismissDirection direction;

  final bool reached;

  final bool previousReached;
}

class _DismissibleClipper extends CustomClipper<Rect> {
  _DismissibleClipper({
    required this.axis,
    required this.moveAnimation,
  })  : assert(moveAnimation != null),
        super(reclip: moveAnimation);

  final Axis axis;
  final Animation<Offset> moveAnimation;

  @override
  Rect getClip(Size size) {
    switch (axis) {
      case Axis.horizontal:
        final double offset = moveAnimation.value.dx * size.width;
        if (offset < 0) {
          return Rect.fromLTRB(
              size.width + offset, 0.0, size.width, size.height);
        }
        return Rect.fromLTRB(0.0, 0.0, offset, size.height);
      case Axis.vertical:
        final double offset = moveAnimation.value.dy * size.height;
        if (offset < 0) {
          return Rect.fromLTRB(
              0.0, size.height + offset, size.width, size.height);
        }
        return Rect.fromLTRB(0.0, 0.0, size.width, offset);
    }
  }

  @override
  Rect getApproximateClipRect(Size size) => getClip(size);

  @override
  bool shouldReclip(_DismissibleClipper oldClipper) {
    return oldClipper.axis != axis ||
        oldClipper.moveAnimation.value != moveAnimation.value;
  }
}

enum _FlingGestureKind { none, forward, reverse }

class _MyDismissibleState extends State<MyDismissible>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    _moveController =
    AnimationController(duration: widget.movementDuration, vsync: this)
      ..addStatusListener(_handleDismissStatusChanged)
      ..addListener(_handleDismissUpdateValueChanged);
    _updateMoveAnimation();
  }

  AnimationController? _moveController;
  late Animation<Offset> _moveAnimation;

  AnimationController? _resizeController;
  Animation<double>? _resizeAnimation;

  double _dragExtent = 0.0;
  bool _confirming = false;
  bool _dragUnderway = false;
  Size? _sizePriorToCollapse;
  bool _dismissThresholdReached = false;

  @override
  bool get wantKeepAlive =>
      _moveController?.isAnimating == true ||
          _resizeController?.isAnimating == true;

  @override
  void dispose() {
    _moveController!.dispose();
    _resizeController?.dispose();
    super.dispose();
  }

  bool get _directionIsXAxis {
    return widget.direction == DismissDirection.horizontal ||
        widget.direction == DismissDirection.endToStart ||
        widget.direction == DismissDirection.startToEnd;
  }

  DismissDirection _extentToDirection(double extent) {
    if (extent == 0.0) return DismissDirection.none;
    if (_directionIsXAxis) {
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          return extent < 0
              ? DismissDirection.startToEnd
              : DismissDirection.endToStart;
        case TextDirection.ltr:
          return extent > 0
              ? DismissDirection.startToEnd
              : DismissDirection.endToStart;
      }
    }
    return extent > 0 ? DismissDirection.down : DismissDirection.up;
  }

  DismissDirection get _dismissDirection => _extentToDirection(_dragExtent);

  bool get _isActive {
    return _dragUnderway || _moveController!.isAnimating;
  }

  double get _overallDragAxisExtent {
    final Size size = context.size!;
    return _directionIsXAxis ? size.width : size.height;
  }

  void _handleDragStart(DragStartDetails details) {
    if (_confirming) return;
    _dragUnderway = true;
    if (_moveController!.isAnimating) {
      _dragExtent =
          _moveController!.value * _overallDragAxisExtent * _dragExtent.sign;
      _moveController!.stop();
    } else {
      _dragExtent = 0.0;
      _moveController!.value = 0.0;
    }
    setState(() {
      _updateMoveAnimation();
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isActive || _moveController!.isAnimating) return;

    final double delta = details.primaryDelta!;
    final double oldDragExtent = _dragExtent;
    switch (widget.direction) {
      case DismissDirection.all:
      case DismissDirection.horizontal:
      case DismissDirection.vertical:
        _dragExtent += delta;
        break;

      case DismissDirection.up:
        if (_dragExtent + delta < 0) _dragExtent += delta;
        break;

      case DismissDirection.down:
        if (_dragExtent + delta > 0) _dragExtent += delta;
        break;

      case DismissDirection.endToStart:
        switch (Directionality.of(context)) {
          case TextDirection.rtl:
            if (_dragExtent + delta > 0) _dragExtent += delta;
            break;
          case TextDirection.ltr:
            if (_dragExtent + delta < 0) _dragExtent += delta;
            break;
        }
        break;

      case DismissDirection.startToEnd:
        switch (Directionality.of(context)) {
          case TextDirection.rtl:
            if (_dragExtent + delta < 0) _dragExtent += delta;
            break;
          case TextDirection.ltr:
            if (_dragExtent + delta > 0) _dragExtent += delta;
            break;
        }
        break;

      case DismissDirection.none:
        _dragExtent = 0;
        break;
    }
    if (oldDragExtent.sign != _dragExtent.sign) {
      setState(() {
        _updateMoveAnimation();
      });
    }
    if (!_moveController!.isAnimating) {
      _moveController!.value = _dragExtent.abs() / _overallDragAxisExtent;
    }
  }

  void _handleDismissUpdateValueChanged() {
    if (widget.onUpdate != null) {
      final bool oldDismissThresholdReached = _dismissThresholdReached;
      _dismissThresholdReached = _moveController!.value >
          (widget.dismissThresholds[_dismissDirection] ?? _kDismissThreshold);
      final DismissUpdateDetails details = DismissUpdateDetails(
        direction: _dismissDirection,
        reached: _dismissThresholdReached,
        previousReached: oldDismissThresholdReached,
      );
      widget.onUpdate!(details);
    }
  }

  void _updateMoveAnimation() {
    final double end = _dragExtent.sign;
    _moveAnimation = _moveController!.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: _directionIsXAxis
            ? Offset(end, widget.crossAxisEndOffset)
            : Offset(widget.crossAxisEndOffset, end),
      ),
    );
  }

  _FlingGestureKind _describeFlingGesture(Velocity velocity) {
    if (_dragExtent == 0.0) {
      return _FlingGestureKind.none;
    }
    final double vx = velocity.pixelsPerSecond.dx;
    final double vy = velocity.pixelsPerSecond.dy;
    DismissDirection flingDirection;
    // Verify that the fling is in the generally right direction and fast enough.
    if (_directionIsXAxis) {
      if (vx.abs() - vy.abs() < _kMinFlingVelocityDelta ||
          vx.abs() < _kMinFlingVelocity) return _FlingGestureKind.none;
      assert(vx != 0.0);
      flingDirection = _extentToDirection(vx);
    } else {
      if (vy.abs() - vx.abs() < _kMinFlingVelocityDelta ||
          vy.abs() < _kMinFlingVelocity) return _FlingGestureKind.none;
      assert(vy != 0.0);
      flingDirection = _extentToDirection(vy);
    }
    if (flingDirection == _dismissDirection) return _FlingGestureKind.forward;
    return _FlingGestureKind.reverse;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isActive || _moveController!.isAnimating) return;
    _dragUnderway = false;
    if (_moveController!.isCompleted) {
      _handleMoveCompleted();
      return;
    }
    final double flingVelocity = _directionIsXAxis
        ? details.velocity.pixelsPerSecond.dx
        : details.velocity.pixelsPerSecond.dy;
    switch (_describeFlingGesture(details.velocity)) {
      case _FlingGestureKind.forward:
        assert(_dragExtent != 0.0);
        assert(!_moveController!.isDismissed);
        if ((widget.dismissThresholds[_dismissDirection] ??
            _kDismissThreshold) >=
            1.0) {
          _moveController!.reverse();
          break;
        }
        _dragExtent = flingVelocity.sign;
        _moveController!
            .fling(velocity: flingVelocity.abs() * _kFlingVelocityScale);
        break;
      case _FlingGestureKind.reverse:
        assert(_dragExtent != 0.0);
        assert(!_moveController!.isDismissed);
        _dragExtent = flingVelocity.sign;
        _moveController!
            .fling(velocity: -flingVelocity.abs() * _kFlingVelocityScale);
        break;
      case _FlingGestureKind.none:
        if (!_moveController!.isDismissed) {
          // we already know it's not completed, we check that above
          if (_moveController!.value >
              (widget.dismissThresholds[_dismissDirection] ??
                  _kDismissThreshold)) {
            _moveController!.forward();
          } else {
            _moveController!.reverse();
            setState(() {
              widget.direction = DismissDirection.all;

            });
          }
        }
        break;
    }
  }

  Future<void> _handleDismissStatusChanged(AnimationStatus status) async {
    if (status == AnimationStatus.completed && !_dragUnderway) {
      await _handleMoveCompleted();
    }
    if (mounted) {
      updateKeepAlive();
    }
  }

  Future<void> _handleMoveCompleted() async {
    if ((widget.dismissThresholds[_dismissDirection] ?? _kDismissThreshold) >=
        1.0) {
      _moveController!.reverse();
      return;
    }
    final bool result = await _confirmStartResizeAnimation();
    if (mounted) {
      if (result) {
        _startResizeAnimation();
      } else {
        _moveController!.reverse();
      }
    }
  }

  Future<bool> _confirmStartResizeAnimation() async {
    if (widget.confirmDismiss != null) {
      _confirming = true;
      final DismissDirection direction = _dismissDirection;
      try {
        return await widget.confirmDismiss!(direction) ?? false;
      } finally {
        _confirming = false;
      }
    }
    return true;
  }

  void _startResizeAnimation() {
    assert(_moveController!.isCompleted);
    assert(_resizeController == null);
    assert(_sizePriorToCollapse == null);
    if (widget.resizeDuration == null) {
      if (widget.onDismissed != null) {
        final DismissDirection direction = _dismissDirection;
        widget.onDismissed!(direction);
      }
    } else {
      _resizeController =
      AnimationController(duration: widget.resizeDuration, vsync: this)
        ..addListener(_handleResizeProgressChanged)
        ..addStatusListener((AnimationStatus status) => updateKeepAlive());
      _resizeController!.forward();
      setState(() {
        _sizePriorToCollapse = context.size;
        _resizeAnimation = _resizeController!
            .drive(
          CurveTween(
            curve: _kResizeTimeCurve,
          ),
        )
            .drive(
          Tween<double>(
            begin: 1.0,
            end: 0.0,
          ),
        );
      });
    }
  }

  void _handleResizeProgressChanged() {
    if (_resizeController!.isCompleted) {
      widget.onDismissed?.call(_dismissDirection);
    } else {
      widget.onResize?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    assert(!_directionIsXAxis || debugCheckHasDirectionality(context));

    Widget? background = widget.background;
    if (widget.secondaryBackground != null) {
      final DismissDirection direction = _dismissDirection;
      if (direction == DismissDirection.endToStart ||
          direction == DismissDirection.up) {
        background = widget.secondaryBackground;
      }
    }

    if (_resizeAnimation != null) {
      // we've been dragged aside, and are now resizing.
      assert(() {
        if (_resizeAnimation!.status != AnimationStatus.forward) {
          assert(_resizeAnimation!.status == AnimationStatus.completed);
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
                'A dismissed Dismissible widget is still part of the tree.'),
            ErrorHint(
              'Make sure to implement the onDismissed handler and to immediately remove the Dismissible '
                  'widget from the application once that handler has fired.',
            ),
          ]);
        }
        return true;
      }());

      return SizeTransition(
        sizeFactor: _resizeAnimation!,
        axis: _directionIsXAxis ? Axis.vertical : Axis.horizontal,
        child: SizedBox(
          width: _sizePriorToCollapse!.width,
          height: _sizePriorToCollapse!.height,
          child: background,
        ),
      );
    }

    Widget content = SlideTransition(
      position: _moveAnimation,
      child: widget.child,
    );

    if (background != null) {
      content = Stack(children: <Widget>[
        if (!_moveAnimation.isDismissed)
          Positioned.fill(
            child: ClipRect(
              clipper: _DismissibleClipper(
                axis: _directionIsXAxis ? Axis.horizontal : Axis.vertical,
                moveAnimation: _moveAnimation,
              ),
              child: background,
            ),
          ),
        content,
      ]);
    }

    if (widget.direction == DismissDirection.none) return content;

    if (widget.direction == DismissDirection.all) {
      return GestureDetector(
        onHorizontalDragStart: ((details) {
          widget.direction = DismissDirection.horizontal;
          _handleDragStart(details);
        }),
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        onVerticalDragStart: ((details) {
          widget.direction = DismissDirection.vertical;
          _handleDragStart(details);
        }),
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        behavior: widget.behavior,
        dragStartBehavior: widget.dragStartBehavior,
        child: content,
      );
    }

    return GestureDetector(
      onHorizontalDragStart: _directionIsXAxis ? _handleDragStart : null,
      onHorizontalDragUpdate: _directionIsXAxis ? _handleDragUpdate : null,
      onHorizontalDragEnd: _directionIsXAxis ? _handleDragEnd : null,
      onVerticalDragStart: _directionIsXAxis ? null : _handleDragStart,
      onVerticalDragUpdate: _directionIsXAxis ? null : _handleDragUpdate,
      onVerticalDragEnd: _directionIsXAxis ? null : _handleDragEnd,
      behavior: widget.behavior,
      dragStartBehavior: widget.dragStartBehavior,
      child: content,
    );
  }
}
