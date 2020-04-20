
import 'dart:convert';
import 'dart:io';

import 'package:baseflutter/base/buildConfig.dart';
import 'package:baseflutter/base/common/common.dart';
import 'package:baseflutter/generated/json/base/json_convert_content.dart';
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

  //get请求
  PublishSubject<T> get<T>(
      String url, {
        Map<String, dynamic> queryParameters,
        BaseIntercept baseIntercept,
        bool isCancelable = true,
      }) {
    return _requstHttp<T>(
        url, true, queryParameters, baseIntercept, isCancelable,false);
  }

  //post请求
  PublishSubject<T> post<T>(String url,
      {Map<String, dynamic> queryParameters,
        BaseIntercept baseIntercept,
        bool isCancelable = true,
        bool isSHowErrorToast = true}) {
    return _requstHttp<T>(url, false, queryParameters,
        baseIntercept, isCancelable,isSHowErrorToast);
  }

  //上传（post）请求
  PublishSubject<T> upload<T>(String url, String path,
      {String type : "image",
        Map<String, dynamic> queryParameters,
        BaseIntercept baseIntercept,
        bool isCancelable = true,
        bool isSHowErrorToast = true}) {
    return _requestUpload<T>(url, path,type,
        false, queryParameters,
        baseIntercept, isCancelable);
  }

  /// 参数说明  url 请求路径
  /// queryParamerers  是 请求参数
  /// baseWidget和baseInnerWidgetState用于 加载loading 和 设置 取消CancelToken
  /// isCancelable 是设置改请求是否 能被取消 ， 必须建立在 传入baseWidget或者baseInnerWidgetState的基础之上
  /// isShowLoading 设置是否能显示 加载loading , 同样要建立在传入 baseWidget或者 baseInnerWidgetState 基础之上
  /// isShowErrorToaet  这个是 设置请求失败后 是否要 吐司的
  PublishSubject<T> _requstHttp<T>(String url,
      [bool isGet,
        queryParameters,
        BaseIntercept baseIntercept,
        bool isCancelable,
        bool isShowErrorToast
      ]) {
    Future future;
    PublishSubject<T> publishSubject = PublishSubject<T>();
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
      String errorMessage = "";
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorMessage = "与服务器连接超时";
      } else {
        errorMessage = "与服务器连接发生错误";
      }

      if (Commons.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常url: ' + url);
        if (queryParameters != null) {
          print('请求异常参数: ' + queryParameters.toString());
        }
      }
      callError(
        publishSubject,
        MyError(500, errorMessage),
        baseIntercept,
        isShowErrorToast: isShowErrorToast,
      );
    }


    future.then((data) {

      if (Commons.DEBUG) {
        print('请求url: ' + url);
        print('请求token: ' + cancelToken.toString());
        if (queryParameters != null) {
          print('请求参数: ' + queryParameters.toString());
        }
        if (future != null) {
          print('返回参数: ' + future.toString());
        }
      }

      //这里要做错误处理, 与后台约定好code，message等参数
      int code = json.decode(data.toString())["code"];

//      print("---responseData----${data}-----");
      if (code != 200) {
        String message = json.decode(data.toString())["message"];
        print("错误信息：" + message);
        callError(
          publishSubject,
          MyError(code, message),
          baseIntercept,
          isShowErrorToast: isShowErrorToast,
        );
      } else {
        //这里的解析 请参照 https://www.jianshu.com/p/e909f3f936d6 , dart的字符串 解析蛋碎一地
        publishSubject
            .add(JsonConvert.fromJsonAsT<T>(json.decode(data.toString())));
        publishSubject.close();

        cancelLoading(baseIntercept);
      }
    }).catchError((err) {
      callError(
        publishSubject,
        MyError(1, err.toString()),
        baseIntercept,
        isShowErrorToast: isShowErrorToast,);
    });

    return publishSubject;
  }

  ///上传请求
  PublishSubject<T> _requestUpload<T>(
      String url,
      String path,
      [String type,
        bool isGet,
        queryParameters,
        BaseIntercept baseIntercept,
        bool isCancelable]) {
    Future future;
    PublishSubject<T> publishSubject = PublishSubject<T>();
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
      String errorMessage = "";
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorMessage = "与服务器连接超时";
      } else {
        errorMessage = "与服务器连接发生错误";
      }

      if (Commons.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常url: ' + url);
        if (queryParameters != null) {
          print('请求异常参数: ' + queryParameters.toString());
        }
      }
      callError(
        publishSubject,
        MyError(500, errorMessage),
        baseIntercept,
      );
    }

    future.then((data){

      if (Commons.DEBUG) {
        print('请求url: ' + url);
        print('请求token: ' + cancelToken.toString());
        if (queryParameters != null) {
          print('请求参数: ' + queryParameters.toString());
        }
        if (future != null) {
          print('返回参数: ' + future.toString());
        }
      }

      bool isError = json.decode(data.toString())["error"];
      if (isError) {
        callError(
          publishSubject,
          MyError(10, "请求失败~"),
          baseIntercept,
        );
      } else {
        publishSubject
            .add(JsonConvert.fromJsonAsT<T>(json.decode(data.toString())));
        publishSubject.close();

        cancelLoading(baseIntercept);
      }
    });

    return publishSubject;
  }

  ///上传请求,多个文件上传
  PublishSubject<T> _requestUploads<T>(
      String url,
      List<String> paths,
      [bool isGet,
        queryParameters,
        BaseIntercept baseIntercept,
        bool isCancelable]) {
    Future future;
    PublishSubject<T> publishSubject = PublishSubject<T>();
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
      String errorMessage = "";
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorMessage = "与服务器连接超时";
      } else {
        errorMessage = "与服务器连接发生错误";
      }

      if (Commons.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常url: ' + url);
        if (queryParameters != null) {
          print('请求异常参数: ' + queryParameters.toString());
        }
      }
      callError(
        publishSubject,
        MyError(500, errorMessage),
        baseIntercept,
      );
    }

    future.then((data){

      if (Commons.DEBUG) {
        print('请求url: ' + url);
        print('请求token: ' + cancelToken.toString());
        if (queryParameters != null) {
          print('请求参数: ' + queryParameters.toString());
        }
        if (future != null) {
          print('返回参数: ' + future.toString());
        }
      }

      bool isError = json.decode(data.toString())["error"];
      if (isError) {
        callError(
          publishSubject,
          MyError(10, "请求失败~"),
          baseIntercept,
        );
      } else {
        publishSubject
            .add(JsonConvert.fromJsonAsT<T>(json.decode(data.toString())));
        publishSubject.close();

        cancelLoading(baseIntercept);
      }
    });

    return publishSubject;
  }

  ///请求错误以后 做的一些事情
  void callError(PublishSubject publishSubject, MyError error,
      BaseIntercept baseIntercept,{bool isShowErrorToast : true}) {
    publishSubject.addError(error);

    if (isShowErrorToast) {
      showErrorToast(error.message);
    }

    publishSubject.close();
    cancelLoading(baseIntercept);
    if (baseIntercept != null) {
      baseIntercept.requestFailure(error.message);
    }
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
//    _dio.options.baseUrl = "http://10.150.20.86/xloan-app-api/";
    _dio.options.baseUrl = "http://gank.io/api/";
    _dio.options.connectTimeout = CONNECR_TIME_OUT; //5s
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

    //证书配置
//    String PEM="XXXXX"; // certificate content
//    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
//      client.badCertificateCallback=(X509Certificate cert, String host, int port){
//        if(cert.pem==PEM){ // Verify the certificate
//          return true;
//        }
//        return false;
//      };
//    };

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
}

class MyError {
  int code;
  String message;
  MyError(this.code, this.message);
}