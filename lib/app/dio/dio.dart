// Package imports:
import 'package:dio/dio.dart';
import 'package:inshort_clone/common/utils/logger.dart';

// Project imports:
import 'package:inshort_clone/global/global.dart';

class GetDio {
  GetDio._();

  static Dio getDio() {
    Dio dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.connectTimeout = const Duration(milliseconds: 90000);
          options.receiveTimeout = const Duration(milliseconds: 90000);
          options.sendTimeout = const Duration(milliseconds: 90000);
          options.followRedirects = true;
          options.baseUrl = "https://newsapi.org/v2/";
          options.headers["X-Api-Key"] = "${Global.apikey}";

          handler.next(options);
        },
        onResponse: (response, handler) async {
          handler.next(response);
        },
        onError: (DioException dioError, handler) async {
          if (dioError.type == DioExceptionType.unknown) {
            if (dioError.message?.contains('SocketException') ?? false) {
              logMessage('no internet');
            }
          }

          handler.next(dioError); //continue
        },
      ),
    );
    return dio;
  }
}
