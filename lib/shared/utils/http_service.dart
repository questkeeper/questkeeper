import 'package:dio/dio.dart';
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HttpService {
  final Dio _dio;
  final _supabaseClient = Supabase.instance.client;

  Dio get dio => _dio;

  HttpService()
      : _dio = Dio(BaseOptions(
          baseUrl: baseApiUri,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] =
            'Bearer ${_supabaseClient.auth.currentSession!.accessToken}';
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
