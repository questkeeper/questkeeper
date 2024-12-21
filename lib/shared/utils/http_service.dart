import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A service class for making HTTP requests using the Dio library.
/// It handles errors and adds authentication headers to requests.
class HttpService {
  final Dio _dio;
  final _supabaseClient = Supabase.instance.client;

  Dio get dio => _dio;

  /// Creates a new instance of the [HttpService] class.
  /// Initializes a [Dio] instance with base options and adds an interceptor to
  /// handle errors and add authentication headers to requests.
  HttpService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseApiUri,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        )..addSentry() {
    // Only use HTTP/2 in production
    if (!isDebug) {
      _dio.httpClientAdapter = Http2Adapter(
        ConnectionManager(
          idleTimeout: const Duration(seconds: 10),
        ),
      );
    }

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = _supabaseClient.auth.currentSession?.accessToken;
        final tokenExpiry = _supabaseClient.auth.currentSession!.expiresAt;
        final currentTimeInSeconds =
            DateTime.now().millisecondsSinceEpoch ~/ 1000;

        debugPrint(
            "Expires at $tokenExpiry but current time is $currentTimeInSeconds.");

        if (token == null ||
            tokenExpiry == null ||
            tokenExpiry > (currentTimeInSeconds - 10)) {
          debugPrint("Reinitalizing session with new token");
          final newSession = await _supabaseClient.auth.refreshSession();
          debugPrint(newSession.session.toString());
          token = newSession.session?.accessToken;
        }

        if (token == null) {
          throw Exception("Authentication failed");
        }

        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        _handleError(e);
        return handler.next(e);
      },
    ));
  }

  void _handleError(DioException e) {
    debugPrint("REQUEST DATA ******");
    debugPrint(e.requestOptions.headers.toString());
    debugPrint(e.requestOptions.data?.toString());
    debugPrint("RESPONSE DATA ******");
    debugPrint(e.response?.data.toString());
    SnackbarService.showErrorSnackbar(
      e.message ?? 'An error occurred',
    );
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters, bool ignoreCache = false}) async {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: ignoreCache ? {'Cache-Control': 'no-cache'} : null,
      ),
    );
  }

  Future<Response> post(String path,
      {Map<String, dynamic> data = const {}}) async {
    if (data.isEmpty) {
      throw Exception('No data provided');
    }
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return _dio.delete(path);
  }

  Future<Response> patch(String path, {Map<String, dynamic>? data}) async {
    return _dio.patch(path, data: data);
  }
}
