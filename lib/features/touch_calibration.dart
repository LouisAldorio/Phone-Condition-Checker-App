import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TouchCalibration extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const TouchCalibration(
      {Key? key, required this.screenWidth, required this.screenHeight})
      : super(key: key);

  static String routeName = '/touch_calibration';

  @override
  State<TouchCalibration> createState() => _TouchCalibrationState();
}

class _TouchCalibrationState extends State<TouchCalibration>
    with WidgetsBindingObserver {
  final Set<int> selectedIndexes = <int>{};
  final key = GlobalKey();
  final Set<_Foo> _trackTaped = <_Foo>{};

  int crossAxisCount = 8;

  void _detectTapedItem(PointerEvent event) {
    final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        if (target is _Foo && !_trackTaped.contains(target)) {
          _trackTaped.add(target);
          _selectIndex(target.index);
        }
      }
    }
  }

  _selectIndex(int index) {
    setState(() {
      selectedIndexes.add(index);
    });
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: _detectTapedItem,
        onPointerMove: _detectTapedItem,
        onPointerUp: (PointerUpEvent event) {
          if (selectedIndexes.length == (crossAxisCount * crossAxisCount)) {
            Get.back();
            Get.snackbar(
                "Touch Calibration done!", "Your touch screen works very well");
          }
        },
        child: GridView.builder(
          key: key,
          itemCount: crossAxisCount * crossAxisCount,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: MediaQuery.of(context).size.width /
                MediaQuery.of(context).size.height,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          itemBuilder: (context, index) {
            return Foo(
              index: index,
              child: Container(
                color: selectedIndexes.contains(index)
                    ? Colors.yellow
                    : Colors.teal,
              ),
            );
          },
        ),
      ),
    );
  }

  void _clearSelection(PointerUpEvent event) {
    _trackTaped.clear();
    setState(() {
      selectedIndexes.clear();
    });
  }
}

class Foo extends SingleChildRenderObjectWidget {
  final int index;

  const Foo({Widget? child, required this.index, Key? key})
      : super(child: child, key: key);

  @override
  _Foo createRenderObject(BuildContext context) {
    return _Foo()..index = index;
  }

  @override
  void updateRenderObject(BuildContext context, _Foo renderObject) {
    renderObject.index = index;
  }
}

class _Foo extends RenderProxyBox {
  late int index;
}
