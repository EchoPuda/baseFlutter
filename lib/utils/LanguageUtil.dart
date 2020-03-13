import 'dart:convert';

import 'package:baseflutter/base/common/commonInsert.dart';
import 'package:flutter/services.dart';

/// 语言管理器
/// @author jm
class LanguageUtil {
//  //本地的语言获取切换方法
//  static String getText(String text) {
//    if (Commons.language == "eg") {
//      return MyStrings.languageMapEg[text];
//    } else {
//      return MyStrings.languageMapZh[text];
//    }
//  }

    ///-----------------------通过json文件导入语言-------------------------------
    static Map<String, dynamic> language = new Map();

    static SwitchLanguage currentLanguage = SwitchLanguage.zh;

    static String getText(String text) {
      if (language.containsKey(text)) {
        return language[text][_delWithLanguage(currentLanguage)];
      }
      return text;
    }

    static Future loadLanguage() async {
      await rootBundle.loadString("assets/language.json").then((value) {
        Map<String, dynamic> lanMap = json.decode(value);
        if (lanMap != null) {
          language = lanMap;
        } else {
          print("找不到language.json");
        }

      }).catchError((e) {
        print("loadError" + e.toString());
      });
    }

    /// 修改后需调用setState才能更新当前页面语言
    static void changeLanguage(SwitchLanguage language) {
      currentLanguage = language;
    }

    static String _delWithLanguage(SwitchLanguage lan) {
      String sLan = lan.toString();
      return sLan.split(".")[1];
    }

}

/// 语言开关，加一下自己需要的语言
enum SwitchLanguage {
  eg,zh
}