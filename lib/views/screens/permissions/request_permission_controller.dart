import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class RequestPermissionController {
  final Permission _locationPermission;

  RequestPermissionController(this._locationPermission);

  final _streamController = StreamController<PermissionStatus>.broadcast();

  Stream<PermissionStatus> get onStatusChange => _streamController.stream;

  Future<PermissionStatus> check() async {
    final status = await _locationPermission.status;
    return status;
  }

  Future<void> request() async {
    final status = await _locationPermission.request();
    _nofityStatus(status);
  }

  void _nofityStatus(PermissionStatus status) {
    if (!_streamController.isClosed && _streamController.hasListener) {
      _streamController.sink.add(status);
    }
  }

  dispose() {
    _streamController.close();
  }
}
