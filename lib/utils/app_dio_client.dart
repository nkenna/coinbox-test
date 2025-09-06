import 'dart:convert';
import 'dart:io';

import 'package:coin_box_test/utils/app_logger.dart';
import 'package:coin_box_test/utils/app_snackbar.dart';
import 'package:coin_box_test/utils/config.dart';
import 'package:dio/dio.dart';

class AppDioClient {
  AppDioClient._privateConstructor();
  static final AppDioClient instance = AppDioClient._privateConstructor();
  Dio? myDioClient;


  Future<void> initializeDio() async{
    var options = BaseOptions(
        baseUrl: Config.BASE_URL,
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000)
    );

    myDioClient =  Dio(options);
  }

  dynamic dioErrorReturner(dynamic error, {bool showMessage = true}){
    AppLogger.instance.logInfo(error);
    AppLogger.instance.appLogger!.e(error.response);


    if(error is DioException){
      switch (error.type){
        case DioExceptionType.connectionTimeout:
          AppLogger.instance.logError("This operation failed. Timeout connecting to server");
          if(showMessage) showErrorBar("This operation failed. Timeout connecting to server");
          return null;
        case DioExceptionType.sendTimeout:
          AppLogger.instance.logError("This operation failed. Timeout sending request");
          if(showMessage) showErrorBar("This operation failed. Timeout sending request");
          return null;
        case DioExceptionType.receiveTimeout:
          AppLogger.instance.logError("This operation failed. Timeout receiving response");
          if(showMessage) showErrorBar("This operation failed. Timeout receiving response");
          return null;
        case DioExceptionType.badCertificate:
          AppLogger.instance.logError("This operation failed. Bad certificate");
          if(showMessage) showErrorBar("This operation failed. Bad certificate");
          return null;

        case DioExceptionType.badResponse:
          AppLogger.instance.logError("This operation failed. Bad response");
          var errorMsg = 'This operation failed. Bad response';
          if(showMessage) showErrorBar("This operation failed. Bad response");
          if(error.response != null){
            return error.response;
          }
          else {
            return null;
          }



        case DioExceptionType.cancel:
          AppLogger.instance.logError("This operation was cancelled. Try again.");
          if(showMessage){
            showErrorBar("This operation was cancelled. Try again.");
          }

          return null;
        case DioExceptionType.connectionError:
          AppLogger.instance.logError("It seems you are having network issues. Please check the internet connectivity and try again.");
          if(showMessage) showErrorBar("It seems you are having network issues. Please check the internet connectivity and try again.");
          return null;
        case DioExceptionType.unknown:
          return null;
      }
    }
    else {
      if(error.response != null){
        AppLogger.instance.appLogger!.e(error.response.statusCode);
        AppLogger.instance.appLogger!.e(error.response);
        //ErrorLogger.logNonFatalError(error, null, error.response);

        return error.response;
      }
      else{
        AppLogger.instance.appLogger!.e(error);
        AppLogger.instance.appLogger!.e(error.message);
        AppLogger.instance.appLogger!.e(error.requestOptions);
        //ErrorLogger.logNonFatalError(error, null, error.message);
        return null;
      }
    }

  }

  Future<Response> dioGet(url, options){
    return myDioClient!.get(url, options: options);
  }

  Future<Response> dioPost(url, data, Options options){
    AppLogger.instance.logInfo('request contentype: ${options.contentType}');
    AppLogger.instance.logInfo('request headers: ${options.headers}');
    AppLogger.instance.logInfo('request extras: ${options.extra}');
    AppLogger.instance.logInfo('request extras: ${options.receiveTimeout}');

    return myDioClient!.post(url, data: json.encode(data), options: options);
  }

  Future<Response> dioPut(url, data, Options options){
    AppLogger.instance.logInfo('request contentype: ${options.contentType}');
    AppLogger.instance.logInfo('request headers: ${options.headers}');
    AppLogger.instance.logInfo('request extras: ${options.extra}');
    AppLogger.instance.logInfo('request extras: ${options.receiveTimeout}');

    return myDioClient!.put(url, data: json.encode(data), options: options);
  }

  Future<Response> dioUpload(url, data, options){
    return myDioClient!.post(url, data: data, options: options, onSendProgress: (a, b){
      AppLogger.instance.logInfo('$a ::: $b');
    });
  }

  Future<Response> dioRequest(url, data, options){
    return myDioClient!.request(
        url,
        queryParameters: data,
        options: options
    );
  }

  Future<Response> dioDelete(url, data, options){
    return myDioClient!.delete(
        url,
        queryParameters: data,
        options: options
    );
  }

  Future<Options>  getOptionsWithToken() async{
    String? token = Config.API_KEY;
    //AppLogger.instance.logInfo('token:: $token');
    return Options(
        contentType: 'application/json',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }
    );
  }

  Future<Options>  getOptionsWithTokenForExport() async{
    String? token = Config.API_KEY;
    AppLogger.instance.logInfo('token:: $token');
    return Options(
        contentType: 'application/octet-stream',
        responseType: ResponseType.bytes,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/octet-stream',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }
    );
  }

  Options getOptionsWithoutToken(){
    return Options(
        contentType: 'application/json',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        }
        );
  }

  Future<Options> getOptionsForFormData() async{
    String? token = Config.API_KEY;
    return Options(
        contentType: 'multipart/form-data',
        headers: {
          HttpHeaders.contentTypeHeader: 'multipart/form-data',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }
    );
  }

  Future downloadImageFile({String? imageUrl, String? savePath}) async{
    final response = await Dio().download(
        imageUrl!,
        savePath,
        onReceiveProgress: (received, total){
          if (total != -1) {
            // Calculate download progress if needed
            final progress = (received / total * 100).toStringAsFixed(0);
            AppLogger.instance.logInfo('Download progress: $progress%');
          }
        }
    );

    AppLogger.instance.logDebugMsg('download response: ${response}');

    return savePath;
  }

}