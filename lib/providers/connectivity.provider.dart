import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = true;

  /// ℹ️ NOTE: In iOS Device Simulator, going from online -> offline works.
  /// But offline -> online is a known issue that doesn't happen in prod, so don't worry.
  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    init();
  }

  Future<void> init() async {
    // Check initial connectivity status
    await _checkConnectivity();

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateConnectivityStatus(results);
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectivityStatus(result);
    } catch (e) {
      _isOnline = false;
      notifyListeners();
    }
  }

  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);

    debugPrint("[CONNECTIVITY] changed: $_isOnline | $results");

    if (_isOnline != wasOnline) {
      notifyListeners();
    }
  }
}

ConnectivityProvider useConnectivityProvider(
  BuildContext context, {
  bool listen = true,
}) {
  return Provider.of<ConnectivityProvider>(context, listen: listen);
}
