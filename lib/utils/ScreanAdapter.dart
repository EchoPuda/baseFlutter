import 'package:baseflutter/base/common/commonInsert.dart';

/// 屏幕适配 (谨慎使用)
/// @author jm
class ScreenAdapter {
  static getWidth(double width) {
    return width * (Commons.screenWidth / Commons.designWidth);
  }

  static getHeight(double height) {
    return height * (Commons.screenHeight / Commons.designHeight);
  }
}