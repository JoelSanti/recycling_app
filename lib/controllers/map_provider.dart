import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recycling_app/helpers/image_to_bytes.dart';

class MapNotifier extends ChangeNotifier {
  Position? _initialPosition ;
  Position? get initialPosition => _initialPosition;

  final Set<Marker> markers = {};
  bool _loading = true;
  bool get loading => _loading;
  late bool _gpsEnabled;
  bool get gpsEnabled => _gpsEnabled;

  StreamSubscription? _gpsSubscription;

  MapNotifier() {
    _init();
  }

  void addMarker(Marker marker) {
    markers.add(marker);
    notifyListeners();
  }

  Future<void> _init() async {
    await _addInitialMarkers();
    _gpsEnabled = await  Geolocator.isLocationServiceEnabled();
    _loading = false;

    _gpsSubscription =  Geolocator.getServiceStatusStream().listen((status) async{
      _gpsEnabled = status == ServiceStatus.enabled;
      await _getInitialPosition();
      notifyListeners();
    });
    await _getInitialPosition();

    notifyListeners();
  }

  Future<void> _getInitialPosition() async {
    if(_gpsEnabled){
      _initialPosition = await Geolocator.getCurrentPosition();
    }
  }

  Future<void> turnOnGPS() async {
    if (!gpsEnabled) {
      await Geolocator.openLocationSettings();
    }
  }

  Future<void> _addInitialMarkers() async {
    String jsonString = await rootBundle.loadString('assets/data/my_data_points_calendary.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    final customIcon = BitmapDescriptor.fromBytes(
        await imageToBytes('assets/images/position_icon.png'));

    for (var punto in jsonData['Puntos_Reciclaje']) {
      LatLng position = LatLng(punto['latitud'], punto['longitud']);
      Marker marker = Marker(
        markerId: MarkerId('marker${punto['id_punto']}'),
        position: position,
        icon: customIcon,
      );
      addMarker(marker);
    }
  }

  @override
  void  dispose(){
    _gpsSubscription?.cancel();
    super.dispose();
  }

}