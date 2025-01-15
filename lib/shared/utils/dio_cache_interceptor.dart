import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// An interceptor for Dio that provides in-memory request caching
/// based on the request method, path, and query parameters.
///
/// The cache is stored in a map with the cache key being a combination
/// of the request method, path, and query parameters.
///
/// Timeout of 15s default
class DioCacheInterceptor extends Interceptor {
  final Duration timeout;
  final Map<String, _CacheEntry> _cache = {};
  final void Function(String message)? onLog;

  DioCacheInterceptor({
    this.timeout = const Duration(milliseconds: 15000),
    this.onLog,
  });

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Only cache GET requests
    if (response.requestOptions.method == 'GET') {
      final cacheKey = _createCacheKey(response.requestOptions);

      _cache[cacheKey] = _CacheEntry(
        response: Response(
          data: response.data,
          statusCode: response.statusCode,
          requestOptions: response.requestOptions,
          headers: response.headers,
        ),
        timestamp: DateTime.now(),
        timeout: timeout,
      );

      _log('Cached GET response for $cacheKey');
    }
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = _normalizedPath(options.path);

    // For non-GET requests, invalidate related caches
    if (options.method != 'GET') {
      _invalidateRelatedCaches(requestPath);
      super.onRequest(options, handler);
      return;
    }

    // For GET requests, check cache
    _cleanCache();
    final cacheKey = _createCacheKey(options);
    final entry = _cache[cacheKey];

    if (entry != null && !entry.isExpired) {
      _log('Cache hit for $cacheKey');
      handler.resolve(entry.response);
      return;
    }

    _log('Cache miss for $cacheKey');
    super.onRequest(options, handler);
  }

  String _createCacheKey(RequestOptions options) {
    return '${options.method}:${_normalizedPath(options.path)}:${options.queryParameters.toString()}';
  }

  String _normalizedPath(String path) {
    // Remove trailing slashes and normalize the path
    return path.replaceAll(RegExp(r'/+$'), '');
  }

  void _invalidateRelatedCaches(String path) {
    // Find all cache keys that contain this path and remove them
    _cache.removeWhere((key, _) => key.contains(path));
    _log('Invalidated caches related to $path');
  }

  void _cleanCache() {
    final before = _cache.length;
    _cache.removeWhere((_, entry) => entry.isExpired);
    final removed = before - _cache.length;

    if (removed > 0) {
      _log('Cleaned $removed expired cache entries');
    }
  }

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('🔧 DioCacheInterceptor: $message');
    }
    onLog?.call(message);
  }

  /// Manually invalidate cache for a specific path
  void invalidateCache(String path) {
    _invalidateRelatedCaches(_normalizedPath(path));
  }

  /// Manually clear all cached entries
  void clearCache() {
    _cache.clear();
    _log('Cache cleared');
  }
}

/// Basic model for handling the cache entries
class _CacheEntry {
  final Response response;
  final DateTime timestamp;
  final Duration timeout;

  _CacheEntry({
    required this.response,
    required this.timestamp,
    required this.timeout,
  });

  bool get isExpired {
    return DateTime.now().difference(timestamp) > timeout;
  }
}
