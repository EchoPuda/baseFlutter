import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'dimens.dart';

/// 样式
class TextStyles {

  static TextStyle titleRightStyle = TextStyle(
    fontSize: MyDimens.title_size,
    color: MyColors.text_font_black,
  );

  static TextStyle titleStyle = TextStyle(
      fontSize: MyDimens.title_size,
      color: MyColors.text_font_black
  );

  static TextStyle titleStyleWhite = TextStyle(
      fontSize: MyDimens.title_size,
      color: MyColors.white
  );

  static TextStyle fontStyle = TextStyle(
      fontSize: MyDimens.font_size,
      color: MyColors.text_font_black
  );

  static TextStyle fontHintStyle = TextStyle(
      fontSize: MyDimens.hint_font_size,
      color: MyColors.text_font_grey
  );

  static TextStyle buttonTextStyle = TextStyle(
      fontSize: MyDimens.button_size,
      color: MyColors.white
  );

  static TextStyle bottomNavigationBarTitleStyle = TextStyle(
      fontSize: MyDimens.bottom_navigation_font_size,
      color: MyColors.text_font_red
  );

}

class Styles {

  ///通用阴影
  static const BoxShadow commonShadow = BoxShadow(
      color: MyColors.shadow,
      offset: Offset(0, 4.0),
      blurRadius: 3.0
  );

  ///通用阴影盒子背景
  static BoxDecoration commonShadowBox = BoxDecoration(
    borderRadius: BorderRadius.circular(6.0),
    color: MyColors.white,
    boxShadow: [Styles.commonShadow],
  );
}