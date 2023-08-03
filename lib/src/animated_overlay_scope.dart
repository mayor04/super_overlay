import 'package:flutter/material.dart';
import 'package:super_overlay/src/animated_overlay.dart';

class OverlayScope extends InheritedWidget {
  const OverlayScope({
    required this.controller,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final OverlayController controller;

  static OverlayController of(BuildContext context) {
    final overlay = context.dependOnInheritedWidgetOfExactType<OverlayScope>();

    assert(overlay != null, 'Editor not found in the current context.');

    return overlay!.controller;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is OverlayScope && !identical(oldWidget.controller, controller);
  }
}

extension OverlayScopeExtension on BuildContext {
  OverlayController get overlay => OverlayScope.of(this);
}
