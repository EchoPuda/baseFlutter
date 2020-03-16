import 'package:baseflutter/base/common/commonInsert.dart';

/// 屏幕适配 (谨慎使用)
/// @author jm
class ScreenAdapter {

  ///屏幕大小
  static double screenWidth = 300;
  static double designWidth = 300;
  static double screenHeight = 800;
  static double designHeight = 800;

  static getWidth(double width) {
    return width * (screenWidth / designWidth);
  }

  static getHeight(double height) {
    return height * (screenHeight / designHeight);
  }
}