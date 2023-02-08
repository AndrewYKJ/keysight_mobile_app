import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keysight_pma/controller/splash_screen.dart';

import '../cache/appcache.dart';
import 'interceptor/logging.dart';

class DioRepo {
  late Dio mDio;
  int retryCount = 0;
  late BuildContext dioContext;

  //kimatic-services    pma-mobile-services
  String devHost = "";
  String stgHost = "";
  String production = "";

  Dio baseConfig() {
    Dio dio = Dio();
    dio..options.baseUrl = devHost;
    dio..options.connectTimeout = 60000;
    dio..options.receiveTimeout = 60000;
    dio..httpClientAdapter;

    return dio;
  }

  DioRepo() {
    this.mDio = baseConfig();
    this.mDio
      ..interceptors.addAll([
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            this.mDio.interceptors.requestLock.lock();
            AppCache.getStringValue(AppCache.ACCESS_TOKEN_PREF).then((value) {
              if (value.length > 0) {
                options.headers[HttpHeaders.authorizationHeader] =
                    'Bearer ' + value;
              }
            }).whenComplete(() {
              this.mDio.interceptors.requestLock.unlock();
            });
            return handler.next(options);
          },
          onError: (e, handler) async {
            // if (e.response?.statusCode == 401) {
            //   if (this.retryCount < 3) {
            //     this.mDio.lock();
            //     this.mDio.interceptors.requestLock.lock();
            //     this.mDio.interceptors.responseLock.lock();
            //     return refreshTokenAndRetry(
            //         e.response!.requestOptions, handler);
            //   }

            //   showAlertDialog(
            //       e.response?.data['code'], e.response?.data['message']);
            //   return handler.next(e);
            // }

            return handler.next(e);
          },
          onResponse: (response, handler) async {
            return handler.next(response);
          },
        ),
        LoggingInterceptors()
      ]);
  }

  // Future<void> refreshTokenAndRetry(
  //     RequestOptions requestOptions, ErrorInterceptorHandler handler) async {
  //   bool isError = false;
  //   Dio tokenDio = baseConfig();
  //   tokenDio..interceptors.add(LoggingInterceptors());
  //   await AppCache.getStringValue(AppCache.REFRESH_TOKEN_PREF)
  //       .then((value) async {
  //     final refreshToken = value;
  //     final param = {'refreshToken': refreshToken};
  //     try {
  //       tokenDio
  //           .post(apiUserServer + '/auths/token/refresh', data: param)
  //           .then((res) {
  //         if (res.statusCode == 200) {
  //           AppCache.setString(
  //               AppCache.ACCESS_TOKEN_PREF, res.data['accessToken']);
  //         } else {
  //           isError = true;
  //           EasyLoading.dismiss();
  //           AppCache.removeValues();
  //           Navigator.pushAndRemoveUntil(
  //               this.dioContext,
  //               MaterialPageRoute(builder: (context) => SplashScreen()),
  //               (Route<dynamic> route) => false);
  //         }
  //       }).catchError((error) {
  //         isError = true;
  //         if (error is DioError) {
  //           if (error.response != null) {
  //             if (error.response!.data != null) {
  //               EasyLoading.dismiss();
  //               showAlertDialog(error.response!.data['code'],
  //                   error.response!.data['message']);
  //             } else {
  //               EasyLoading.dismiss();
  //               showAlertDialog('System Error',
  //                   'Opps, unexpected error has occured. Please try again later');
  //             }
  //           } else {
  //             AppCache.removeValues();
  //             EasyLoading.dismiss();
  //             Navigator.pushAndRemoveUntil(
  //                 this.dioContext,
  //                 MaterialPageRoute(builder: (context) => SplashScreen()),
  //                 (Route<dynamic> route) => false);
  //           }
  //         } else {
  //           AppCache.removeValues();
  //           EasyLoading.dismiss();
  //           Navigator.pushAndRemoveUntil(
  //               this.dioContext,
  //               MaterialPageRoute(builder: (context) => SplashScreen()),
  //               (Route<dynamic> route) => false);
  //         }
  //       }).whenComplete(() {
  //         this.mDio.unlock();
  //         this.mDio.interceptors.responseLock.unlock();
  //         this.mDio.interceptors.errorLock.unlock();
  //       }).then((e) {
  //         //repeat
  //         if (!isError) {
  //           this.retryCount++;
  //           this.mDio.fetch(requestOptions).then(
  //             (r) => handler.resolve(r),
  //             onError: (e) {
  //               handler.reject(e);
  //             },
  //           );
  //         }
  //       });
  //       // return;
  //     } on DioError catch (e) {
  //       print("Refresh Token Error : ${e.message}");
  //       showAlertDialog("Error", "An error occurred");
  //     }
  //   });
  // }

  // Future<Response> _retry(RequestOptions requestOptions) async {
  //   this.retryCount++;
  //   final options = new Options(
  //     method: requestOptions.method,
  //     headers: requestOptions.headers,
  //   );
  //   return this.mDio.request<dynamic>(requestOptions.path,
  //       data: requestOptions.data,
  //       queryParameters: requestOptions.queryParameters,
  //       options: options);
  // }

  void showAlertDialog(String title, String message) {
    showDialog(
      context: dioContext,
      barrierDismissible: false,
      builder: (_) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Close'),
            onPressed: () {
              AppCache.removeValues();
              EasyLoading.dismiss();
              Navigator.pushAndRemoveUntil(
                  this.dioContext,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
