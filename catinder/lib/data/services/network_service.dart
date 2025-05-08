import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get onNetworkStatusChange => _controller.stream;

  NetworkService() {
    _connectivity.onConnectivityChanged.listen((result) {
      final hasConnection = result != ConnectivityResult.none;
      _controller.add(hasConnection);
    });
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _controller.close();
  }
}
