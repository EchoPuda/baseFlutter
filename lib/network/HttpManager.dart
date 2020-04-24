
import 'dart:convert';
import 'dart:io';

import 'package:baseflutter/base/buildConfig.dart';
import 'package:baseflutter/base/common/common.dart';
import 'package:baseflutter/generated/json/base/json_convert_content.dart';
import 'package:baseflutter/network/response/ApiFullTransform.dart';
import 'package:baseflutter/network/response/ApiStringTransform.dart';
import 'package:baseflutter/network/response/Transform.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

import '../base/common/commonInsert.dart';
import 'MyIntercept.dart';
import 'intercept/base_intercept.dart';

/// http请求
/// @author jm
class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  static Dio _dio;
  static final int CONNECR_TIME_OUT = 5000;
  static final int RECIVE_TIME_OUT = 3000;

  static Map<String, CancelToken> _cancelTokens =
      new Map<String, CancelToken>();

  HttpManager._internal() {
    initDio();
  }

  static HttpManager _httpManger = HttpManager._internal();

  factory HttpManager() {
    return _httpManger;
  }

  ///get请求
  Future<T> get<T>(
      String url, {ResponseTransform<T> transform,
        Map<String, dynamic> queryParameters,
        BaseIntercept baseIntercept,
        bool isCancelable = true,
      }) {
    return _requstHttp<T>(
        url, transform, true, queryParameters, baseIntercept, isCancelable,false);
  }

  ///post请求
  Future<T> post<T>(String url,
      {ResponseTransform<T> transform,
      Map<String, dynamic> queryParameters,
        BaseIntercept baseIntercept,
        bool isCancelable = true,
        bool isSHowErrorToast = true}) {
    return _requstHttp<T>(url,transform, false, queryParameters,
        baseIntercept, isCancelable, isSHowErrorToast);
  }

  ///上传（post）请求
  Future<T> upload<T>(String url, String path,
      {ResponseTransform<T> transform,
      String type : "image",
        Map<String, dynamic> queryParameters,
        BaseIntercept baseIntercept,
        bool isCancelable = true,
        bool isSHowErrorToast = true}) {
    return _requestUpload<T>(url, path,transform,type,
        false, queryParameters,
        baseIntercept, isCancelable);
  }

  /// [url] 请求路径
  /// [queryParameters]  请求参数
  /// [transform] 请求结果处理的转换器, 可以控制自定义返回的内容
  /// [baseIntercept] 配合基类 控制 加载loading 和 设置 取消CancelToken
  /// [isCancelable] 是设置改请求是否 能被取消 ， 必须建立在 传入baseWidget或者baseInnerWidgetState的基础之上
  /// [isShowLoading] 设置是否能显示 加载loading , 同样要建立在传入 baseWidget或者 baseInnerWidgetState 基础之上
  /// [isShowErrorToast]  这个是 设置请求失败后 是否要 吐司的
  Future<T> _requstHttp<T>(String url, ResponseTransform<T> transform,
      [bool isGet,
        queryParameters,
        BaseIntercept baseIntercept,
        bool isCancelable,
        bool isShowErrorToast,
      ]) {
    Future future;

    if (transform == null) {
      transform = ApiFullTransform();
    }
//    PublishSubject<T> publishSubject = PublishSubject<T>();

    Completer<T> completer = new Completer();

    transform.setBaseIntercept(baseIntercept);
    transform.setPublishPubject(completer);

    CancelToken cancelToken;

    _setInterceptOrcancelAble(baseIntercept, isCancelable, cancelToken);

    try {
      if (isGet) {
        future = _dio.get(url,
            queryParameters: queryParameters, cancelToken: cancelToken);
      } else {
        future = _dio.post(url, data: queryParameters, cancelToken: cancelToken);
      }
    } on DioError catch (e) {
      if (Commons.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常url: ' + url);
        if (queryParameters != null) {
          print('请求异常参数: ' + queryParameters.toString());
        }
      }
      _doError(e, transform);
    }

    future.then((data) {
      if (Commons.DEBUG) {
        print('请求url: ' + url);
        print('请求token: ' + (LocalStorage.get(Commons.TOKEN) ?? ""));
        if (queryParameters != null) {
          print('请求参数: ' + queryParameters.toString());
        }
        if (future != null) {
          print('返回参数: ' + data.toString());
        }
      }

      transform.apply(data.toString(), isShowErrorToast: isShowErrorToast);

    }).catchError((err) {
      _doError(err, transform);
    });

    return completer.future;
  }

  ///上传请求
  Future<T> _requestUpload<T>(
      String url,
      String path,
      ResponseTransform<T> transform,
      [String type,
        bool isGet,
        queryParameters,
        BaseIntercept baseIntercept,
        bool isCancelable]) {
    Future future;

    if (transform == null) {
      transform = ApiFullTransform();
    }
//    PublishSubject<T> publishSubject = PublishSubject<T>();

    Completer<T> completer = new Completer();

    transform.setBaseIntercept(baseIntercept);
    transform.setPublishPubject(completer);

    CancelToken cancelToken;

    _setInterceptOrcancelAble(baseIntercept, isCancelable, cancelToken);

    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);

    FormData formData = new FormData.fromMap({
      "filtType": "image",
      "file":  MultipartFile.fromFileSync(
        path,
        filename: name,
//        contentType: MediaType.parse("image/$suffix"),
      )
    });

    try {
      if (isGet) {
        print("上传请使用post-------------");
      } else {
        future = _dio.post(url, data: formData, cancelToken: cancelToken);
      }
    } on DioError catch (e) {
      if (Commons.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常url: ' + url);
        if (queryParameters != null) {
          print('请求异常参数: ' + queryParameters.toString());
        }
      }
      _doError(e, transform);
    }

    future.then((data) {
      if (Commons.DEBUG) {
        print('请求url: ' + url);
        print('请求token: ' + (LocalStorage.get(Commons.TOKEN) ?? ""));
        if (queryParameters != null) {
          print('请求参数: ' + queryParameters.toString());
        }
        if (future != null) {
          print('返回参数: ' + data.toString());
        }
      }

      transform.apply(data.toString());

    }).catchError((err) {
      _doError(err, transform);
    });

    return completer.future;

  }

  ///上传请求,多个文件上传
  Future<T> _requestUploads<T>(
      String url,
      List<String> paths,
      ResponseTransform<T> transform,
      [bool isGet,
        queryParameters,
        BaseIntercept baseIntercept,
        bool isCancelable]) {
    Future future;

    if (transform == null) {
      transform = ApiFullTransform();
    }
//    PublishSubject<T> publishSubject = PublishSubject<T>();

    Completer<T> completer = new Completer();

    transform.setBaseIntercept(baseIntercept);
    transform.setPublishPubject(completer);

    CancelToken cancelToken;

    _setInterceptOrcancelAble(baseIntercept, isCancelable, cancelToken);

    List<MultipartFile> listPath = new List();
    paths.forEach((path) {
      var name = path.substring(path.lastIndexOf("/") + 1, path.length);
      var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);

      listPath.add(
          MultipartFile.fromFileSync(
            path,
            filename: name,
//        contentType: MediaType.parse("image/$suffix"),
          )
      );
    });
    FormData formData = new FormData.fromMap({
      "filtType": "image",
      "files":  listPath
    });

    try {
      if (isGet) {
        print("上传请使用post-------------");
      } else {
        future = _dio.post(url, data: formData, cancelToken: cancelToken);
      }
    } on DioError catch (e) {
      if (Commons.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常url: ' + url);
        if (queryParameters != null) {
          print('请求异常参数: ' + queryParameters.toString());
        }
      }
      _doError(e, transform);
    }

    future.then((data) {
      if (Commons.DEBUG) {
        print('请求url: ' + url);
        print('请求token: ' + (LocalStorage.get(Commons.TOKEN) ?? ""));
        if (queryParameters != null) {
          print('请求参数: ' + queryParameters.toString());
        }
        if (data != null) {
          print('返回参数: ' + data.toString());
        }
      }

      transform.apply(data.toString());

    }).catchError((err) {
      _doError(err, transform);
    });

    return completer.future;
  }

  ///取消请求
  static void cancelHttp(String tag) {
    if (_cancelTokens.containsKey(tag)) {
      if (!_cancelTokens[tag].isCancelled) {
        _cancelTokens[tag].cancel();
      }
      _cancelTokens.remove(tag);
    }
  }

  ///配置dio
  void initDio() {
    _dio = Dio();
    // 配置dio实例
    _dio.options.baseUrl = "";
    _dio.options.connectTimeout = CONNECR_TIME_OUT;
    _dio.options.receiveTimeout = RECIVE_TIME_OUT;

//代理设置
    if (BuildConfig.isDebug) {
      //此处可以增加配置项，留一个设置代理的用户给测试人员配置，然后动态读取

      //TODO 代理配置可以设置

//      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//          (client) {
//        // config the http client
//        client.findProxy = (uri) {
//          //proxy all request to localhost:8888
//          return "PROXY 10.5.39.111:8888";
//        };
//        // you can also create a new HttpClient to dio
//        // return new HttpClient();
//      };
    }

    //证书配置 ， 忽略证书
    String PEM = "XXXXX"; // certificate content
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true; //返回 true 表明 忽略 证书校验
      };
    };

    /// 添加自己的拦截器
    _dio.interceptors.add(new MyIntercept());
  }

  ///测试是否真的 可以清除 的方法
  static void ListCancelTokens() {
    _cancelTokens.forEach((key, value) {
      print("${key}-----cancel---");
    });
  }

  //配置是否 显示 loading 和 是否能被取消
  void _setInterceptOrcancelAble(
      BaseIntercept baseIntercept, bool isCancelable, CancelToken cancelToken) {
    if (baseIntercept != null) {
      baseIntercept.beforeRequest();
      //为了 能够取消 请求
      if (isCancelable) {
        cancelToken = _cancelTokens[baseIntercept.getClassName()] == null
            ? CancelToken()
            : _cancelTokens[baseIntercept.getClassName()];
        _cancelTokens[baseIntercept.getClassName()] = cancelToken;
      }
    }
  }

  void showErrorToast(String message) {
    showToast(message);
  }

  void cancelLoading(BaseIntercept baseIntercept) {
    if (baseIntercept != null) {
      baseIntercept.afterRequest();
    }
  }

  ///过滤网络出错的情况
  ///根据情况可以自定
  void _doError(err, ResponseTransform transform) {
    try {
      if (err is DioError) {
        if (err.type == DioErrorType.CANCEL) {
          print("---请求取消---");
        } else if (err.type == DioErrorType.CONNECT_TIMEOUT ||
            err.type == DioErrorType.RECEIVE_TIMEOUT) {
          transform.callError(MyError(400, "连接超时"));
        } else if (err.response != null) {
          transform
              .callError(MyError(err.response.statusCode, "${err.message}"));
        } else {
          transform.callError(MyError(400, "${err.message}"));
        }
      } else if (err is SocketException) {
        transform.callError(MyError(400, "网路异常"));
      } else {
        transform.callError(MyError(1, err.toString()));
      }
    } catch (err2) {
      transform.callError(MyError(400, "网络异常，请稍后重试"));
    }
  }

}

class MyError {
  int code;
  String message;
  MyError(this.code, this.message);
}