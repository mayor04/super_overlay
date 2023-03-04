import 'package:flutter/material.dart';

/// ```dart
/// final overlay = OverlayController();
/// SuperOverlay<String>(
///   controller: controller,
///   overlay: (context, value) {,
///    child: Container(),
///   }
/// );
/// overlay.show(value: value);
/// overlay.remove();
/// ```

class SuperOverlay<T> extends StatefulWidget {
  const SuperOverlay({
    Key? key,
    required this.child,
    required this.overlay,
    required this.controller,
    this.offset = Offset.zero,
    this.childAnchor = Alignment.bottomLeft,
    this.overlayAnchor = Alignment.topLeft,
  }) : super(key: key);

  final Widget child;
  final Alignment childAnchor;
  final Alignment overlayAnchor;
  final Offset offset;
  final Widget Function(BuildContext context, T? value) overlay;

  final OverlayController<T> controller;

  @override
  State<SuperOverlay<T>> createState() => _SuperOverlayState<T>();
}

class _SuperOverlayState<T> extends State<SuperOverlay<T>> {
  late OverlayController<T> controller;

  OverlayEntry? overlayEntry;
  final _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
    controller._showOverlay.addListener(overlayListener);
  }

  @override
  void didUpdateWidget(covariant SuperOverlay<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller._showOverlay.removeListener(overlayListener);

      controller = widget.controller;
      controller._showOverlay.addListener(overlayListener);
    }
  }

  void overlayListener() {
    if (controller._showOverlay.value == true) {
      showOverlay();
    } else {
      closeOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.child,
    );
  }

  void closeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void showOverlay() {
    overlayEntry ??= OverlayEntry(
      builder: (_) {
        return GestureDetector(
          onTap: () => controller._showOverlay.value = false,
          child: Container(
            color: Colors.transparent,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: widget.offset,
              targetAnchor: widget.childAnchor,
              followerAnchor: widget.overlayAnchor,
              child: GestureDetector(
                onTap: () {},
                child: Align(
                  alignment: widget.overlayAnchor,
                  child: widget.overlay(context, widget.controller.value),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context)?.insert(overlayEntry!);
  }

  @override
  void dispose() {
    controller._showOverlay.removeListener(overlayListener);
    super.dispose();
  }
}

class OverlayController<T> {
  final _showOverlay = ValueNotifier(false);
  T? value;

  show({T? value}) {
    this.value = value;
    _showOverlay.value = true;
  }

  remove() {
    _showOverlay.value = false;
  }

  toggle() {
    if (_showOverlay.value == true) {
      _showOverlay.value = false;
    } else {
      _showOverlay.value = true;
    }
  }
}
