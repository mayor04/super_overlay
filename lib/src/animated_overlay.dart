import 'package:flutter/material.dart';

class AnimatedOverlay extends StatefulWidget {
  const AnimatedOverlay({
    required this.controller,
    required this.overlay,
    required this.child,
    this.overlayAnchor = Alignment.topLeft,
    this.childAnchor = Alignment.topRight,
    this.offset = Offset.zero,
    Alignment? scaleAnimationAlignment,
    Key? key,
  })  : scaleAnimationAlignment = scaleAnimationAlignment ?? overlayAnchor,
        super(key: key);

  final OverlayController controller;
  final Widget overlay;
  final Widget child;

  /// This is where the overlay provided would be aligned specifying `overlayAnchor`
  /// as `Alignment.centerRight` and `childAnchor` as `Alignment.centerLeft` position the
  /// overlay centerRight to face the centerLeft of the child
  final Alignment overlayAnchor;

  /// This is where the overlay provided would be aligned specifying `overlayAnchor`
  /// as `Alignment.centerRight` and `childAnchor` as `Alignment.centerLeft` position the
  /// overlay centerRight to face the centerLeft of the child
  final Alignment childAnchor;
  final Offset offset;
  final Alignment scaleAnimationAlignment;

  @override
  State<AnimatedOverlay> createState() => _AnimatedOverlayState();
}

class _AnimatedOverlayState extends State<AnimatedOverlay> with SingleTickerProviderStateMixin {
  late AnimationController popController;
  OverlayEntry? overlayEntry;
  final _layerLink = LayerLink();

  bool get openMenu => widget.controller.value;
  set openMenu(bool v) => widget.controller.value = v;

  @override
  void initState() {
    super.initState();
    popController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    if (openMenu) {
      popController.forward();
    }

    widget.controller.addListener(menuListener);
  }

  @override
  void didUpdateWidget(covariant AnimatedOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(menuListener);

      widget.controller.addListener(menuListener);
    }
  }

  void menuListener() {
    if (openMenu) {
      showOverlay();
    } else {
      closeOverlay();
    }
  }

  Future<void> closeOverlay() async {
    popController.reverse();

    // wait for the animation
    await Future.delayed(const Duration(milliseconds: 170));
    overlayEntry?.remove();
    overlayEntry = null;
  }

  Future<void> showOverlay() async {
    popController.forward();
    // wait for the animation

    overlayEntry ??= OverlayEntry(
      builder: (_) {
        return MouseRegion(
          opaque: false,
          hitTestBehavior: HitTestBehavior.translucent,
          child: GestureDetector(
            onTap: widget.controller.close,
            behavior: HitTestBehavior.translucent,
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
                    child: ScaleTransition(
                      alignment: widget.scaleAnimationAlignment,
                      scale: Tween<double>(begin: 0.75, end: 1).animate(CurvedAnimation(
                        parent: popController,
                        curve: Curves.easeOut,
                      )),
                      child: widget.overlay,
                    ),
                  ),
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
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    popController.dispose();
    widget.controller.removeListener(menuListener);

    super.dispose();
  }
}

class OverlayController extends ValueNotifier<bool> {
  OverlayController({bool isOpen = false}) : super(isOpen);

  bool get isOpen => value;

  void open() => value = true;
  void close() => value = false;

  void toggle() => value = !value;
}
