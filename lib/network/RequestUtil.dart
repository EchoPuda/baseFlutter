
import 'package:baseflutter/network/Address.dart';
import 'package:baseflutter/network/model/common_entity.dart';
import 'package:rxdart/rxdart.dart';

import 'HttpManager.dart';
import 'intercept/base_intercept.dart';
import 'model/test_model_entity.dart';

/// 请求管理
/// @author jm
class RequestUtil {

  /// 示例
  static PublishSubject<TestModelEntity> testRequest(BaseIntercept baseIntercept,String data) {
    return HttpManager().post(Address.TEST,baseIntercept: baseIntercept,queryParameters: {
      "data" : data
    });
  }

  /// 上传接口
  /// request： path
  static PublishSubject<CommonEntity> upload(BaseIntercept baseIntercept,String path,{String type : "image"}) {
    return HttpManager().upload("http://upload", path,type: type, queryParameters: {});
  }

}