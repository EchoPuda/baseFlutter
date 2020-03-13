import 'dart:convert';

import 'package:baseflutter/base/common/commonInsert.dart';
import 'package:flutter/services.dart';

/// 语言管理器
/// @author puppet
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
      return "";
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

    static String _delWithLanguage(SwitchLanguage lan) {
      switch (lan) {
        case SwitchLanguage.eg:
          return "eg";
          break;
        case SwitchLanguage.zh:
          return "zh";
          break;
        default:
          return "zh";
          break;
      }
    }

}

enum SwitchLanguage {
  eg,zh
}