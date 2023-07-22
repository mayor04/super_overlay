import 'dart:math';

import 'package:flutter/material.dart';
import 'package:super_overlay/super_overlay.dart';

class SuperTestView extends StatefulWidget {
  const SuperTestView({Key? key}) : super(key: key);

  @override
  State<SuperTestView> createState() => _SuperTestViewState();
}

class _SuperTestViewState extends State<SuperTestView> {
  OverlayEntry? overlayEntry;
  final _layerLink = LayerLink();

  final overlayController = OverlayController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  height: 50,
                  width: 100,
                  margin: EdgeInsets.only(left: 6.2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Positioned(
                  left: 0,
                  // right: 0,
                  bottom: 0,
                  top: 0,
                  child: Center(
                    child: Transform.rotate(
                      angle: 90 / 180 * pi,
                      // alignment: Alignment.center,
                      child: Container(
                        decoration: const BoxDecoration(
                            // border: Border.all(color: Colors.blue),
                            ),
                        child: CustomPaint(
                          painter: CustomPaintTest(),
                          size: const Size(50, 8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            AnimatedOverlay(
              offset: const Offset(0, 30),
              childAnchor: Alignment.bottomCenter,
              overlayAnchor: Alignment.topCenter,
              controller: overlayController,
              overlay: Container(
                height: 200,
                width: 200,
                color: Colors.red,
              ),
              child: ElevatedButton(
                onPressed: () {
                  overlayController.toggle();
                },
                child: const Text('Elevated'),
              ),
            ),
            Container(
              height: 100,
              width: 200,
              // foregroundDecoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(20),
              //   border: Border.all(
              //     color: const Color(0x0F100A31),
              //     width: 2,
              //   ),
              // ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(
                  color: const Color.fromRGBO(16, 10, 49, 0.1),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              // child: Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              // ),
            )
          ],
        ),
      ),
    );

    return Scaffold(
      body: SizedBox(
        height: 500,
        child: Column(
          children: [
            Container(
              height: 400,
              child: Align(
                alignment: Alignment.center,
                child: CompositedTransformTarget(
                  link: _layerLink,
                  child: ElevatedButton(
                    onPressed: () {
                      if (overlayEntry == null) {
                        showOverlay();
                      } else {
                        closeOverlay();
                      }
                    },
                    child: const Text('Elevated'),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.green,
              child: CompositedTransformFollower(
                link: _layerLink,
                offset: const Offset(0, 30),
                targetAnchor: Alignment.bottomCenter,
                followerAnchor: Alignment.topCenter,
                child: Material(
                  child: Container(
                    height: 100,
                    width: 200,
                    color: Colors.amber,
                    child: TextField(),
                    // child: Material(
                    //   child: TextField(

                    //   ),
                    // ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void closeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void showOverlay() {
    overlayEntry ??= OverlayEntry(
      builder: (context) {
        return Positioned(
          width: 200,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: const Offset(0, 30),
            targetAnchor: Alignment.bottomCenter,
            followerAnchor: Alignment.topCenter,
            child: Material(
              child: Container(
                height: 100,
                width: 200,
                color: Colors.amber,
                child: TextField(),
                // child: Material(
                //   child: TextField(

                //   ),
                // ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context)?.insert(overlayEntry!);
  }
}

class CustomPaintTest extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // canvas
    //   ..save()
    //   ..translate(size.width / 2, size.height / 2)
    //   ..rotate(90 / 180 * pi);

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Paint paint2 = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.cubicTo(size.width * 0.19, size.height * 0.17, size.width * 0.27, size.height * 0.31,
        size.width * 0.36, size.height * 0.67);
    path.cubicTo(size.width * 0.44, size.height * 0.97, size.width * 0.50, size.height,
        size.width * 0.60, size.height * 0.66);
    path.cubicTo(size.width * 0.70, size.height * 0.32, size.width * 0.79, size.height * 0.1666508,
        size.width, 0);
    // path.close();
    canvas.drawPath(path, paint2);
    canvas.drawPath(path, paint);

    // canvas.translate(-size.width / 2, -size.height / 2);
    // canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
