import 'package:coin_box_test/utils/app_dio_client.dart';
import 'package:coin_box_test/utils/app_logger.dart';
import 'package:dio/dio.dart';

class HttpService {
  Future<dynamic> post_request({Map<String, dynamic>? body, String? url, Options? options}) async {
    AppLogger.instance.logInfo(url);
    AppLogger.instance.logInfo(body);

    try {
      Response response = await AppDioClient.instance.dioPost(url, body, options!);
      AppLogger.instance.logInfo(response);
      return response;
    } on DioException catch (e) {
      AppLogger.instance.logError(e);
      return AppDioClient.instance.dioErrorReturner(e);
    }
  }

  Future<dynamic> put_request({Map<String, dynamic>? body, String? url, Options? options}) async {

    AppLogger.instance.logInfo(url);
    AppLogger.instance.logInfo(body);

    try {
      Response response = await AppDioClient.instance.dioPut(url, body, options!);
      AppLogger.instance.logInfo(response);
      return response;
    } on DioException catch (e) {
      AppLogger.instance.logError(e);
      return AppDioClient.instance.dioErrorReturner(e);
    }
  }

  Future<dynamic> get_request({Map<String, dynamic>? body, String? url, Options? options}) async {

    AppLogger.instance.logInfo(url);
    AppLogger.instance.logInfo(body);

    try {
      Response response = await AppDioClient.instance.dioRequest(url, body, options!);
      AppLogger.instance.logInfo(response.runtimeType);
      return response;
    } on DioException catch (e) {
      AppLogger.instance.logError(e);
      return AppDioClient.instance.dioErrorReturner(e);
    }
  }

  Future<dynamic> delete_request({Map<String, dynamic>? body, String? url, Options? options}) async {

    AppLogger.instance.logInfo(url);
    AppLogger.instance.logInfo(body);

    try {
      Response response = await AppDioClient.instance.dioDelete(url, body, options!);
      AppLogger.instance.logInfo(response);
      return response;
    } on DioException catch (e) {
      AppLogger.instance.logError(e);
      return AppDioClient.instance.dioErrorReturner(e);
    }
  }

  Future<dynamic> form_data_request({Map<String, dynamic>? body, String? url, Options? options}) async {

    AppLogger.instance.logInfo(url);
    AppLogger.instance.logInfo(body);

    FormData data = FormData.fromMap(body!);

    try {
      Response response = await AppDioClient.instance.dioUpload(url, data, options!);
      AppLogger.instance.logDebugMsg(response);
      return response;
    } on DioException catch (e) {
      AppLogger.instance.logError(e);
      return AppDioClient.instance.dioErrorReturner(e);
    }
  }
}