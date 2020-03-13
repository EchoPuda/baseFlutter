import 'package:baseflutter/base/common/commonInsert.dart';

/// 画出三角形
/// @author jm
class TrianglePainter extends CustomPainter {
  bool isDown;
  Color color;
  bool isLeft;

  TrianglePainter({this.isDown, this.color, this.isLeft}) : assert(isDown == null || isLeft == null);

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = new Paint();
    _paint.strokeWidth = 2.0;
    _paint.color = color;
    _paint.style = PaintingStyle.fill;

    Path path = new Path();
    if (isDown != null) {
      if (!isDown) {
        path.moveTo(size.width / 2.0, 0.0);
        path.lineTo(0.0, size.height + 1);
        path.lineTo(size.width, size.height + 1);
      } else {
        path.moveTo(0.0, -1.0);
        path.lineTo(size.width, -1.0);
        path.lineTo(size.width / 2.0, size.height);
      }
    }
    if (isLeft != null) {
      if (isLeft) {
        path.moveTo(0.0, (size.height + 1) / 2.0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height + 1);
      } else {
        path.moveTo(size.width, (size.height + 1) / 2.0);
        path.lineTo(0, 0.0);
        path.lineTo(0, size.height + 1);
      }
    }


    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}