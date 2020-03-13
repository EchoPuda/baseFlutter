
import 'package:rxdart/rxdart.dart';

import 'HttpManager.dart';
import 'intercept/base_intercept.dart';
import 'model/test_model_entity.dart';

///
/// @author puppet
class RequestUtil {
  static PublishSubject testErrorrequest(BaseIntercept baseIntercept) {
    String urlError = "error";
    return HttpManager().get<TestModelEntity>(urlError = "error",
        baseIntercept: baseIntercept);
  }
}