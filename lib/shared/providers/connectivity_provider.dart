import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

@riverpod
class ConnectivityNotifier extends _$ConnectivityNotifier {
  @override
  FutureOr<bool> build() async {
    final connectivity = await Connectivity().checkConnectivity();
    _listenToConnectivityChanges();
    return _isValidConnection(connectivity);
  }

  void _listenToConnectivityChanges() {
    Connectivity().onConnectivityChanged.listen((results) {
      state = AsyncData(
        _isValidConnection(results),
      );
    });
  }

  bool _isValidConnection(List<ConnectivityResult> results) {
    final isValid = results.every((result) =>
        result != ConnectivityResult.none &&
        result != ConnectivityResult.bluetooth);
    return isValid;
  }
}
