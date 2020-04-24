
import 'package:baseflutter/network/Address.dart';
import 'package:baseflutter/network/model/article_test_entity.dart';
import 'package:baseflutter/network/model/common_entity.dart';
import 'package:rxdart/rxdart.dart';

import 'HttpManager.dart';
import 'intercept/base_intercept.dart';
import 'model/test_model_entity.dart';
import 'response/ApiFullTransform.dart';

/// 请求管理
/// @author jm
class RequestUtil {

  /// 示例
  static Future<TestModelEntity> testRequest(BaseIntercept baseIntercept,int id) {
    return HttpManager().post(Address.TEST,baseIntercept: baseIntercept,queryParameters: {
      "id" : id
    });
  }

  /// 上传接口
  /// request： path
  static Future<CommonEntity> upload(BaseIntercept baseIntercept,String path,{String type : "image"}) {
    return HttpManager().upload("http://upload", path,type: type, queryParameters: {});
  }

}