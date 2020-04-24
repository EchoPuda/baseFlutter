import 'dart:convert';

import 'package:baseflutter/generated/json/base/json_convert_content.dart';

import '../HttpManager.dart';
import 'Transform.dart';


class ApiFullTransform<T> extends ResponseTransform<T>{
  ApiFullTransform() : super();

  @override
  void apply(String data, {bool isShowErrorToast}) {

    int code = json.decode(data)["code"];

    if (code != 200) {
      String message = json.decode(data.toString())["message"];
      print("错误信息：" + message);
      callError(
        MyError(code, message),
        isShowErrorToast: isShowErrorToast,
      );
    } else {
      //这里的解析 请参照 https://www.jianshu.com/p/e909f3f936d6 , dart的字符串 解析蛋碎一地
      add(JsonConvert.fromJsonAsT<T>(json.decode(data)));
    }

  }
}