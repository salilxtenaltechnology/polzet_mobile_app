import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = true;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _subscription;

  bool get isConnected => _isConnected;

  ConnectivityProvider() {
    startMonitoring();
  }

  void startMonitoring() async {
    _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _isConnected = results.isNotEmpty && results.first != ConnectivityResult.none;
      notifyListeners();
    });

    final initialResult = await _connectivity.checkConnectivity();
    _isConnected = initialResult != ConnectivityResult.none;
    notifyListeners();
  }

  void disposeStream() {
    _subscription.cancel();
  }
}
